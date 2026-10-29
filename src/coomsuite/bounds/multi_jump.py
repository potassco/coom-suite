"""
Clingo application class for solving COOM configuration problems with multi-shot solving using jump grounding.
"""

import re
from collections.abc import Sequence
from typing import Any

from clingo import Control
from clingo.symbol import Function, Number, Symbol

from coomsuite.preprocess import preprocess
from coomsuite.utils import get_encoding

from .multi_application import COOMMultiSolverApp, ProgPart, _get_fact_name_and_args

OBJECT_PATH = re.compile(r"root(?:\.[A-Za-z_]\w*\[-?\d+\])*")
"""Matches the object paths (as constructed by the dotpath function of the preprocessing) inside a fact"""


class COOMMultiSolverAppJump(COOMMultiSolverApp):
    """
    Multishot application that grounds incremental program parts only at the bounds that are actually solved.

    Non-incremental program parts are still collected in steps of 1 but only grounded in one batch
    corresponding to the bound increase.
    Incremental programs parts are only added for the actual next bound
    (except for table constraints, whose rows are checked for the whole range of the jump).

    For incremental functions there are two possible modes:
    - extend: similar to the approach of grounding stepwise, the value for the new bound is obtained by extending the
      value of the previous bound and accounting for all objects between the previous and the new bound
    - full: does not reuse the old value and recomputes the full aggregates
    """

    def __init__(
        self,
        serialized_facts: list[str],
        algorithm: str = "linear",
        initial_bound: int = 0,
        step: int | None = 1,
        base: float | None = 2.0,
        function_mode: str = "extend",
        fix_externals: bool = False,
        log_level: str = "",
        options: dict[str, Any] | None = None,
        istest: bool = False,
    ) -> None:
        """Initialize the jump multishot application."""
        super().__init__(
            serialized_facts, algorithm, initial_bound, step, base, fix_externals, log_level, options, istest
        )

        if function_mode not in ("extend", "full"):
            raise ValueError(f"unknown function mode for jump grounding: {function_mode}")
        self._function_mode: str = function_mode
        """The encoding used for incremental functions ("extend" or "full")"""

        self._function_grounded_bounds: dict[str, set[int]] = {}
        """For each incremental function the set of bounds at which it has already been grounded"""

        self._object_bounds: dict[str, int] = {}
        """For every object its bound, i.e. the smallest max_bound at which the object exists"""

    def _run_preprocess(self, bound: int) -> set[str]:
        """
        Extend the preprocessing to also compute the bound of every object.

        The bounds of the objects are needed to group the preprocessed facts by bound
        (see _preprocess_up_to) and are stored in _object_bounds. As they do not correspond
        to any program part they are not part of the returned facts.

        Args:
            bound (int): the value of max_bound to preprocess

        Returns:
            set[str]: the facts resulting from preprocessing (without the bounds of the objects)
        """
        facts = preprocess(self._serialized_facts, max_bound=bound, discrete=True, multishot=True, object_bounds=True)

        remaining_facts = set()
        for fact in facts:
            if fact.startswith("obj_bound"):
                _, args = _get_fact_name_and_args(fact)
                self._object_bounds[args[0].string] = args[1].number
            else:
                remaining_facts.add(fact)

        return remaining_facts

    def _bound_of_fact(self, fact: str) -> int:
        """
        Determine the bound at which a fact becomes available.

        A fact is available as soon as all objects it refers to exist, i.e. at the maximum of
        the bounds of these objects (see the obj_bound predicate of the preprocessing).
        Facts not referring to any object are available from bound 0 on.

        Args:
            fact (str): The fact represented as a string (with trailing '.')

        Returns:
            int: the bound at which the fact becomes available
        """
        return max((self._object_bounds[path] for path in OBJECT_PATH.findall(fact)), default=0)

    def _preprocess_up_to(self, target: int, start: int) -> dict[int, set[str]]:
        """
        Preprocess the serialized facts once for the given target bound and group the new facts by bound.

        Args:
            target (int): the value of max_bound to preprocess
            start (int): the first bound that has not been processed yet

        Returns:
            dict[int, set[str]]: for every bound in [start, target] the new facts belonging to it
        """
        new_facts = self._preprocess_bound(target)

        # group the new facts by the bound they become available at
        groups: dict[int, set[str]] = {bound: set() for bound in range(start, target + 1)}
        for fact in new_facts:
            groups[min(max(self._bound_of_fact(fact), start), target)].add(fact)

        return groups

    def _get_function_prog_part(self, args: tuple[Symbol, ...], bound: int) -> ProgPart:
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

    def _get_incremental_parts_at(self, start: int, target: int) -> list[ProgPart]:
        """
        Get all incremental program parts for the jump range [start, target] (without grounding them).

        Most incremental parts are only needed at the target bound. Table constraints are the exception:
        the rows added at any bound of the range have to be checked, as they are associated with their bound.

        Args:
            start (int): the first bound of the jump range
            target (int): the target bound of the jump range

        Returns:
            List[ProgPart]: the incremental program parts to ground for the jump range
        """
        parts: list[ProgPart] = []
        for exp_type, exp_args in self._incremental_parts:
            if exp_type == "function":
                parts.append(self._get_function_prog_part(exp_args, target))
            elif exp_type == "constraint" and exp_args[1].string == "table":
                parts.append(("incremental_constraint_extend", exp_args + (Number(start - 1), Number(target))))
            else:
                parts.append(self._get_incremental_prog_part(exp_type, exp_args, target))

        return parts

    def _find_minimal_bound(self, control: Control) -> None:
        """
        Extend find_minimal_bound by permanently fixing the max_bound (if using fix_externals option).
        """
        if self._fix_externals:
            control.ground([("fix_max_bound", [Number(self.current_max_bound)])])

        super()._find_minimal_bound(control)

    def _converge_update_max_bound(self, control: Control, last_bound: int, current_bound: int) -> None:
        # In the jump approach the max_bound stays fixed at the value when starting converge.
        # Even though we do not have specific rules for the smaller max bounds,
        # we can just keep using the ones for the starting max bound.
        pass

    def main(self, control: Control, files: Sequence[str]) -> None:  # noqa: ARG002
        """
        Main function of the jump multishot application class.

        After returning the attribute current_max_bound is the minimal bound for which the instance
        is satisfiable.

        Args:
            control (Control): the clingo control object
            files (Sequence[str]): files to load into the control
        """  # noqa: D401
        control.load(get_encoding("encoding-base-clingo-multi-jump.lp"))
        control.load(get_encoding("show-clingo.lp"))

        while True:
            print(f"\nNew max bound is = {self.current_max_bound} (previous was {self._prev_bound})\n")

            start = 0 if self._prev_bound is None else self._prev_bound + 1
            target = self.current_max_bound

            # collect the non-incremental program parts across the whole jump range
            # the parts are still collected per bound (to assign each object its bound),
            # but the grounding of the collected parts is deferred until after the range is processed
            non_incremental_parts: list[ProgPart] = []
            # preprocessing is done once for the whole jump range, the resulting facts are grouped by the
            # bound they belong to (the groups are the same as preprocessing every bound separately)
            groups = self._preprocess_up_to(target, start)
            for bound in range(start, target + 1):
                self._new_processed_facts = groups[bound]
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

            # get the incremental program parts for the jump range
            incremental_parts = self._get_incremental_parts_at(start, target)

            print(f"Grounding with bound = {self.current_max_bound}")
            # ground all collected non-incremental and incremental (for target bound) parts together
            control.ground(non_incremental_parts + incremental_parts)

            # assign externals values after all grounding is done
            for bound in range(start, target + 1):
                control.assign_external(Function("active", [Number(bound)]), True)

            if self._assign_max_bound_and_solve(control):
                break
