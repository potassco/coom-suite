"""
Clingo application class for solving COOM configuration problems with multi-shot solving using jump grounding.
"""

from typing import Any, Dict, List, Optional, Sequence, Set, Tuple

from clingo import Control
from clingo.symbol import Function, Number, Symbol

from coomsuite.utils import get_encoding

from . import next_bound_converge
from .multi_application import COOMMultiSolverApp, ProgPart


class COOMMultiSolverAppJump(COOMMultiSolverApp):  # pylint: disable=too-many-instance-attributes
    """
    Multishot application that grounds incremental program parts only at the bounds that are actually solved.

    Non-incremental program parts are still collected in steps of 1 but only grounded in one batch
    corresponding to the bound increase.
    Incremental programs parts are only added for the actual next bound.

    For incremental functions there are two possible modes:
    - extend: similar to the approach of grounding stepwise, the value for the new bound is obtained by extending the
      value of the previous bound and accounting for all objects betwwen the previous and the new bound
    - full: does not reuse the old value and recomputes the full aggregates
    """

    def __init__(
        self,
        serialized_facts: List[str],
        algorithm: str = "linear",
        initial_bound: int = 0,
        step: Optional[int] = 1,
        base: Optional[float] = 2.0,
        function_mode: str = "extend",
        log_level: str = "",
        options: Optional[Dict[str, Any]] = None,
        istest: bool = False,
    ):  # pylint: disable=too-many-arguments,too-many-positional-arguments
        super().__init__(serialized_facts, algorithm, initial_bound, step, base, log_level, options, istest)

        if function_mode not in ("extend", "full"):
            raise ValueError(f"unknown function mode for jump grounding: {function_mode}")
        self._function_mode: str = function_mode
        """The encoding used for incremental functions ("extend" or "full")"""

        self._grounded_incremental_bounds: Set[int] = set()
        """The set of bounds at which the incremental program parts have already been grounded"""
        self._function_grounded_bounds: Dict[str, Set[int]] = {}
        """For each incremental function the set of bounds at which it has already been grounded"""

    def _get_function_prog_part(self, args: Tuple[Symbol, ...], bound: int) -> ProgPart:
        """
        Get the incremental program part for a function at the given bound.

        If mode is full or the function has not been grounded yet, the full aggregate computation is used.
        Otherwise the program part that extends from the previous bound is used.

        Args:
            args (Tuple[Symbol, ...]): the arguments of the function expression (name, agg, path)
            bound (int): the bound to ground the function at

        Returns:
            ProgPart: the program part to ground the function at the given bound
        """
        name = args[0].string
        lower_bounds = {b for b in self._function_grounded_bounds.get(name, set()) if b < bound}

        if self._function_mode == "full" or not lower_bounds:
            part: ProgPart = ("incremental_function_full", args + (Number(bound),))
        else:
            prev = max(lower_bounds)
            part = ("incremental_function_extend", args + (Number(prev), Number(bound)))

        self._function_grounded_bounds.setdefault(name, set()).add(bound)
        return part

    def _ground_incremental_at(self, control: Control, bound: int) -> None:
        """
        Ground all incremental program parts at the given bound (does nothing if already grounded).

        Args:
            control (Control): the clingo control object
            bound (int): the bound to ground the incremental parts at
        """
        if bound in self._grounded_incremental_bounds:
            return

        parts = []
        for exp_type, exp_args in self._incremental_parts:
            if exp_type == "function":
                parts.append(self._get_function_prog_part(exp_args, bound))
            else:
                parts.append(self._get_incremental_prog_part(exp_type, exp_args, bound))

        self._grounded_incremental_bounds.add(bound)
        control.ground(parts)

    def _find_minimal_bound(self, control: Control) -> None:
        """
        Find the minimal bound for an instance once a satisfiable bound was found.

        As in stepwise version but at each candidate bound there is an additional grounding step to obtain the
        rules for incremental parts at that bound.

        Args:
            control (Control): the control object (with all non-incremental parts already grounded)
        """
        unsat_bound = -1 if self._prev_bound is None else self._prev_bound
        sat_bound = self.current_max_bound
        last_bound = self.current_max_bound

        while True:
            current_bound = next_bound_converge(unsat_bound, sat_bound)

            if current_bound is None:
                print("\nOptimal bound found")
                self.current_max_bound = sat_bound
                break

            print("\nOptimal bound not yet found")
            print(f"Solving with bound = {current_bound}\n")

            # ground the incremental parts at the candidate bound (objects are already grounded)
            self._ground_incremental_at(control, current_bound)

            # grounding the incremental parts at current_bound re-declares (and thus resets) the
            # active(current_bound) external, so it has to be re-activated explicitly
            control.assign_external(Function("active", [Number(current_bound)]), True)

            # toggle the remaining active externals between the last and the current bound
            if current_bound < last_bound:
                for i in range(current_bound + 1, last_bound + 1):
                    control.assign_external(Function("active", [Number(i)]), False)
            else:
                for i in range(last_bound + 1, current_bound + 1):
                    control.assign_external(Function("active", [Number(i)]), True)

            # set max_bound externals
            control.release_external(Function("max_bound", [Number(last_bound)]))
            control.assign_external(Function("max_bound", [Number(current_bound)]), True)

            ret = control.solve()
            last_bound = current_bound
            if ret.satisfiable:
                sat_bound = current_bound
            else:
                unsat_bound = current_bound

    def main(self, control: Control, files: Sequence[str]) -> None:
        """
        Main function of the jump multishot application class.

        After returning the attribute current_max_bound is the minimal bound for which the instance
        is satisfiable.

        Args:
            control (Control): the clingo control object
        """
        control.load(get_encoding("encoding-base-clingo-multi-jump.lp"))
        control.load(get_encoding("show-clingo.lp"))

        while True:
            print(f"\nNew max bound is = {self.current_max_bound} (previous was {self._prev_bound})\n")

            start = 0 if self._prev_bound is None else self._prev_bound + 1
            target = self.current_max_bound

            # collect the non-incremental program parts across the whole jump range
            # preprocessing is still done in steps of 1 (to assign each object its bound),
            # but the grounding of the collected parts is deferred until after the range is processed
            non_incremental_parts: List[ProgPart] = []
            for bound in range(start, target + 1):
                # preprocessing
                self._preprocess_new_bound(bound)
                # remove incremental expressions (grounded via incremental parts, not new_* parts)
                self._remove_new_incremental_expressions()

                if bound == 0:
                    # add the base program together with the remaining (non-incremental) bound-0 facts
                    # (needs to be grounded before the other program parts below)
                    control.add("base", [], "".join(self._new_processed_facts))
                    control.ground([("base", [])])
                    # ground the incremental parts discovered at bound 0
                    self._ground_incremental_at(control, 0)
                else:
                    for fact in self._new_processed_facts:
                        non_incremental_parts.append(self._get_prog_part(fact, bound))

            print(f"Grounding with bound = {self.current_max_bound}")
            # ground all collected non-incremental program parts in one batch
            control.ground(non_incremental_parts)

            # ground the incremental program parts at the target bound only
            if target != 0:
                self._ground_incremental_at(control, target)

            # assign the externals only AFTER all grounding for this jump is done: grounding a
            # program part that contains an `#external` for an already-assigned external (the
            # incremental parts re-declare active/max_bound) resets it to its default (false), so the
            # externals must be (re)assigned once no further grounding will touch them.
            for bound in range(start, target + 1):
                control.assign_external(Function("active", [Number(bound)]), True)
            if self._prev_bound is not None:
                control.assign_external(Function("max_bound", [Number(self._prev_bound)]), False)
            control.assign_external(Function("max_bound", [Number(self.current_max_bound)]), True)

            # solve
            print(f"\nSolving with bound = {self.current_max_bound}\n")
            ret = control.solve()
            if ret.satisfiable:
                self._find_minimal_bound(control)
                break

            self._update_bound()
