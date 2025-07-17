from typing import Any, Dict, List, Optional, Sequence, Tuple

from clingo import Control
from clingo.symbol import parse_term, Number, Function

from .application import COOMSolverApp
from .preprocess import preprocess
from .utils import get_encoding


class COOMMultiSolverApp(COOMSolverApp):
    # need to have serialized facts as preprocessing is done in this class
    serialized_facts: List[str]
    max_bound = 0
    incremental_sets: Dict[str, Any] = {}
    incremental_expressions: List[str] = []

    def __init__(
        self,
        log_level: str = "",
        options: Optional[Dict[str, Any]] = None,
        istest: bool = False,
        serialized_facts: List[str] = [],
    ):
        super(COOMMultiSolverApp, self).__init__(log_level, options, istest)
        self.serialized_facts = serialized_facts

    def get_incremental_prog_parts(self, inc_set: str):
        program_parts = []
        for exp in self.incremental_sets[inc_set]:
            if exp[0] == "function":
                program_parts.append(("incremental_function", exp[1] + [Number(self.max_bound)]))
            elif exp[0] == "binary":
                lhs = exp[1][1]
                rhs = exp[1][3]
                if lhs not in self.incremental_expressions:
                    program_parts.append(("incremental_binary_r", exp[1] + [Number(self.max_bound)]))
                elif rhs not in self.incremental_expressions:
                    program_parts.append(("incremental_binary_l", exp[1] + [Number(self.max_bound)]))
                else:
                    program_parts.append(("incremental_binary", exp[1] + [Number(self.max_bound)]))
            elif exp[0] == "unary":
                program_parts.append(("incremental_unary", exp[1] + [Number(self.max_bound)]))
            elif exp[0] == "constraint":
                program_parts.append(("incremental_constraint", exp[1] + [Number(self.max_bound)]))

        return program_parts

    def get_prog_part(self, fact: str):
        # facts has the . at the end
        x = parse_term(fact[:-1])
        program_parts = [
            (
                f"new_{x.name}",
                # the program parts new_type and new_constraint need the current max
                # bound as an additional argument
                x.arguments if x.name not in ["type", "constraint"] else x.arguments + [Number(self.max_bound)],
            )
        ]

        if x.name == "set" and x.arguments[0].string in self.incremental_sets:
            program_parts += self.get_incremental_prog_parts(x.arguments[0].string)

        return program_parts

    def get_incremental_facts(self, facts: List[str]) -> List[str]:
        incremental_facts = [x for x in facts if x.startswith(("inc_set", "incremental"))]

        return incremental_facts

    def get_initial_incremental_data(self):
        processed_facts = preprocess(self.serialized_facts, max_bound=1, discrete=True)
        incremental_facts = self.get_incremental_facts(processed_facts)

        self.save_incremental_data(incremental_facts)

        return incremental_facts

    def save_incremental_data(self, incremental_facts: List[str]):
        inc_sets = [parse_term(x[:-1]).arguments[0] for x in incremental_facts if x.startswith("inc_set")]
        inc_expressions = [parse_term(x[:-1]) for x in incremental_facts if x.startswith("incremental")]

        for inc_set in inc_sets:
            self.incremental_sets[inc_set.string] = []
            for exp in inc_expressions:
                if exp.arguments[2] == inc_set:
                    self.incremental_sets[inc_set.string].append((exp.arguments[0].string, exp.arguments[3].arguments))
                    self.incremental_expressions.append(exp.arguments[1].string)

    def main(self, control: Control, files: Sequence[str]) -> None:
        if self._options["solver"] == "fclingo":
            print("multi shot solving not supported for fclingo")
        else:
            # currently only linear incremental bounds
            processed_facts: List[str] = []
            incremental_facts = []

            new_processed_facts = preprocess(self.serialized_facts, max_bound=self.max_bound, discrete=True)
            new_incremental_facts = self.get_incremental_facts(new_processed_facts)
            new_processed_facts = [x for x in new_processed_facts if x not in new_incremental_facts]

            encoding = get_encoding("encoding-base-clingo-multi.lp")
            show = get_encoding("show-clingo.lp")
            control.load(encoding)
            control.load(show)

            while True:
                print(f"\nSolving with max_bound = {self.max_bound}\n")

                parts = []

                if self.max_bound > 0:
                    self.save_incremental_data(new_incremental_facts)

                    for fact in new_processed_facts:
                        parts += self.get_prog_part(fact)

                else:
                    # TODO: this processing does not seem fully correct yet ?
                    # - need to check which parts of preprocessing with max bound 1 actually are relevant
                    # - ex: root.totalVolume = sum(root.bags.size.volume) vs.
                    #       table constraint on bag size and pocket size

                    # TODO: do i need to save the incremental facts here ?
                    incremental_facts = self.get_initial_incremental_data()
                    for fact in new_processed_facts:
                        x = parse_term(fact[:-1])
                        if x.name == "function" and x.arguments[0].string in self.incremental_expressions:
                            parts.append(("incremental_function", x.arguments + [Number(self.max_bound)]))
                            processed_facts.append(fact)
                        elif x.name == "binary" and x.arguments[0].string in self.incremental_expressions:
                            lhs = x.arguments[1].string
                            rhs = x.arguments[3].string
                            if lhs not in self.incremental_expressions:
                                parts.append(("incremental_binary_r", x.arguments + [Number(self.max_bound)]))
                            elif rhs not in self.incremental_expressions:
                                parts.append(("incremental_binary_l", x.arguments + [Number(self.max_bound)]))
                            else:
                                parts.append(("incremental_binary", x.arguments + [Number(self.max_bound)]))
                            processed_facts.append(fact)
                        elif x.name == "unary" and x.arguments[0].string in self.incremental_expressions:
                            parts.append(("incremental_unary", x.arguments + [Number(self.max_bound)]))
                            processed_facts.append(fact)
                        elif (
                            x.name == "constraint"
                            and x.arguments[1].string == "boolean"
                            and x.arguments[0].arguments[1].string in self.incremental_expressions
                        ):
                            parts.append(("incremental_constraint", x.arguments + [Number(self.max_bound)]))
                            processed_facts.append(fact)

                    # remove every fact that was already handled in the above loop
                    new_processed_facts = [x for x in new_processed_facts if x not in processed_facts]

                    control.add("base", [], "".join(new_processed_facts))
                    # base needs to be gorunded before the other program parts
                    control.ground([("base", [])])

                control.ground(parts)

                control.assign_external(Function("active", [Number(self.max_bound)]), True)
                control.assign_external(Function("max_bound", [Number(self.max_bound)]), True)
                if self.max_bound > 0:
                    control.assign_external(Function("max_bound", [Number(self.max_bound - 1)]), False)

                ret = control.solve()

                if ret.satisfiable:
                    break

                self.max_bound += 1
                processed_facts += new_processed_facts
                new_processed_facts = preprocess(self.serialized_facts, max_bound=self.max_bound, discrete=True)
                new_incremental_facts = self.get_incremental_facts(new_processed_facts)
                new_processed_facts = [x for x in new_processed_facts if x not in new_incremental_facts]
                # filter to only have the new facts add by the increased bound
                new_processed_facts = [x for x in new_processed_facts if x not in processed_facts]
                new_incremental_facts = [x for x in new_incremental_facts if x not in incremental_facts]
