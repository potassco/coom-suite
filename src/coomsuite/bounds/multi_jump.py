"""
Clingo application class for solving COOM configuration problems with multi-shot solving using jump grounding.
"""

from typing import Any, Dict, List, Optional, Sequence, Set, Tuple

from clingo import Control
from clingo.symbol import Function, Number, Symbol

from coomsuite.utils import get_encoding

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

    def _get_incremental_parts_at(self, bound: int) -> List[ProgPart]:
        """
        Get all incremental program parts at the given bound (without grounding them).

        Args:
            bound (int): the bound to get the incremental parts at

        Returns:
            List[ProgPart]: the incremental program parts to ground at the given bound
        """
        parts: List[ProgPart] = []
        for exp_type, exp_args in self._incremental_parts:
            if exp_type == "function":
                parts.append(self._get_function_prog_part(exp_args, bound))
            else:
                parts.append(self._get_incremental_prog_part(exp_type, exp_args, bound))

        return parts

    def _converge_update_max_bound(self, control: Control, last_bound: int, current_bound: int) -> None:
        # In the jump approach max_bound stays fixed at its starting value: the starting max_bound
        # already includes all possible objects we need as we only go below this bound in converge.
        # For the lower bounds we do not have the specific incremental rules due to the jump approach,
        # but just using the ones for the higher bound works as well (instead of grounding new rules).
        pass

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
                else:
                    for fact in self._new_processed_facts:
                        non_incremental_parts.append(self._get_prog_part(fact, bound))

            # get the incremental program parts at the target bound only
            incremental_parts = self._get_incremental_parts_at(target)

            print(f"Grounding with bound = {self.current_max_bound}")
            # ground all collected non-incremental and incremental (for target bound) parts together
            control.ground(non_incremental_parts + incremental_parts)

            # assign the externals only AFTER all grounding for this jump is done: grounding a
            # program part that contains an `#external` for an already-assigned external (the
            # incremental parts re-declare active/max_bound) resets it to its default (false), so the
            # externals must be (re)assigned once no further grounding will touch them.
            for bound in range(start, target + 1):
                control.assign_external(Function("active", [Number(bound)]), True)

            if self._assign_max_bound_and_solve(control):
                break
