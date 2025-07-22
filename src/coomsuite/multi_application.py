"""
Clingo application class for solving COOM configuration problems with multi-shot solving
"""

from typing import Any, Dict, List, Optional, Sequence, Set, Tuple, TypeAlias

from clingo import Control
from clingo.symbol import Function, Number, Symbol, parse_term

from .application import COOMSolverApp
from .preprocess import preprocess
from .utils import get_encoding

ProgPart: TypeAlias = Tuple[str, List[Symbol]]


# remove everything from new_facts that is alreay in facts
def filter_facts(facts: List[str], new_facts: List[str]) -> List[str]:
    return [x for x in new_facts if x not in facts]


def get_fact_name_and_args(fact: str) -> Tuple[str, List[Symbol]]:
    x = parse_term(fact[:-1])
    return (x.name, x.arguments)


class COOMMultiSolverApp(COOMSolverApp):
    """
    Application class for multi-shot solving extending the standard COOM application class
    """

    # need to have serialized facts as preprocessing is done in this class
    serialized_facts: List[str]
    # current max bound
    max_bound: int = 0
    # previous max bound
    prev_bound: Optional[int] = None

    # preprocessed facts are stored split up into which are incremental and which not
    # first we need to save what are currently the new facts
    new_processed_facts: List[str] = []
    new_incremental_facts: List[str] = []
    # and then also all the facts we previously encountered
    processed_facts: List[str] = []
    incremental_facts: List[str] = []

    # data structure for incremental sets and expressions
    # which sets have unbounded cardinality and in which expressions are they used
    incremental_sets: Dict[str, List[Tuple[str, List[Symbol]]]] = {}
    # all the incremental expressions in the program
    incremental_expressions: Set[str] = set()
    # keep track of whether an incremental expression is already initialized
    is_initialized: Dict[str, bool] = {}
    # store for which incremental sets program parts have to be added
    inc_sets_to_process: Set[str] = set()

    def __init__(
        self,
        serialized_facts: List[str],
        log_level: str = "",
        options: Optional[Dict[str, Any]] = None,
        istest: bool = False,
    ):
        super().__init__(log_level, options, istest)
        self.serialized_facts = serialized_facts

    def update_bound(self) -> None:
        self.prev_bound = self.max_bound
        self.max_bound += 1

    # do preprocessing for the new bound and update fact data structures
    def preprocess_new_bound(self, bound: int) -> None:
        # update facts that were already processed
        self.processed_facts += self.new_processed_facts
        self.incremental_facts += self.new_incremental_facts

        # preprocess with bound
        facts = preprocess(self.serialized_facts, max_bound=bound, discrete=True)

        # split into incremental and non-incremental facts
        self.new_incremental_facts = self.get_incremental_facts(facts)
        self.new_processed_facts = filter_facts(self.new_incremental_facts, facts)

        # filter out facts that were previously processed
        self.new_incremental_facts = filter_facts(self.incremental_facts, self.new_incremental_facts)
        self.new_processed_facts = filter_facts(self.processed_facts, self.new_processed_facts)

    # check if name(args) is an incremental expression
    def is_incremental_expression(self, name: str, args: List[Symbol]) -> bool:
        return (name in ["function", "binary", "unary"] and args[0].string in self.incremental_expressions) or (
            name == "constraint"
            and args[1].string == "boolean"
            and args[0].arguments[1].string in self.incremental_expressions
        )

    def get_initial_incremental_prog_parts(self) -> List[ProgPart]:
        parts = []
        for fact in self.new_processed_facts:
            name, args = get_fact_name_and_args(fact)
            if self.is_incremental_expression(name, args):
                parts.append(self.get_incremental_prog_part(name, args))
                self.processed_facts.append(fact)

        return parts

    def get_incremental_prog_part(self, exp_type: str, args: List[Symbol]) -> ProgPart:
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

    def get_prog_part_of_inc_set(self, inc_set: str) -> List[ProgPart]:
        # get all the program parts for an incremental set
        program_parts = []
        for exp in self.incremental_sets[inc_set]:
            program_parts.append(self.get_incremental_prog_part(exp[0], exp[1]))

        return program_parts

    # TODO: change from list to just a single ProgPart
    def get_prog_part(self, fact: str) -> List[ProgPart]:
        # convert fact to name and arguments
        name, args = get_fact_name_and_args(fact)

        # determine the corresponding program part
        program_parts = [
            (
                f"new_{name}",
                # the program parts new_type and new_constraint need the current max bound as an additional argument
                args if name not in ["type", "constraint"] else args + [Number(self.max_bound)],
            )
        ]

        # a fact set(S,X) adds an element to set S
        # if S is an incremental set we need to add its corresponding program parts
        if name == "set" and args[0].string in self.incremental_sets:
            # can not add program parts for the incremental set directly
            # as this could result in parts for one set being added multiple times
            self.inc_sets_to_process.add(args[0].string)

        return program_parts

    def get_incremental_facts(self, facts: List[str]) -> List[str]:
        # get all facts inc_set/1 and incremental/4 from list of facts
        incremental_facts = [x for x in facts if x.startswith(("inc_set", "incremental"))]

        return incremental_facts

    def get_initial_incremental_data(self) -> None:
        # incremental expressions may already turn up with initial bound of 0
        # but preprocessing only detects them at bound 1 (at least for 0..*)
        processed_facts = preprocess(self.serialized_facts, max_bound=1, discrete=True)
        self.incremental_facts = self.get_incremental_facts(processed_facts)

        self.update_incremental_data(self.incremental_facts)

    def update_incremental_data(self, incremental_facts: List[str]) -> None:
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
            encoding = get_encoding("encoding-base-clingo-multi.lp")
            show = get_encoding("show-clingo.lp")
            control.load(encoding)
            control.load(show)

            while True:
                print(f"\nSolving with max_bound = {self.max_bound}\n")

                # preprocessing
                self.preprocess_new_bound(self.max_bound)

                # collect program parts
                parts = []

                if self.prev_bound is None:
                    self.get_initial_incremental_data()
                    parts += self.get_initial_incremental_prog_parts()

                    # remove every fact that was already handled above
                    self.new_processed_facts = filter_facts(self.processed_facts, self.new_processed_facts)

                    # ground base (needs to be grounded before other program parts below)
                    control.add("base", [], "".join(self.new_processed_facts))
                    control.ground([("base", [])])
                else:
                    self.update_incremental_data(self.new_incremental_facts)

                    # keep track of inc sets that were updated (i.e. received new member)
                    self.inc_sets_to_process = set()

                    # collect program parts for all the new facts
                    for fact in self.new_processed_facts:
                        parts += self.get_prog_part(fact)

                    # collect program parts for all the incremental sets were updated
                    for inc_set in self.inc_sets_to_process:
                        parts += self.get_prog_part_of_inc_set(inc_set)

                # ground
                control.ground(parts)

                # update externals
                control.assign_external(Function("active", [Number(self.max_bound)]), True)
                control.assign_external(Function("max_bound", [Number(self.max_bound)]), True)
                if self.prev_bound is not None:
                    control.assign_external(Function("max_bound", [Number(self.prev_bound)]), False)

                # solve
                ret = control.solve()
                if ret.satisfiable:
                    break

                self.update_bound()
