from typing import Any, Dict, List, Optional, Sequence

from clingo import Control
from clingo.symbol import parse_term, Number, Function

from .application import COOMSolverApp
from .preprocess import preprocess
from .utils import get_encoding


class COOMMultiSolverApp(COOMSolverApp):
    # need to have serialized facts as preprocessing is done in this class
    serialized_facts: List[str]
    max_bound = 0

    def __init__(
        self,
        log_level: str = "",
        options: Optional[Dict[str, Any]] = None,
        istest: bool = False,
        serialized_facts: List[str] = [],
    ):
        super(COOMMultiSolverApp, self).__init__(log_level, options, istest)
        self.serialized_facts = serialized_facts

    def fact_to_prog_part(self, fact: str):
        # facts has the . at the end
        x = parse_term(fact[:-1])
        return (
            f"new_{x.name}",
            # the program parts new_type and new_constraint need the current max
            # bound as an additional argument
            x.arguments if x.name not in ["type", "constraint"] else x.arguments + [Number(self.max_bound)],
        )

    def main(self, control: Control, files: Sequence[str]) -> None:
        if self._options["solver"] == "fclingo":
            print("multi shot solving not supported for fclingo")
        else:
            # currently only linear incremental bounds
            processed_facts: List[str] = []
            new_processed_facts = preprocess(self.serialized_facts, max_bound=self.max_bound, discrete=True)

            encoding = get_encoding("encoding-base-clingo-multi.lp")
            show = get_encoding("show-clingo.lp")
            control.load(encoding)
            control.load(show)

            while True:
                print(f"\nSolving with max_bound = {self.max_bound}\n")
                print(f"added facts:")
                print(new_processed_facts)
                parts = []

                if self.max_bound > 0:
                    # TODO: incremental functions/binaries/unaries/constraints
                    parts = [self.fact_to_prog_part(x) for x in new_processed_facts]
                else:
                    control.add("base", [], "".join(new_processed_facts))
                    parts.append(("base", []))

                print("program parts")
                print(parts)
                control.ground(parts)

                print(f"assigning external active({self.max_bound}) to true")
                control.assign_external(Function("active", [Number(self.max_bound)]), True)
                ret = control.solve()

                if ret.satisfiable:
                    break

                self.max_bound += 1
                processed_facts += new_processed_facts
                new_processed_facts = preprocess(self.serialized_facts, max_bound=self.max_bound, discrete=True)
                # filter to only have the new facts add by the increased bound
                new_processed_facts = [x for x in new_processed_facts if x not in processed_facts]
