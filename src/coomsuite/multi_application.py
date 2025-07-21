from typing import Any, Dict, List, Optional, Sequence, Tuple, Set

from clingo import Control
from clingo.symbol import parse_term, Number, Function

from .application import COOMSolverApp
from .preprocess import preprocess
from .utils import get_encoding

# TODO: remove
from pprint import pprint


class COOMMultiSolverApp(COOMSolverApp):
    # need to have serialized facts as preprocessing is done in this class
    serialized_facts: List[str]
    max_bound = 0
    # which sets have unbounded cardinality and in which expressions are they used
    incremental_sets: Dict[str, List[Tuple[str, List[Any]]]] = {}
    # all the incremental expressions in the program
    incremental_expressions: Set[str] = set()
    # keep track of whether an incremental expression is already initialized
    is_initialized: Dict[str, bool] = {}
    # store for which incremental sets program parts have to be added
    sets_to_process: Set[str] = set()

    def __init__(
        self,
        log_level: str = "",
        options: Optional[Dict[str, Any]] = None,
        istest: bool = False,
        serialized_facts: List[str] = [],
    ):
        super(COOMMultiSolverApp, self).__init__(log_level, options, istest)
        self.serialized_facts = serialized_facts

    def get_incremental_prog_part(self, exp_type: str, args):
        # get incremental program part for an expression of type exp_type with arguments args
        # determine the name of the expression
        name = ""
        if exp_type in ["function", "binary", "unary"]:
            name = args[0].string
        else:
            name = args[0].arguments[1].string

        # determine the name and arguments of the program part
        part_name = ""
        # to the arguments we just need to add the current max_bound
        args = args + [Number(self.max_bound)]
        # the name of the program part depends on the type of the expression
        if exp_type == "function":
            # for functions we need to check whether they are already initialized
            prefix = ""
            if self.is_initialized[name]:
                prefix = "update_"
            else:
                prefix = "new_"
                self.is_initialized[name] = True
            part_name = prefix + "incremental_function"
        elif exp_type == "binary":
            # for binaries we need to check which of the subexpressions are incremental themselves
            part_name = "incremental_binary"
            lhs = args[1].string
            rhs = args[3].string
            if lhs not in self.incremental_expressions:
                part_name += "_r"
            elif rhs not in self.incremental_expressions:
                part_name += "_l"
        elif exp_type == "unary":
            part_name = "incremental_unary"
        elif exp_type == "constraint":
            part_name = "incremental_constraint"

        return (part_name, args)

    def get_prog_part_of_inc_set(self, inc_set: str):
        # get all the program parts for an incremental set
        program_parts = []
        for exp in self.incremental_sets[inc_set]:
            program_parts.append(self.get_incremental_prog_part(exp[0], exp[1]))

        return program_parts

    def get_prog_part(self, fact: str):
        # convert fact to clingo term (removing the . at the end of facts)
        x = parse_term(fact[:-1])

        # determine the corresponding program part
        program_parts = [
            (
                f"new_{x.name}",
                # the program parts new_type and new_constraint need the current max bound as an additional argument
                x.arguments if x.name not in ["type", "constraint"] else x.arguments + [Number(self.max_bound)],
            )
        ]

        # a fact set(S,X) adds an element to set S
        # if S is an incremental set we need to add its corresponding program parts
        if x.name == "set" and x.arguments[0].string in self.incremental_sets:
            # can not add program parts for the incremental set directly
            # as this could result in parts for one set being added multiple times
            self.sets_to_process.add(x.arguments[0].string)

        return program_parts

    def get_incremental_facts(self, facts: List[str]) -> List[str]:
        # get all facts inc_set/1 and incremental/4 from list of facts
        incremental_facts = [x for x in facts if x.startswith(("inc_set", "incremental"))]

        return incremental_facts

    def get_initial_incremental_data(self):
        # incremental expressions may already turn up with initial bound of 0
        # but preprocessing only detects them at bound 1 (at least for 0..*)
        # TODO: improve incremental detection in preprocessing
        processed_facts = preprocess(self.serialized_facts, max_bound=1, discrete=True)
        incremental_facts = self.get_incremental_facts(processed_facts)

        self.save_incremental_data(incremental_facts)

        return incremental_facts

    def save_incremental_data(self, incremental_facts: List[str]):
        # incremental_facts contain predicates:
        # inc_set(S) indicating sets S with unbounded cardinalities, and
        # incremental(T,N,S,Arg) indicating an expression of type T with name N
        #                        belonging to set S, Arg are the arguments of the expression
        inc_sets = [parse_term(x[:-1]).arguments[0] for x in incremental_facts if x.startswith("inc_set")]
        inc_expressions = [parse_term(x[:-1]) for x in incremental_facts if x.startswith("incremental")]

        # save incremental sets and their expressions
        for inc_set in inc_sets:
            if inc_set not in self.incremental_sets:
                self.incremental_sets[inc_set.string] = []
            for exp in inc_expressions:
                if exp.arguments[2] == inc_set:
                    # expression is added both to the set as well as to the set of all incremental expressions
                    x = (exp.arguments[0].string, exp.arguments[3].arguments)
                    if x not in self.incremental_sets[inc_set.string]:
                        self.incremental_sets[inc_set.string].append(x)
                    self.incremental_expressions.add(exp.arguments[1].string)
                    # for functions we need to keep track whether they are intialized already
                    if exp.arguments[0].string == "function":
                        if exp.arguments[1].string not in self.is_initialized:
                            self.is_initialized[exp.arguments[1].string] = False

    def main(self, control: Control, files: Sequence[str]) -> None:
        if self._options["solver"] == "fclingo":
            print("multi shot solving not supported for fclingo")
        else:
            # currently only linear incremental bounds
            processed_facts: List[str] = []
            incremental_facts = []

            new_processed_facts = preprocess(self.serialized_facts, max_bound=self.max_bound, discrete=True)
            # filter out the incremental facts
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

                    # collect program parts for all the new facts
                    for fact in new_processed_facts:
                        parts += self.get_prog_part(fact)

                    # collect program parts for all the incremental sets that are needed
                    for inc_set in self.sets_to_process:
                        parts += self.get_prog_part_of_inc_set(inc_set)

                    self.sets_to_process = set()

                else:
                    # TODO: this processing does not seem fully correct yet ?
                    # - need to check which parts of preprocessing with max bound 1 actually are relevant
                    # - ex: root.totalVolume = sum(root.bags.size.volume) vs.
                    #       table constraint on bag size and pocket size

                    incremental_facts = self.get_initial_incremental_data()
                    for fact in new_processed_facts:
                        x = parse_term(fact[:-1])
                        if (
                            x.name in ["function", "binary", "unary"]
                            and x.arguments[0].string in self.incremental_expressions
                        ) or (
                            x.name == "constraint"
                            and x.arguments[1].string == "boolean"
                            and x.arguments[0].arguments[1].string in self.incremental_expressions
                        ):
                            parts.append(self.get_incremental_prog_part(x.name, x.arguments))
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
