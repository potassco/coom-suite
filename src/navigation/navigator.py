"""
Module defining the navigator class.
"""

from typing import Dict, Iterator, List, Optional, Set, Tuple

from clingo.control import Control
from clingo.solving import Model, SolveHandle
from clingo.symbol import Symbol, parse_term

ProgPart = Tuple[str, List[Symbol]]


class Navigator:  # pylint: disable=too-many-public-methods,too-many-instance-attributes
    """
    Class to navigate solution spaces of logic programs.
    """

    def __init__(self, control: Optional[Control] = None, grounded: Optional[bool] = None):
        """
        Args:
            control (Optional[Control]): optionally pass a control object to use
            grounded_base (Optional[bool]): indicate if the passed control object was already grounded
        """
        if control:
            self._control = control
            self._base_ground = bool(grounded)
        else:
            self._control = Control()
            self._base_ground = False

        self._reasoning_mode = "auto"
        self._optimization = False

        self._brave = None
        self._cautious = None
        self._facets = None

        self._atoms: Optional[Set[Symbol]] = None

        self._solve_handle: Optional[SolveHandle] = None
        self._model_iterator: Optional[Iterator[Model]] = None

        self._assumptions: Set[Tuple[Symbol, bool]] = set()
        self._externals: Dict[Symbol, Optional[bool]] = {}

        self._program_name = "add"
        self._program_counter = 0
        # keep track of whether a rule is active or not
        self._rules: Dict[str, bool] = {}
        # the external belonging to a rule to activate/deactivate it (also the program part name)
        self._rule_map: Dict[str, Symbol] = {}
        # keep track of which rules are not ground yet
        self._non_ground_rules: Set[str] = set()

        self._auxiliary_atoms: set[Symbol] = set()

    def load(self, file_path: str) -> None:
        """
        Load a file into the logic program.
        """
        self._clear_consequences()
        self._base_ground = False
        self._control.load(file_path)

    def _outdate_atoms(self) -> None:
        """
        Called whenever the set of symbols of the program changes.
        """
        self._atoms = set()

    def _outdate_solution_space(self) -> None:
        """
        Called whenever the solution space of the program changes.
        """
        self._clear_browsing()
        self._clear_consequences()

    def _clear_browsing(self) -> None:
        """
        Cancel the solve handle and clear the model iterator.
        """
        if self._solve_handle:
            self._solve_handle.cancel()
            self._solve_handle = None
            self._model_iterator = None

    def _clear_consequences(self) -> None:
        """
        Clear brave/cautious consequences and facets.
        """
        self._brave = None
        self._cautious = None
        self._facets = None

    def ground(self, parts: List[ProgPart] = [("base", [])]) -> None:  # pylint: disable=dangerous-default-value
        """
        Ground the specified program parts.
        """
        if ("base", []) in parts:
            self._base_ground = True
        self._control.ground(parts)

    def _activate_rules(self, rules: Set[str]) -> None:
        """
        Activate a set of rules by setting their activation externals.
        """
        for rule in rules:
            if rule in self._rules:
                external = self._rule_map[rule]
                self._control.assign_external(external, self._rules[rule])

    def _ground(self, parts: Optional[List[ProgPart]] = None) -> None:
        """
        Ground program parts, if base was not grounded yet it is added to the parts.
        """
        if parts is None:
            parts = []

        if not self._base_ground:
            if ("base", []) not in parts:
                parts.append(("base", []))

        for rule in self._non_ground_rules:
            part = self._rule_map[rule]
            parts.append((str(part), []))

        if parts:
            self.ground(parts)

        self._activate_rules(self._non_ground_rules)
        self._non_ground_rules = set()

    def _update_configuration(self, num_models: int = 1) -> None:
        """
        Update the configuration of the control object by setting enum_mode, number of models, opt_mode.
        """
        # set the enum_mode
        match self._reasoning_mode:
            case "brave":
                self._control.configuration.solve.enum_mode = "brave"
            case "cautious":
                self._control.configuration.solve.enum_mode = "cautious"
            case _:
                self._control.configuration.solve.enum_mode = "auto"

        # set the heursitic
        match self._reasoning_mode:
            case "diverse" | "similar":
                self._control.configuration.solver.heuristic = "Domain"
            case _:
                # TODO: is this needed?
                self._control.configuration.solver.heuristic = "Vsids,92"

        self._control.configuration.solve.models = num_models

        if self._optimization:
            self._control.configuration.solve.opt_mode = "optN"
        else:
            self._control.configuration.solve.opt_mode = "ignore"

    def _solve(self, num_models: int = 1) -> Optional[Set[Symbol]] | List[Set[Symbol]]:
        """
        Solve the logic program.

        Depending on the current reasoning mode the return is either a list of models (auto reasoning mode)
        or a single model (brave, cautious or browsing reasoning mode).
        Note that models here are just sets of Symbols.
        """
        # TODO: support for timeouts
        browsing = self._reasoning_mode == "browse"

        if not browsing:
            self._clear_browsing()

        all_models: List[Set[Symbol]] = []
        last_model: Optional[Set[Symbol]] = None
        if not browsing or self._model_iterator is None:
            self._update_configuration(num_models)
            self._ground()

            handle = self._control.solve(assumptions=list(self._assumptions), yield_=True)

            if browsing:
                self._solve_handle = handle
                self._model_iterator = iter(handle)
            else:
                for m in handle:
                    if self._optimization and not m.optimality_proven:
                        continue
                    model = self._on_model(m)
                    if self._reasoning_mode == "auto":
                        all_models.append(model)
                    else:
                        last_model = model
                handle.cancel()

        if browsing:
            try:
                m = next(self._model_iterator)  # type: ignore [arg-type]
                while self._optimization and not m.optimality_proven:
                    m = next(self._model_iterator)  # type: ignore [arg-type]
                last_model = self._on_model(m)
            except StopIteration:
                self._solve_handle.cancel()  # type: ignore [union-attr]
                self._solve_handle = None
                self._model_iterator = None

        match self._reasoning_mode:
            case "auto":
                return all_models
            case _:
                return last_model

    def _is_auxiliary(self, symbol: Symbol) -> bool:
        """
        Check if a symbol is auxiliary.
        """
        return symbol in self._auxiliary_atoms

    def _on_model(self, model: Model) -> Set[Symbol]:
        """
        Convert a model to a set of symbols filtering auxiliary symbols.
        """
        result = set()
        for s in model.symbols(shown=True):
            if not self._is_auxiliary(s):
                result.add(s)
        return result

    def enable_optimization(self) -> None:
        """
        Enable optimization while solving.
        """
        self._outdate_solution_space()
        self._optimization = True

    def disable_optimization(self) -> None:
        """
        Disable optimization while solving.
        """
        self._outdate_solution_space()
        self._optimization = False

    def compute_models(self, num_models: int = 1) -> List[Set[Symbol]]:
        """
        Compute num_models many models.
        """
        self._reasoning_mode = "auto"
        return self._solve(num_models)  # type: ignore [return-value]

    def browse_models(self) -> Set[Symbol]:
        """
        Compute model iteratively.
        """
        self._reasoning_mode = "browse"
        return self._solve(0)  # type: ignore [return-value]

    def compute_brave_consequences(self) -> Set[Symbol]:
        """
        Compute the brave consequences.
        """
        if self._brave is None:
            self._reasoning_mode = "brave"
            self._brave = self._solve(0)  # type: ignore [assignment]
        return self._brave  # type: ignore [return-value]

    def compute_cautious_consequences(self) -> Set[Symbol]:
        """
        Compute the cautious consequences.
        """
        if self._cautious is None:
            self._reasoning_mode = "cautious"
            self._cautious = self._solve(0)  # type: ignore [assignment]
        return self._cautious  # type: ignore [return-value]

    def compute_facets(self) -> Set[Symbol]:
        """
        Compute the facets of the program.
        """
        if self._facets is None:
            brave = self.compute_brave_consequences()
            cautious = self.compute_cautious_consequences()
            self._facets = brave - cautious  # type: ignore [assignment]
        return self._facets  # type: ignore [return-value]

    def _get_all_atoms(self) -> Set[Symbol]:
        """
        Get the set of all symbols.

        This function should be used instead of directly accessing self._atoms.
        """
        if self._atoms is None:
            for atom in self._control.symbolic_atoms:
                if not atom.is_external:
                    self._atoms.add(atom.symbol)

        return self._atoms

    def _get_partial_interpretation(
        self, models: List[Set[Symbol]], diverse: bool = True
    ) -> Dict[Symbol, Optional[bool]]:
        """
        Get a partial interpretation diverse/similar to the list of models.
        """
        partial_int = {}
        for atom in self._get_all_atoms():
            val = 0
            # for every model check if the atom is true/false
            for model in models:
                if atom in model:
                    val += 1
                else:
                    val -= 1

            # set the value of the atom in the partial interpretation
            if val > 0:
                partial_int[atom] = False if diverse else True
            elif val < 0:
                partial_int[atom] = True if diverse else False
            else:
                partial_int[atom] = None

        return partial_int

    def _get_heuristics(self, partial_int: Dict[Symbol, Optional[bool]], external: Symbol) -> str:
        """
        Get heuristic statements for the partial interpretation.
        """
        prog = f"#external {external}.\n"

        for atom in partial_int:
            # add heurisitc statements for each atom that has a value in partial_int
            match partial_int[atom]:
                case True:
                    prog += f"#heuristic {atom} : {external}. [ 1, true ]\n"
                case False:
                    prog += f"#heuristic {atom} : {external}. [ 1, false ]\n"

        return prog

    def _get_model_from_partial_int(self, partial_int: Dict[Symbol, Optional[bool]]) -> Set[Symbol]:
        """
        Get a model similar to the partial interpretation.
        """
        name = self._get_new_program_name()
        external = self._as_symbol(name)
        self._auxiliary_atoms.add(external)

        heuristics_prog = self._get_heuristics(partial_int, external)

        self._control.add(name, [], heuristics_prog)
        self._ground([(name, [])])
        self._control.assign_external(external, True)

        model = self._solve()

        self._control.release_external(external)

        return model

    def _extend_solution_set(self, models: List[Set[Symbol]], diverse: bool = True) -> Set[Symbol]:
        """
        Extend the current solution set by a diverse/similar model.
        """
        partial_int = self._get_partial_interpretation(models, diverse)
        new_model = self._get_model_from_partial_int(partial_int)
        return new_model

    def _model_to_constraint(self, model: Set[Symbol], external: Symbol) -> str:
        """
        Turn a model into a constraint which forbids this model.
        """
        literals = []
        for atom in self._get_all_atoms():
            if atom in model:
                literals.append(f"{atom}")
            else:
                literals.append(f"not {atom}")

        constraint = f":- {external}"
        for lit in literals:
            constraint += ", " + lit
        constraint += "."

        prg = f"#external {external}.\n" + constraint

        return prg

    def _forbid_model(self, model: Set[Symbol]) -> Symbol:
        """
        Add a constraint to forbid the model to the program.

        Returns:
            Symbol: the symbol of the external to deactivate the constraint.
        """
        name = self._get_new_program_name()
        external = self._as_symbol(name)
        self._auxiliary_atoms.add(external)
        constraint = self._model_to_constraint(model, external)
        self._control.add(name, [], constraint)
        self._ground([(name, [])])
        self._control.assign_external(external, True)

        return external

    def _compute_diverse_similar_models(self, num_models, diverse: bool = True) -> List[Set[Symbol]]:
        """
        Helper function to compute diverse/similar models.
        """
        models = []
        externals = []

        for i in range(num_models):
            new_model = self._extend_solution_set(models, diverse)
            models.append(new_model)

            # for all but the last model add a constraint to the program to avoid repeating this model
            if i < num_models - 1:
                external = self._forbid_model(new_model)
                externals.append(external)

        # deactivate all added constraints
        for external in externals:
            self._control.release_external(external)

        return models

    def compute_diverse_models(self, num_models: int = 1) -> List[Set[Symbol]]:
        """
        Compute num_models many diverse models.
        """
        self._reasoning_mode = "diverse"
        return self._compute_diverse_similar_models(num_models, diverse=True)

    def compute_similar_models(self, num_models: int = 1) -> List[Set[Symbol]]:
        """
        Compute num_models many similar models.
        """
        self._reasoning_mode = "similar"
        return self._compute_diverse_similar_models(num_models, diverse=False)

    def browse_diverse_models(self) -> Set[Symbol]:
        """
        Compute diverse models iteratively.
        """

    def browse_similar_models(self) -> Set[Symbol]:
        """
        Compute similar models iteratively.
        """

    def _as_symbol(self, symbol: str | Symbol) -> Symbol:
        """
        Convert a symbol or string to a symbol.
        """
        if isinstance(symbol, str):
            symbol = parse_term(symbol)

        return symbol

    def add_assumption(self, symbol: str | Symbol, value: bool) -> None:
        """
        Add an assumption to the logic program.
        """
        symbol = self._as_symbol(symbol)
        self._outdate_solution_space()
        self._assumptions.add((symbol, value))

    def remove_assumption(self, symbol: str | Symbol, value: bool) -> None:
        """
        Remove an assumption from the logic program.
        """
        symbol = self._as_symbol(symbol)
        self._outdate_solution_space()
        self._assumptions.discard((symbol, value))

    def clear_assumptions(self) -> None:
        """
        Remove all assumptions from the logic program.
        """
        self._outdate_solution_space()
        self._assumptions = set()

    def get_assumptions(self) -> Set[Tuple[Symbol, bool]]:
        """
        Get the current assumptions.
        """
        return self._assumptions

    def set_external(self, symbol: str | Symbol, value: bool | None) -> None:
        """
        Set the value of an external.
        """
        symbol = self._as_symbol(symbol)
        self._outdate_solution_space()
        self._externals[symbol] = value
        if value is not None:
            self._control.assign_external(symbol, value)
        else:
            self._control.release_external(symbol)

    def clear_externals(self) -> None:
        """
        Release all externals.
        """
        self._outdate_solution_space()
        for symbol in self._externals:
            self.set_external(symbol, None)

    def get_externals(self) -> Dict[Symbol, Optional[bool]]:
        """
        Get the current values of the externals.
        """
        return self._externals

    # TODO: add a function to get all the externals from the program?

    def _get_new_program_name(self) -> str:
        """
        Get a new program part name.
        """
        name = self._program_name + str(self._program_counter)
        self._program_counter += 1
        return name

    def _add_external_to_rule(self, rule: str, external: Symbol) -> str:
        """
        Add an external to a the rule body in order to control activation of the rule.
        """
        has_body = ":-" in rule

        external_statement = f"#external {external}.\n"

        if has_body:
            new_rule = rule[:-1] + f", {external}."
        else:
            new_rule = rule[:-1] + f" :- {external}."

        return external_statement + new_rule

    def _add_rule(self, rule: str, permanent: bool = False) -> None:
        """
        Internal function to add a rule to the logic program.
        """
        self._outdate_solution_space()

        name = self._get_new_program_name()
        self._non_ground_rules.add(rule)

        external = self._as_symbol(name)
        self._rule_map[rule] = external
        self._auxiliary_atoms.add(external)
        # add the activation external to the rule
        if not permanent:
            self._rules[rule] = True
            rule = self._add_external_to_rule(rule, external)

        self._control.add(name, [], rule)

    def add_rule(self, rule: str, permanent: bool = False) -> None:
        """
        Add a rule to the logic program.
        """
        # TODO: check that head is a new atom to avoid redefinition error
        self._outdate_atoms
        self._add_rule(rule, permanent)

    def _set_value_of_rule(self, rule: str, value: bool) -> None:
        """
        Set the activation external of a rule to the specified value.
        """
        self._outdate_solution_space()
        self._rules[rule] = value
        if rule not in self._non_ground_rules:
            external = self._rule_map[rule]
            self._control.assign_external(external, value)

    def deactivate_rule(self, rule: str) -> None:
        """
        Deactivate a rule of the logic program.
        """
        self._set_value_of_rule(rule, False)

    def activate_rule(self, rule: str) -> None:
        """
        Activate a rule of the logic program.
        """
        self._set_value_of_rule(rule, True)

    def get_rules(self) -> Dict[str, bool]:
        """
        Get all added rules and their activation status.
        """
        return self._rules

    def add_constraint(self, constraint: str, permanent: bool = False) -> None:
        """
        Add a constraint to the logic program.
        """
        # TODO: should argument be the whole constraint or just the constraint body?
        self._add_rule(constraint, permanent)
