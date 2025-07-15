from typing import List

from clingo.application import clingo_main

from . import solve
from .multi_application import COOMMultiSolverApp

ret_dict = {10: "SAT", 20: "UNSAT"}


class BoundSolver:

    facts: List[str]
    algorithm: str
    initial_bound: int
    # max_bound: int

    def __init__(
        self,
        facts: List[str],
        args,
        clingo_args,
        algorithm: str = "",
        use_multishot: bool = False,
        initial_bound: int = 0,
    ):
        self.facts = facts
        self.args = args
        self.clingo_args = clingo_args
        self.algorithm = "linear" if algorithm == "" else algorithm
        self.use_multishot = use_multishot
        self.initial_bound = initial_bound
        # self.max_bound = initial_bound

    def _solve(self, max_bound: int):
        return solve(self.facts, max_bound, self.args, clingo_args=self.clingo_args)

    def _converge(self, solve_results, top, i):
        if i <= 0:
            return top if solve_results[top] == "SAT" else top + 1

        i = i - 1
        if solve_results[top] == "SAT":
            new = top - 2**i
        else:
            new = top + 2**i
        print(" ".join(["Iteration with top {}, new is {}, i is {}\n".format(top, new, i)]))
        ret = self._solve(new)
        solve_results[new] = "SAT" if ret == 10 else "UNSAT"

        return self._converge(solve_results, new, i)

    def get_bounds(self):
        if self.use_multishot:
            return clingo_main(
                COOMMultiSolverApp(
                    options={
                        "solver": self.args.solver,
                        "output_format": self.args.output,
                    },
                    serialized_facts=self.facts,
                ),
                self.clingo_args,
            )
        else:
            if self.algorithm == "linear":
                max_bound = self.initial_bound

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

                print(" ".join(["Solving with bound {}\n".format(top)]))
                ret = self._solve(top)
                solve_results = {0: ret_dict[ret]}

                while True:
                    if ret_dict[ret] == "SAT":
                        break
                    bottom = top
                    top = 2**i
                    print(" ".join(["Solving with bound {}\n".format(top)]))
                    ret = self._solve(top)
                    solve_results[top] = ret_dict[ret]
                    print(" ".join(["Top is {} and bottom is {}; i is {}\n".format(top, bottom, i)]))

                    i = i + 1

                    if ret == "SAT" and i == 0:
                        return top
                    else:
                        return self._converge(solve_results, top, i - 2)
