"""
Module defining the navigator class.
"""

from typing import Iterator

from clingo.control import Control
from clingo.solving import Model, SolveHandle
from clingo.symbol import Symbol, parse_term

ProgPart = tuple[str, list[Symbol]]


class Navigator:  # pylint: disable=too-many-public-methods,too-many-instance-attributes
    """
    Class to navigate solution spaces of logic programs.
    """

    def __init__(self, control: Control | None = None, grounded: bool | None = None):
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

        self._brave: set[Symbol] | None = None
        self._cautious: set[Symbol] | None = None
        self._facets: set[Symbol] | None = None

        self._atoms: set[Symbol] | None = None

        self._solve_handle: SolveHandle | None = None
        self._model_iterator: Iterator[Model] | None = None

        self._assumptions: set[tuple[Symbol, bool]] = set()
        self._externals: dict[Symbol, bool | None] = {}

        self._program_name = "add"
        self._program_counter = 0
        # keep track of whether a rule is active or not
        self._rules: dict[str, bool] = {}
        # the external belonging to a rule to activate/deactivate it (also the program part name)
        self._rule_map: dict[str, Symbol] = {}
        # keep track of which rules are not ground yet
        self._non_ground_rules: set[str] = set()

        self._auxiliary_atoms: set[Symbol] = set()

    def load(self, file_path: str) -> None:
        """
        Load a file into the logic program.
        """
        self._clear_consequences()
        self._control.load(file_path)

    def _outdate_atoms(self) -> None:
        """
        Called whenever the set of symbols of the program changes.
        """
        self._atoms = None

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

    def ground(self, parts: list[ProgPart] = [("base", [])]) -> None:  # pylint: disable=dangerous-default-value
        """
        Ground the specified program parts.
        """
        if ("base", []) in parts:
            self._base_ground = True
        self._control.ground(parts)

    def _activate_rules(self, rules: set[str]) -> None:
        """
        Activate a set of rules by setting their activation externals.
        """
        for rule in rules:
            if rule in self._rules:
                external = self._rule_map[rule]
                self._control.assign_external(external, self._rules[rule])

    def _ground(self, parts: list[ProgPart] | None = None) -> None:
        """
        Ground program parts, if base was not grounded yet it is added to the parts.
        """
        if parts is None:
            parts = []

        # add base program part if it is not grounded yet
        if not self._base_ground:
            if ("base", []) not in parts:
                parts.append(("base", []))

        # add program parts corresponding to added rules
        for rule in self._non_ground_rules:
            part = self._rule_map[rule]
            parts.append((str(part), []))

        if parts:
            self.ground(parts)

        # set activation of the newly grounded rules
        self._activate_rules(self._non_ground_rules)

        # clear set of non-ground rules
        self._non_ground_rules = set()

    def _update_configuration(self, num_models: int = 1) -> None:
        """
        Update the configuration of the control object.
        """
        # set the enum_mode
        match self._reasoning_mode:
            case "brave":
                self._control.configuration.solve.enum_mode = "brave"  # type: ignore
            case "cautious":
                self._control.configuration.solve.enum_mode = "cautious"  # type: ignore
            case _:
                self._control.configuration.solve.enum_mode = "auto"  # type: ignore

        # set the heursitic
        match self._reasoning_mode:
            case "diverse" | "similar":
                self._control.configuration.solver.heuristic = "Domain"  # type: ignore
            case _:
                # TODO: is this needed?
                self._control.configuration.solver.heuristic = "Vsids,92"  # type: ignore

        # set number of models
        match self._reasoning_mode:
            case "auto" | "diverse" | "similar":
                self._control.configuration.solve.models = num_models  # type: ignore
            case _:
                self._control.configuration.solve.models = 0  # type: ignore

        # set optimization mode
        if self._optimization:
            self._control.configuration.solve.opt_mode = "optN"  # type: ignore
        else:
            self._control.configuration.solve.opt_mode = "ignore"  # type: ignore

    def _get_solve_handle(self, num_models: int = 1) -> SolveHandle:
        """
        Get a solve handle for the logic program.

        This function also takes care of updating the solver configuration and grounding.
        """
        if not self._reasoning_mode == "browse":
            self._clear_browsing()

        self._update_configuration(num_models)
        self._ground()

        handle = self._control.solve(assumptions=list(self._assumptions), yield_=True)

        return handle

    def _browse(self) -> set[Symbol] | None:
        """
        Solve the logic program for the next model.
        """
        # get a solve_handle/model_iterator if there is none
        if self._model_iterator is None:
            handle = self._get_solve_handle()
            self._solve_handle = handle
            self._model_iterator = iter(handle)

        # get the next model from the iterator
        model = None
        try:
            m = next(self._model_iterator)
            while self._optimization and not m.optimality_proven:
                m = next(self._model_iterator)
            model = self._on_model(m)
        except StopIteration:
            self._solve_handle.cancel()  # type: ignore[union-attr]
            self._solve_handle = None
            self._model_iterator = None

        return model

    def _solve(self, num_models: int = 1) -> list[set[Symbol]]:
        """
        Solve the logic program for num_models.
        """
        handle = self._get_solve_handle(num_models)

        models = []
        for m in handle:
            if self._optimization and not m.optimality_proven:
                # skip non optimal models if optimizing
                continue

            model = self._on_model(m)

            # for the auto reasoning mode we save all models
            if self._reasoning_mode == "auto":
                models.append(model)
            # for all other modes only the last model
            else:
                models = [model]

        handle.cancel()

        return models

    def _solve_single(self) -> set[Symbol] | None:
        """
        Solve the logic program for a single model.

        Wrapper around self._solve with different return type.
        """
        models = self._solve(1)

        if len(models) == 0:
            model = None
        else:
            model = models[0]

        return model

    def _is_auxiliary(self, symbol: Symbol) -> bool:
        """
        Check if a symbol is auxiliary.
        """
        return symbol in self._auxiliary_atoms

    def _on_model(self, model: Model) -> set[Symbol]:
        """
        Convert a model to a set of symbols filtering auxiliary symbols.
        """
        result = set()
        for s in model.symbols(atoms=True):
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

    def compute_models(self, num_models: int = 1) -> list[set[Symbol]]:
        """
        Compute num_models many models.
        """
        self._reasoning_mode = "auto"
        return self._solve(num_models)

    def browse_models(self) -> set[Symbol] | None:
        """
        Compute model iteratively.
        """
        self._reasoning_mode = "browse"
        return self._browse()

    def compute_brave_consequences(self) -> set[Symbol] | None:
        """
        Compute the brave consequences.
        """
        if self._brave is None:
            self._reasoning_mode = "brave"
            self._brave = self._solve_single()
        return self._brave

    def compute_cautious_consequences(self) -> set[Symbol] | None:
        """
        Compute the cautious consequences.
        """
        if self._cautious is None:
            self._reasoning_mode = "cautious"
            self._cautious = self._solve_single()
        return self._cautious

    def compute_facets(self) -> set[Symbol] | None:
        """
        Compute the facets of the program.
        """
        if self._facets is None:
            brave = self.compute_brave_consequences()
            cautious = self.compute_cautious_consequences()
            if brave is not None and cautious is not None:
                self._facets = brave - cautious
            else:
                self._facets = None
        return self._facets

    def _get_all_atoms(self) -> set[Symbol]:
        """
        Get the set of all symbols.

        This function should be used instead of directly accessing self._atoms.
        """
        if self._atoms is None:
            # ground to obtain possible new atoms
            self._ground()

            self._atoms = set()
            for atom in self._control.symbolic_atoms:
                # filter out atoms that are external
                if not atom.is_external:
                    self._atoms.add(atom.symbol)

        return self._atoms

    def _get_partial_interpretation(self, models: list[set[Symbol]], diverse: bool = True) -> dict[Symbol, bool | None]:
        """
        Get a partial interpretation diverse/similar to the list of models.
        """
        partial_int: dict[Symbol, bool | None] = {}
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
                partial_int[atom] = not diverse
            elif val < 0:
                partial_int[atom] = diverse
            else:
                partial_int[atom] = None

        return partial_int

    def _get_heuristics(self, partial_int: dict[Symbol, bool | None], external: Symbol) -> str:
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
                case None:
                    pass

        return prog

    def _get_model_from_partial_int(self, partial_int: dict[Symbol, bool | None]) -> set[Symbol] | None:
        """
        Get a model similar to the partial interpretation.
        """
        # get a new external/program part
        external = self._get_new_auxiliary_symbol()

        heuristics_prog = self._get_heuristics(partial_int, external)

        self._add_and_activate(heuristics_prog, external)

        model = self._solve_single()

        # deactivate the heuristics again
        self._control.release_external(external)

        return model

    def _extend_solution_set(self, models: list[set[Symbol]], diverse: bool = True) -> set[Symbol] | None:
        """
        Extend the current solution set by a diverse/similar model.
        """
        partial_int = self._get_partial_interpretation(models, diverse)
        new_model = self._get_model_from_partial_int(partial_int)
        return new_model

    def _model_to_constraint(self, model: set[Symbol], external: Symbol) -> str:
        """
        Turn a model into a constraint which forbids this model.
        """
        # list of literals for the constraint
        literals = []
        for atom in self._get_all_atoms():
            if atom in model:
                literals.append(f"{atom}")
            else:
                literals.append(f"not {atom}")

        # constraint with the list of literals and the external
        constraint = f":- {external}"
        for lit in literals:
            constraint += ", " + lit
        constraint += "."

        # external statement and the constraint
        prg = f"#external {external}.\n" + constraint

        return prg

    def _get_new_auxiliary_symbol(self) -> Symbol:
        """
        Get a new auxiliary symbol to use as a program part name and external.
        """
        new_symbol = self._as_symbol(self._get_new_program_name())
        self._auxiliary_atoms.add(new_symbol)
        return new_symbol

    def _add_and_activate(self, prg: str, external: Symbol) -> None:
        """
        Add prg to control using external as the program part name. The external is set to True to activate the program.
        """
        name = str(external)
        self._control.add(name, [], prg)
        self._ground([(name, [])])
        self._control.assign_external(external, True)

    def _forbid_model(self, model: set[Symbol]) -> Symbol:
        """
        Add a constraint to forbid the model to the program.

        Returns:
            Symbol: the symbol of the external to deactivate the constraint.
        """
        external = self._get_new_auxiliary_symbol()
        constraint = self._model_to_constraint(model, external)
        self._add_and_activate(constraint, external)
        return external

    def _compute_diverse_similar_models(
        self, num_models: int, initial_models: list[set[Symbol]] | None, diverse: bool = True
    ) -> list[set[Symbol]]:
        """
        Helper function to compute diverse/similar models.
        """
        models: list[set[Symbol]] = []
        externals = []

        initial_models = initial_models or []
        # avoid repetition of any initial models
        for model in initial_models:
            external = self._forbid_model(model)
            externals.append(external)

        for i in range(num_models):
            new_model = self._extend_solution_set(initial_models + models, diverse)

            if new_model is None:
                break

            models.append(new_model)

            # for all but the last model add a constraint to the program to avoid repeating this model
            if i < num_models - 1:
                external = self._forbid_model(new_model)
                externals.append(external)

        # deactivate all added constraints
        for external in externals:
            self._control.release_external(external)

        return models

    def compute_diverse_models(
        self, num_models: int = 1, initial_models: list[set[Symbol]] | None = None
    ) -> list[set[Symbol]]:
        """
        Compute num_models many diverse models.
        """
        self._reasoning_mode = "diverse"
        return self._compute_diverse_similar_models(num_models, initial_models, diverse=True)

    def compute_similar_models(
        self, num_models: int = 1, initial_models: list[set[Symbol]] | None = None
    ) -> list[set[Symbol]]:
        """
        Compute num_models many similar models.
        """
        self._reasoning_mode = "similar"
        return self._compute_diverse_similar_models(num_models, initial_models, diverse=False)

    def browse_diverse_models(self) -> set[Symbol]:
        """
        Compute diverse models iteratively.
        """

    def browse_similar_models(self) -> set[Symbol]:
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

    def get_assumptions(self) -> set[tuple[Symbol, bool]]:
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

    def get_externals(self) -> dict[Symbol, bool | None]:
        """
        Get the current values of the externals.
        """
        return self._externals

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

        # mark rule as non-ground
        self._non_ground_rules.add(rule)

        # get external/program part name for adding the rule
        external = self._get_new_auxiliary_symbol()
        # associate the rule to the external
        self._rule_map[rule] = external

        # add the activation external to the rule
        if not permanent:
            self._rules[rule] = True
            rule = self._add_external_to_rule(rule, external)

        # add the rule as a new program part
        self._control.add(str(external), [], rule)

    def add_rule(self, rule: str, permanent: bool = False) -> None:
        """
        Add a rule to the logic program.
        """
        # TODO: add error handling for redefinition error
        self._outdate_atoms()
        self._add_rule(rule, permanent)

    def _set_value_of_rule(self, rule: str, value: bool) -> None:
        """
        Set the activation external of a rule to the specified value.
        """
        self._outdate_solution_space()
        self._rules[rule] = value

        # only change the value of the activation external if the rule is ground
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

    def get_rules(self) -> dict[str, bool]:
        """
        Get all added rules and their activation status.
        """
        return self._rules

    def add_constraint(self, constraint: str, permanent: bool = False) -> None:
        """
        Add a constraint to the logic program.
        """
        self._add_rule(constraint, permanent)
