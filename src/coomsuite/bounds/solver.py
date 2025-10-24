"""
Contains a module for solving problems with open bounds/cardinalities.
"""

from typing import List

from clingo.application import clingo_main

from coomsuite import solve

from . import get_bound_iter, next_bound_converge
from .multi_application import COOMMultiSolverApp

ret_dict = {10: "SAT", 20: "UNSAT"}


class BoundSolver:
    """
    Module for solving problems with open bounds/cardinalities.
    """

    facts: List[str]
    solver: str
    clingo_args: List[str]
    output_format: str

    def __init__(
        self,
        facts: List[str],
        solver: str,
        clingo_args: List[str],
        output_format: str,
    ):
        self.facts = facts
        self.solver = solver
        self.clingo_args = clingo_args
        self.output_format = output_format

    def _solve(self, max_bound: int) -> int:
        return solve(self.facts, self.solver, max_bound, self.clingo_args, self.output_format)

    def _converge(self, unsat_bound: int, sat_bound: int) -> int:
        """
        Converge to the minimal bound given lower bound (unsat_bound) and upper bound (sat_bound)
        """
        while True:
            current_bound = next_bound_converge(unsat_bound, sat_bound)

            if current_bound is None:
                print("\nOptimal bound found")
                return sat_bound

            print("\nOptimal bound not yet found")
            print(f"Solving with bound = {current_bound}\n")

            ret = self._solve(current_bound)
            if ret_dict[ret] == "SAT":
                sat_bound = current_bound
            else:
                unsat_bound = current_bound

    def get_bounds(self, algorithm: str = "linear", initial_bound: int = 0, use_multishot: bool = False) -> int:
        """
        Compute the minimal bound for the problem.
        """
        # multi shot solving
        if use_multishot:
            multishot_solver = COOMMultiSolverApp(
                serialized_facts=self.facts,
                initial_bound=initial_bound,
                algorithm=algorithm,
                options={
                    "solver": self.solver,
                    "output_format": self.output_format,
                },
            )

            clingo_main(
                multishot_solver,
                self.clingo_args,
            )

            return multishot_solver.max_bound

        # single shot solving
        bounds_iter = get_bound_iter(algorithm, initial_bound)
        max_bound = initial_bound
        prev_bound = -1
        while True:
            print(f"\nSolving with max_bound = {max_bound}\n")
            ret = self._solve(max_bound)
            if ret_dict[ret] == "SAT":
                return self._converge(prev_bound, max_bound)
            prev_bound = max_bound
            max_bound = next(bounds_iter)
