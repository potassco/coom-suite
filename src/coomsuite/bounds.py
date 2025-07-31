"""
Contains a module for solving problems with open bounds/cardinalities.
"""

from typing import Dict, List

from clingo.application import clingo_main

from . import solve
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
        use_multishot: bool = False,
    ):
        self.facts = facts
        self.solver = solver
        self.clingo_args = clingo_args
        self.use_multishot = use_multishot
        self.output_format = output_format

    def _solve(self, max_bound: int) -> int:
        return solve(self.facts, self.solver, max_bound, self.clingo_args, self.output_format)

    def _converge(self, solve_results: Dict[int, str], top: int, i: int) -> int:
        if i <= 0:
            return top if solve_results[top] == "SAT" else top + 1

        i = i - 1
        if solve_results[top] == "SAT":
            new = top - 2**i
        else:
            new = top + 2**i
        print(" ".join([f"Iteration with top {top}, new is {new}, i is {i}\n"]))
        ret = self._solve(new)
        solve_results[new] = "SAT" if ret == 10 else "UNSAT"

        return self._converge(solve_results, new, i)

    def get_bounds(self, algorithm: str = "linear", initial_bound: int = 0) -> int:
        """
        Gets the minimum bounds for the problem.
        """
        if self.use_multishot:
            multishot_solver = COOMMultiSolverApp(
                serialized_facts=self.facts,
                initial_bound=initial_bound,
                algorithm=algorithm,
                options={
                    "solver": self.args.solver,
                    "output_format": self.args.output,
                },
            )

            clingo_main(
                multishot_solver,
                self.clingo_args,
            )

            return multishot_solver.max_bound
        else:
            if algorithm == "linear":
                max_bound = initial_bound

                while True:
                    print(f"\nSolving with max_bound = {max_bound}\n")
                    ret = self._solve(max_bound)
                    if ret_dict[ret] == "SAT":
                        break
                    max_bound += 1

                return max_bound

            else:
                # exponential search
                # taken from https://git-ainf.aau.at/Giulia.Francescutto/papers/-/wikis/uploads/main.py
                i = 0
                bottom = 0
                top = 0

                print(" ".join([f"Solving with bound {format(top)}\n"]))
                ret = self._solve(top)
                solve_results = {0: ret_dict[ret]}

                while True:
                    if ret_dict[ret] == "SAT":
                        break
                    bottom = top
                    top = 2**i
                    print(" ".join([f"Solving with bound {format(top)}\n"]))
                    ret = self._solve(top)
                    solve_results[top] = ret_dict[ret]
                    print(" ".join([f"Top is {top} and bottom is {bottom}; i is {i}\n"]))

                    i = i + 1

                    if ret == "SAT" and i == 0:
                        return top
                    else:
                        return self._converge(solve_results, top, i - 2)
