"""
Clingo application class for solving COOM configuration problems with multi-shot solving.
"""

from typing import Any, Dict, Iterator, List, Optional, Sequence, Set, Tuple, TypeAlias

from clingo import Control
from clingo.symbol import Function, Number, Symbol, parse_term

from coomsuite.application import COOMSolverApp
from coomsuite.preprocess import preprocess
from coomsuite.utils import get_encoding

from . import get_bound_iter, next_bound_converge

ProgPart: TypeAlias = Tuple[str, Tuple[Symbol, ...]]


def print_prog_parts(parts: List[ProgPart], name_filter: List[str] | None = None) -> None:  # nocoverage
    """
    Print a list of program parts, optionally include a filter (useful for debugging).

    The name_filter is a list of program part names. Any part names not included in the filter are not printed.
    Note that any prefixes of program parts (such as new_, update_, incremental_) as well as suffixes (_r, _l)
    do not need to be included in the name_filter.
    """
    for part in parts:
        name = part[0]

        x = name
        for prefix in ["update_", "new_", "incremental_"]:
            x = x.removeprefix(prefix)
        for suffix in ["_r", "_l"]:
            x = x.removesuffix(suffix)
        if name_filter and x not in name_filter:
            continue

        part_str = name
        part_str += "("
        for i, arg in enumerate(part[1]):
            part_str += str(arg)
            if i < len(part[1]) - 1:
                part_str += ","
        part_str += ")"
        print(part_str)


def _get_fact_name_and_args(fact: str) -> ProgPart:
    """
    Convert a fact given as a string to its name and arguments

    Args:
        fact (str): The fact in string representation (with trailing '.')

    Returns:
        ProgPart: A tuple of the name of the fact and the tuple of its arguments
    """
    x = parse_term(fact[:-1])
    return (x.name, tuple(x.arguments))


class COOMMultiSolverApp(COOMSolverApp):  # pylint: disable=too-many-instance-attributes
    """
    Application class for multi-shot solving extending the standard COOM application class
    """

    def __init__(
        self,
        serialized_facts: List[str],
        algorithm: str = "linear",
        initial_bound: int = 0,
        step: Optional[int] = 1,
        base: Optional[float] = 2.0,
        log_level: str = "",
        options: Optional[Dict[str, Any]] = None,
        istest: bool = False,
    ):  # pylint: disable=too-many-arguments,too-many-positional-arguments
        super().__init__(log_level, options, istest)

        if self._options["solver"] == "flingo":
            raise ValueError("multishot solving is currently not supported for the flingo solver")

        self._serialized_facts: List[str] = serialized_facts
        """The instance to solve given as serialized facts"""

        self._bound_iter: Iterator[int] = get_bound_iter(algorithm, initial_bound, step, base)
        """Iterator determining the bounds"""
        self.current_max_bound: int = next(self._bound_iter)
        """The current max bound"""

        self._prev_bound: Optional[int] = None
        """The previous max bound"""

        self._new_processed_facts: Set[str] = set()
        """Processed facts added by current preprocessing step"""
        self._processed_facts: Set[str] = set()
        """Processed facts from all previous preprocessing steps"""

        self._incremental_parts: Set[ProgPart] = set()
        """The set of all incremental program parts"""
        self._incremental_expressions: Set[str] = set()
        """The set of all incremental expressions (represented by their name)"""
        self._is_initialized: Set[str] = set()
        """Keeps track of all incremental expressions that are already initialized"""

    def _update_bound(self) -> None:
        """
        Update the current maximum bound
        """
        self._prev_bound = self.current_max_bound
        self.current_max_bound = next(self._bound_iter)

    def _preprocess_new_bound(self, bound: int) -> None:
        """
        Preprocess the serialized facts for the given bound and update the fact data structures

        Args:
            bound (int): the value of max_bound to preprocess
        """
        # update facts that were already processed
        self._processed_facts.update(self._new_processed_facts)

        # preprocess with bound
        facts = set(preprocess(self._serialized_facts, max_bound=bound, discrete=True, multishot=True))

        # split facts into incremental and non-incremental facts
        incremental_facts = set()
        non_incremental_facts = set()
        for x in facts:
            if x.startswith(("inc_set", "incremental")):
                incremental_facts.add(x)
            else:
                non_incremental_facts.add(x)

        # update incremental data with results from preprocessing
        self._update_incremental_data(incremental_facts)

        # filter out facts that were previously processed
        self._new_processed_facts = non_incremental_facts - self._processed_facts

    def _remove_new_incremental_expressions(self) -> List[ProgPart]:
        """
        Remove all facts from new_processed_facts that are incremental expressions

        Program parts for incremental expressions are added by iterating over self._incremental_parts.
        This is done because the facts for incremental expressions are only added once,
        but then have to be updated for every new bound. To ensure that any new incremental
        facts are also added in the correct way they are removed from the _new_processed_facts.

        Returns:
            List[ProgPart]: list of incremental expressions represented as tuples (name, args)
        """
        inc_expressions = []
        for fact in self._new_processed_facts:
            name, args = _get_fact_name_and_args(fact)

            # check if the fact is an incremental constraint
            is_incremental_constraint = (
                name == "constraint"
                and args[1].string == "boolean"
                and args[0].arguments[1].string in self._incremental_expressions
            )
            # check if the fact is an incremental expression
            is_incremental_expression = (
                name in ["function", "binary", "unary", "minimize", "maximize"]
                and args[0].string in self._incremental_expressions
            )

            if is_incremental_constraint or is_incremental_expression:
                inc_expressions.append((name, args))
                # add the fact to the processed_facts
                self._processed_facts.add(fact)

        # filter new_processed_facts to remove the incremental expressions
        self._new_processed_facts = self._new_processed_facts - self._processed_facts

        return inc_expressions

    def _get_incremental_prog_part(self, exp_type: str, args: Tuple[Symbol, ...], bound: int) -> ProgPart:
        """
        Get the incremental program part for an expression

        Args:
            exp_type (str): string representing the type of the expression
            args (Tuple[Symbol, ...]): the arguments of the expression
            bounds (int): the current bound to use as parameter of the program part

        Returns:
            ProgPart: the program part containing the rules to update the incremental expression
        """
        # determine the name and arguments of the program part
        part_name = ""
        # to the arguments we just need to add the current max_bound
        args += (Number(bound),)
        # the name of the program part depends on the type of the expression
        match exp_type:
            case "unary" | "constraint" | "minimize" | "maximize":
                part_name = "incremental_" + exp_type
            case "function":
                # determine the name of the function
                name = args[0].string
                # to determine the part name we need to check if the function is initialized
                prefix = "update_" if name in self._is_initialized else "new_"
                part_name = prefix + "incremental_function"
                # mark the function as initialized
                self._is_initialized.add(name)
            case "binary":
                # for binaries we need to check which of the subexpressions are incremental themselves
                part_name = "incremental_binary"
                lhs = args[1].string
                rhs = args[3].string

                lhs_inc = lhs in self._incremental_expressions
                rhs_inc = rhs in self._incremental_expressions
                if lhs_inc and not rhs_inc:
                    part_name += "_l"
                elif not lhs_inc and rhs_inc:
                    part_name += "_r"
                elif not lhs_inc and not rhs_inc:
                    # one subexpression has to be incremental as otherwise the binary would not be incremental
                    raise ValueError(f"Incremental binary but no subexpression is incremental: {args}")  # nocoverage
                # if both lhs and rhs are incremental no suffix is added
            case _:
                raise ValueError(f"unknown type of incremental expression: {exp_type}")

        return (part_name, args)

    def _get_prog_part(self, fact: str, bound: int) -> ProgPart:
        """
        Get the program part belonging to a fact

        Args:
            fact (str): The fact representet as a string (with trailing '.')
            bound (int): the current bound to use as parameter of the program part

        Returns:
            ProgPart: the program part containing the rules for the fact
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
            "number",
            "constant",
            "minimize",
            "maximize",
        ]:
            raise ValueError(f"unknown new fact (no corresponding program part exists): {fact}")  # nocoverage

        # some program parts need the current bound as an additional argument
        needs_bound = False
        if name in ["type", "constraint", "column"]:
            needs_bound = True

        if needs_bound:
            args += (Number(bound),)

        # determine the corresponding program part
        program_part = (f"new_{name}", args)

        return program_part

    def _update_incremental_data(self, incremental_facts: Set[str]) -> None:
        """
        Update internal data structures keeping track of the incremental sets and their expressions

        Args:
            incremental_facts (Set[str]): a set of incremental facts to add to the internal incremental data structures
        """
        # incremental_facts contains the predicate:
        # incremental(T,N,Args) indicating an expression of type T with name N is incremental
        #                       Args are the arguments of the expression
        inc_expressions = {parse_term(x[:-1]) for x in incremental_facts if x.startswith("incremental")}

        # add incremental expressions
        for exp in inc_expressions:
            exp_type = exp.arguments[0].string
            exp_name = exp.arguments[1].string
            exp_args = tuple(exp.arguments[2].arguments)

            # first, add the expressions to the set of incremental parts
            # for incremental expressions of type path this is not done, as paths are only auxiliary
            # and only used for the set of all incremental expressions (below)
            if exp_type != "path":
                self._incremental_parts.add((exp_type, exp_args))

            # second, add its name to the set of all incremental expressions
            self._incremental_expressions.add(exp_name)

    def _find_minimal_bound(self, control: Control) -> None:
        """
        Find the minimal bound for an instance once a satisfiable bound was found

        This assumes that for _prev_bound the instance was UNSAT, and for max_bound the instance is SAT.
        The minimal bound is found when _prev_bound + 1 is equal to max_bound.

        After returning max_bound is the minimal bound for which the program is satisfiable.

        Args:
            control (Control): the control object (already containing all program parts grounded)
        """
        # unsat_bound and sat_bound give the range of the optimal bound
        unsat_bound = -1 if self._prev_bound is None else self._prev_bound
        sat_bound = self.current_max_bound
        # last_bound stores the bound from the last solve call
        last_bound = self.current_max_bound

        while True:
            # compute next bound to check
            current_bound = next_bound_converge(unsat_bound, sat_bound)

            # check if we found the optimal bound
            if current_bound is None:
                print("\nOptimal bound found")
                self.current_max_bound = sat_bound
                break

            # if we do not have the optimal bound yet we do another solve
            print("\nOptimal bound not yet found")
            print(f"Solving with bound = {current_bound}\n")

            # set active externals
            if current_bound < last_bound:
                # if the bound we want to solve at is smaller than the last bound,
                # the active externals have to be set to false
                for i in range(current_bound + 1, last_bound + 1):
                    control.assign_external(Function("active", [Number(i)]), False)
            else:
                # otherwise they have to be set to true
                for i in range(last_bound + 1, current_bound + 1):
                    control.assign_external(Function("active", [Number(i)]), True)

            # set max_bound externals
            control.release_external(Function("max_bound", [Number(last_bound)]))
            control.assign_external(Function("max_bound", [Number(current_bound)]), True)

            ret = control.solve()
            # update bound of last solve call
            last_bound = current_bound
            # update sat/unsat bound depending on result of solve
            if ret.satisfiable:
                sat_bound = current_bound
            else:
                unsat_bound = current_bound

    def _compute_prog_parts(self, bound: int) -> List[ProgPart]:
        """
        Compute all program parts for the current new processed facts

        Args:
            bound (int): the current bound to compute program parts for

        Returns:
            List[ProgPart]: the list of all program parts needed for bound
        """
        parts = []

        # remove all expressions that were detected as incremental from the processed facts
        # (necessary to avoid adding them via the normal new_* program parts,
        # instead we add them using specific incremental program parts later)
        incremental_expressions = self._remove_new_incremental_expressions()

        if bound == 0:
            # add the incremental program parts corresponding to each incremental expression
            for name, args in incremental_expressions:
                parts.append(self._get_incremental_prog_part(name, args, bound))
        else:
            # collect program parts for all the new facts
            for fact in self._new_processed_facts:
                parts.append(self._get_prog_part(fact, bound))

            # add the program parts belonging to every incremental set
            for part in self._incremental_parts:
                parts.append(self._get_incremental_prog_part(part[0], part[1], bound))

        return parts

    def main(self, control: Control, files: Sequence[str]) -> None:
        """
        Main function of the multishot application class

        After returning the attribute max_bound is the minimal bound for which the instance is satisfiable.

        Args:
            control (Control): the clingo control object
        """
        control.load(get_encoding("encoding-base-clingo-multi.lp"))
        control.load(get_encoding("show-clingo.lp"))

        while True:
            print(f"\nNew max bound is = {self.current_max_bound} (previous was {self._prev_bound})\n")

            # grounding and assigning active externals
            # in steps of 1 to enable deactivation of specific bounds later (when converging to minimal bound)
            for bound in range(0 if self._prev_bound is None else self._prev_bound + 1, self.current_max_bound + 1):
                print(f"Grounding with bound = {bound}")

                # preprocessing
                self._preprocess_new_bound(bound)

                # collect program parts
                parts = self._compute_prog_parts(bound)

                if bound == 0:
                    # ground base with the remaining preprocessed facts added
                    # (needs to be grounded before other program parts below)
                    control.add("base", [], "".join(self._new_processed_facts))
                    control.ground([("base", [])])

                # ground
                control.ground(parts)

                # update active external
                control.assign_external(Function("active", [Number(bound)]), True)

            # update max bound external
            control.assign_external(Function("max_bound", [Number(self.current_max_bound)]), True)
            if self._prev_bound is not None:
                control.release_external(Function("max_bound", [Number(self._prev_bound)]))

            # solve
            print(f"\nSolving with bound = {self.current_max_bound}\n")
            ret = control.solve()
            if ret.satisfiable:
                self._find_minimal_bound(control)
                break

            self._update_bound()
