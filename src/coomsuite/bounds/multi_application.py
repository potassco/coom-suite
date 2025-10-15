"""
Clingo application class for solving COOM configuration problems with multi-shot solving.
"""

from typing import Any, Dict, List, Optional, Sequence, Set, Tuple, TypeAlias

from clingo import Control
from clingo.symbol import Function, Number, Symbol, parse_term

from coomsuite.application import COOMSolverApp
from coomsuite.preprocess import preprocess
from coomsuite.utils import get_encoding

from . import get_bound_iter, next_bound_converge

ProgPart: TypeAlias = Tuple[str, List[Symbol]]


def _filter_facts(facts: List[str], new_facts: List[str]) -> List[str]:
    """
    Filter a list of new_facts by removing everything that is already in the list facts
    """
    return [x for x in new_facts if x not in facts]


def _get_fact_name_and_args(fact: str) -> Tuple[str, List[Symbol]]:
    """
    Convert a fact given as a string to its name and arguments

    Args:
        fact (str): The fact in string representation (with trailing '.')

    Returns:
        Tuple[str, List[Symbol]]: A tuple of the name of the fact and the list of its arguments (as clingo.Symbol)
    """
    x = parse_term(fact[:-1])
    return (x.name, x.arguments)


class COOMMultiSolverApp(COOMSolverApp):
    """
    Application class for multi-shot solving extending the standard COOM application class
    """

    # pylint: disable=too-many-instance-attributes
    # current max bound
    max_bound: int = 0
    # previous max bound
    _prev_bound: Optional[int] = None

    # preprocessed facts are stored split up into which are incremental and which not:
    # first we need to save what are currently the new facts
    _new_processed_facts: List[str] = []
    _new_incremental_facts: List[str] = []
    # and then also all the facts we previously encountered
    _processed_facts: List[str] = []
    _incremental_facts: List[str] = []

    # data structure for incremental sets and expressions:
    # which sets have unbounded cardinality and in which expressions are they used
    _incremental_sets: Dict[str, List[Tuple[str, List[Symbol]]]] = {}
    # all the incremental expressions in the program
    _incremental_expressions: Set[str] = set()
    # keep track of whether an incremental expression is already initialized
    _is_initialized: Dict[str, bool] = {}
    # store for which incremental sets program parts have to be added
    _inc_sets_to_process: Set[str] = set()

    def __init__(
        self,
        serialized_facts: List[str],
        algorithm: str = "linear",
        initial_bound: int = 0,
        log_level: str = "",
        options: Optional[Dict[str, Any]] = None,
        istest: bool = False,
    ):  # pylint: disable=too-many-arguments,too-many-positional-arguments
        super().__init__(log_level, options, istest)
        self._serialized_facts = serialized_facts
        self.max_bound = initial_bound
        self._bound_iter = get_bound_iter(algorithm, initial_bound)

        if algorithm not in ["linear", "exponential"]:
            raise ValueError(f"unknown algorithm option: {algorithm}")

    def _update_bound(self) -> None:
        """
        Update the current maximum bound
        """
        self._prev_bound = self.max_bound
        self.max_bound = next(self._bound_iter)

    def _preprocess_new_bound(self, bound: int) -> None:
        """
        Preprocess the serialized facts for the given bound and update the fact data structures
        """
        # update facts that were already processed
        self._processed_facts += self._new_processed_facts
        self._incremental_facts += self._new_incremental_facts

        # preprocess with bound
        facts = preprocess(self._serialized_facts, max_bound=bound, discrete=True)

        # split into incremental and non-incremental facts
        self._new_incremental_facts = self._get_incremental_facts(facts)
        self._new_processed_facts = _filter_facts(self._new_incremental_facts, facts)

        # filter out facts that were previously processed
        self._new_incremental_facts = _filter_facts(self._incremental_facts, self._new_incremental_facts)
        self._new_processed_facts = _filter_facts(self._processed_facts, self._new_processed_facts)

    def _is_incremental_expression(self, name: str, args: List[Symbol]) -> bool:
        """
        Check if a predicate (given by name and arguments) is an incremental expression

        Args:
            name (str): The name of the predicate
            args (List[Symbol]): The arguments of the predicate as clingo.Symbol's
        """
        return (name in ["function", "binary", "unary"] and args[0].string in self._incremental_expressions) or (
            name == "constraint"
            and args[1].string == "boolean"
            and args[0].arguments[1].string in self._incremental_expressions
        )

    def _remove_new_incremental_expressions(self) -> List[str]:
        """
        Remove all facts from new_incremental_facts that are incremental expressions
        """
        inc_expressions = []
        for fact in self._new_processed_facts:
            name, args = _get_fact_name_and_args(fact)
            if self._is_incremental_expression(name, args):
                inc_expressions.append(fact)

        # move all inc_expressions from new_processed_facts to processed_facts
        self._processed_facts += inc_expressions
        self._new_processed_facts = _filter_facts(self._processed_facts, self._new_processed_facts)

        return inc_expressions

    def _get_incremental_prog_part(self, exp_type: str, args: List[Symbol], bound: int) -> ProgPart:
        """
        Get the incremental program part for an expression of type exp_type with arguments args
        """
        # determine the name of the expression based on its type
        name = ""
        if exp_type in ["function", "binary", "unary"]:
            name = args[0].string
        elif exp_type in ["constraint"]:
            name = args[0].arguments[1].string
        else:
            raise ValueError(f"unknown type of incremental expression: {exp_type}")

        # determine the name and arguments of the program part
        part_name = ""
        # to the arguments we just need to add the current max_bound
        args = args + [Number(bound)]
        # the name of the program part depends on the type of the expression
        if exp_type == "function":
            # for functions we need to check whether they are already initialized
            prefix = ""
            if self._is_initialized[name]:
                prefix = "update_"
            else:
                prefix = "new_"
                self._is_initialized[name] = True
            part_name = prefix + "incremental_function"
        elif exp_type == "binary":
            # for binaries we need to check which of the subexpressions are incremental themselves
            part_name = "incremental_binary"
            lhs = args[1].string
            rhs = args[3].string
            if lhs not in self._incremental_expressions:
                part_name += "_r"
            elif rhs not in self._incremental_expressions:
                part_name += "_l"
        elif exp_type == "unary":
            part_name = "incremental_unary"
        elif exp_type == "constraint":
            part_name = "incremental_constraint"

        return (part_name, args)

    def _get_prog_part_of_inc_set(self, inc_set: str, bound: int) -> List[ProgPart]:
        """
        Get all the program parts belonging to an incremental set
        """
        program_parts = []
        for exp in self._incremental_sets[inc_set]:
            program_parts.append(self._get_incremental_prog_part(exp[0], exp[1], bound))

        return program_parts

    def _get_prog_part(self, fact: str, bound: int) -> ProgPart:
        """
        Get the program part belonging to a fact

        Args:
            fact (str): The fact representet as a string (with trailing '.')
        """
        # convert fact to name and arguments
        name, args = _get_fact_name_and_args(fact)

        # check if the fact corresponds to a valid program part
        if name not in [
            "parent",
            "index",
            "set",
            "type",
            "constraint",
            "column",
            "unary",
            "binary",
            "function",
            "allow",
        ]:
            raise ValueError(f"unknown new fact (no corresponding program part exists): {fact}")

        # some program parts need the current bound as an additional argument
        parts_with_bound = ["type", "constraint"]

        # determine the corresponding program part
        program_part = (
            f"new_{name}",
            # check if bound needs to be added to the args
            args if name not in parts_with_bound else args + [Number(bound)],
        )

        # a fact set(S,X) adds an element to set S
        # if S is an incremental set we need to add its corresponding program parts
        if name == "set" and args[0].string in self._incremental_sets:
            # can not add program parts for the incremental set directly
            # as this could result in parts for one set being added multiple times
            self._inc_sets_to_process.add(args[0].string)

        return program_part

    def _get_incremental_facts(self, facts: List[str]) -> List[str]:
        """
        Collect all incremental facts from a list of facts

        Incremental facts are either predicate inc_set/1 or incremental/4
        """
        # get all facts inc_set/1 and incremental/4 from list of facts
        incremental_facts = [x for x in facts if x.startswith(("inc_set", "incremental"))]

        return incremental_facts

    def _get_initial_incremental_data(self) -> None:
        """
        Obtain incremental expressions and sets for initial bound

        Incremental expressions (and sets) may already turn up with an initial bound of 0 but the preprocessing only
        detects them if at least one element of the type is available, i.e., only if the lower bound is not 0.
        For cases where the unbounded cardinality is of the form 0..* this step is necessary.
        """
        processed_facts = preprocess(self._serialized_facts, max_bound=1, discrete=True)
        self._incremental_facts = self._get_incremental_facts(processed_facts)

        self._update_incremental_data(self._incremental_facts)

    def _update_incremental_data(self, incremental_facts: List[str]) -> None:
        """
        Update internal data structures keeping track of the incremental sets and their expressions
        """
        # incremental_facts contain predicates:
        # inc_set(S) indicating sets S with unbounded cardinalities, and
        # incremental(T,N,S,Arg) indicating an expression of type T with name N
        #                        belonging to set S, Arg are the arguments of the expression
        inc_sets = [parse_term(x[:-1]).arguments[0] for x in incremental_facts if x.startswith("inc_set")]
        inc_expressions = [parse_term(x[:-1]) for x in incremental_facts if x.startswith("incremental")]

        # initialize dictionary for new incremental sets
        for inc_set in inc_sets:
            if inc_set not in self._incremental_sets:
                self._incremental_sets[inc_set.string] = []

        # add incremental expressions
        for exp in inc_expressions:
            # first, add the expressions to the incremental_sets dictionary
            inc_set = exp.arguments[2].string
            x = (exp.arguments[0].string, exp.arguments[3].arguments)
            if x not in self._incremental_sets[inc_set]:
                self._incremental_sets[inc_set].append(x)

            # second, add it to the set of all incremental expressions
            self._incremental_expressions.add(exp.arguments[1].string)

            # for functions we need to keep track whether they are already initialized
            if exp.arguments[0].string == "function":
                if exp.arguments[1].string not in self._is_initialized:
                    self._is_initialized[exp.arguments[1].string] = False

    def _find_minimal_bound(self, control: Control) -> None:
        """
        Find the minimal bound for an instance once a satisfiable bound was found

        This assumes that for _prev_bound the instance was UNSAT, and for max_bound the instance is SAT.
        The minimal bound is found when _prev_bound + 1 is equal to max_bound.
        """
        # unsat_bound and sat_bound give the range of the optimal bound
        unsat_bound = -1
        if self._prev_bound is not None:
            unsat_bound = self._prev_bound
        sat_bound = self.max_bound
        # prev_bound stores the bound from the last solve call
        prev_bound = self.max_bound

        while True:
            # compute next bound to check
            current_bound = next_bound_converge(unsat_bound, sat_bound)
            if current_bound is None:
                print("\nOptimal bound found")
                self.max_bound = sat_bound
                break

            print("\nOptimal bound not yet found")
            print(f"Solving with bound = {current_bound}\n")

            # set active externals
            if current_bound < prev_bound:
                # if the bound we want to solve at is smaller than the previous solve bound,
                # the active externals have to be set to false
                for i in range(current_bound + 1, prev_bound + 1):
                    control.assign_external(Function("active", [Number(i)]), False)
            else:
                # otherwise they have to be set to true
                for i in range(prev_bound + 1, current_bound + 1):
                    control.assign_external(Function("active", [Number(i)]), True)

            # set max_bound externals
            control.assign_external(Function("max_bound", [Number(prev_bound)]), False)
            control.assign_external(Function("max_bound", [Number(current_bound)]), True)

            ret = control.solve()
            # update bound of last solve call
            prev_bound = current_bound
            # update sat/unsat bound depending on result of solve
            if ret.satisfiable:
                sat_bound = current_bound
            else:
                unsat_bound = current_bound

    def main(self, control: Control, files: Sequence[str]) -> None:
        """
        Main function of the multishot application class
        """
        if self._options["solver"] == "fclingo":
            raise ValueError("multishot solving is currently not supported for the fclingo solver")

        encoding = get_encoding("encoding-base-clingo-multi.lp")
        show = get_encoding("show-clingo.lp")
        control.load(encoding)
        control.load(show)

        while True:
            print(f"\nNew max bound is = {self.max_bound} (previous was {self._prev_bound})\n")

            # grounding and assigning active externals
            # in steps of 1 to enable deactivation of specific bounds later (when converging to minimal bound)
            for bound in range(0 if self._prev_bound is None else self._prev_bound + 1, self.max_bound + 1):
                print(f"Grounding with bound = {bound}")

                # preprocessing
                self._preprocess_new_bound(bound)

                # collect program parts
                parts = []

                if bound == 0:
                    # process initial incremental facts
                    self._get_initial_incremental_data()
                    # remove all the new incremental expressions from new_processed_facts
                    inc_expressions = self._remove_new_incremental_expressions()
                    # add the incremental program parts for each of the incremental expressions
                    for fact in inc_expressions:
                        name, args = _get_fact_name_and_args(fact)
                        parts.append(self._get_incremental_prog_part(name, args, bound))

                    # ground base with the preprocessed facts added
                    # (needs to be grounded before other program parts below)
                    control.add("base", [], "".join(self._new_processed_facts))
                    control.ground([("base", [])])
                else:
                    self._update_incremental_data(self._new_incremental_facts)

                    # remove all the new incremental expressions from new_processed_facts
                    # adding their program parts is handled below (via inc_set)
                    self._remove_new_incremental_expressions()

                    # keep track of inc sets that were updated (i.e. received new member)
                    self._inc_sets_to_process = set()

                    # collect program parts for all the new facts
                    for fact in self._new_processed_facts:
                        # this also adds sets to self._inc_sets_to_process
                        parts.append(self._get_prog_part(fact, bound))

                    # collect program parts for all the incremental sets were updated
                    for inc_set in self._inc_sets_to_process:
                        parts += self._get_prog_part_of_inc_set(inc_set, bound)

                # ground
                control.ground(parts)

                # update active external
                control.assign_external(Function("active", [Number(bound)]), True)

            # update max bound external
            control.assign_external(Function("max_bound", [Number(self.max_bound)]), True)
            if self._prev_bound is not None:
                control.assign_external(Function("max_bound", [Number(self._prev_bound)]), False)

            # solve
            print(f"\nSolving with bound = {self.max_bound}\n")
            ret = control.solve()
            if ret.satisfiable:
                self._find_minimal_bound(control)
                break

            self._update_bound()
