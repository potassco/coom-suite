"""
Library for navigating solution spaces
"""

from typing import Dict, List, Optional, Set, Tuple

from clingo.control import Control
from clingo.symbol import Symbol, parse_term

Model = Set[Symbol]
ProgPart = Tuple[str, List[str]]


class Navigator:
    def __init__(self, control: Optional[Control] = None, grounded: Optional[bool] = None):
        """
        Args:
            control (Optional[Control]): optionally pass a control object to use
            grounded_base (Optional[bool]): indicate if the passed control object was already grounded
        """
        if control:
            self._control = control
            self._grounded = True if grounded else False
        else:
            self._control = Control()
            self._grounded = False

        self._reasoning_mode = "auto"

        self._brave = None
        self._cautious = None
        self._facets = None

        self._solve_handle = None
        self._model_iterator = None

        self._assumptions: Set[Tuple[Symbol, bool]] = set()
        self._externals: Dict[Symbol, Optional[bool]] = {}

        self._program_name = "add"
        self._program_counter = 0

    def load(self, file_path: str) -> None:
        self._clear_consequences()
        self._grounded = False
        self._control.load(file_path)

    def _clear_consequences(self) -> None:
        # needs to be called whenever solution space is changed
        self._brave = None
        self._cautious = None
        self._facets = None

    def _ground(self, parts: Optional[List[ProgPart]] = None) -> None:
        if not self._grounded:
            if ("base", []) not in parts:
                parts.append(("base", []))
            self._grounded = True

        if parts:
            self._control.ground(parts)

    def _update_configuration(self, num_models: int = 1) -> None:
        match self._reasoning_mode:
            case "auto" | "browse":
                self._control.configuration.solve.enum_mode = "auto"
            case "brave":
                self._control.configuration.solve.enum_mode = "brave"
            case "cautious":
                self._control.configuration.solve.enum_mode = "cautious"

        self._control.configuration.solve.models = num_models

    def _solve(self, num_models: int = 1) -> Model | List[Model]:
        self._update_configuration(num_models)

        self._ground()

        result = None
        browsing = self._reasoning_mode == "browse"
        if not browsing or self._model_iterator is None:
            handle = self._control.solve(assumptions=self._assumptions, yield_=True)

            if browsing:
                self._solve_handle = handle
                self._model_iterator = iter(handle)
            else:
                for m in handle:
                    model = set(m.symbols(shown=True))
                    if self._reasoning_mode == "auto":
                        if result is None:
                            result = [model]
                        else:
                            result.append(model)
                    else:
                        result = model
                handle.cancel()

        if browsing:
            try:
                model = next(self._model_iterator)
                result = set(model.symbols(shown=True))
            except StopIteration:
                self._solve_handle.cancel()
                self._solve_handle = None
                self._model_iterator = None

        return result

    def enable_optimization(self) -> None:
        self._clear_consequences()
        self._control.configuration.opt_mode = "optN"

    def disable_optimization(self) -> None:
        self._clear_consequences()
        self._control.configuration.opt_mode = "ignore"

    def compute_models(self, num_models: int = 1) -> List[Model]:
        return self._solve(num_models)

    def browse_models(self) -> Model:
        self._reasoning_mode = "browse"
        model = self._solve(0)
        self._reasoning_mode = "auto"
        return model

    def compute_brave_consequences(self) -> Model:
        if self._brave is None:
            self._reasoning_mode = "brave"
            self._brave = set(self._solve(0))
            self._reasoning_mode = "auto"
        return self._brave

    def compute_cautious_consequences(self) -> Model:
        if self._cautious is None:
            self._reasoning_mode = "cautious"
            self._cautious = set(self._solve(0))
            self._reasoning_mode = "auto"
        return self._cautious

    def compute_facets(self) -> Model:
        if self._facets is None:
            brave = self.compute_brave_consequences()
            cautious = self.compute_cautious_consequences()
            self._facets = brave - cautious
        return self._facets

    def compute_diverse_models(self, num_models: int = 1) -> List[Model]:
        pass

    def compute_similar_models(self, num_models: int = 1) -> List[Model]:
        pass

    def browse_diverse_models(self) -> Model:
        pass

    def browse_similar_models(self) -> Model:
        pass

    def _as_symbol(self, symbol: str | Symbol) -> Symbol:
        if isinstance(symbol, str):
            symbol = parse_term(symbol)

        return symbol

    def add_assumption(self, symbol: str | Symbol, value: bool) -> None:
        symbol = self._as_symbol(symbol)
        self._clear_consequences()
        self._assumptions.add((symbol, value))

    def remove_assumption(self, symbol: str | Symbol, value: bool) -> None:
        symbol = self._as_symbol(symbol)
        self._clear_consequences()
        self._assumptions.discard((symbol, value))

    def clear_assumptions(self) -> None:
        self._clear_consequences()
        self._assumptions = set()

    def get_assumptions(self) -> Set[Tuple[Symbol, bool]]:
        return self._assumptions

    def set_external(self, symbol: str | Symbol, value: bool | None) -> None:
        symbol = self._as_symbol(symbol)
        self._clear_consequences()
        self._externals[symbol] = value
        if value is not None:
            self._control.assign_external(symbol, value)
        else:
            self._control.release_external(symbol)

    def clear_externals(self) -> None:
        self._clear_consequences()
        for symbol in self._externals:
            self.set_external(symbol, None)

    def get_externals(self) -> Dict[Symbol, Optional[bool]]:
        return self._externals

    # TODO: add a function to get all the externals from the program?

    def _get_new_program_name(self) -> str:
        name = self._program_name + str(self._program_counter)
        self._program_counter += 1
        return name

    def add_rule(self, rule: str) -> None:
        self._clear_consequences()
        # TODO: check that head is a new atom to avoid redefinition error
        name = self._get_new_program_name()
        self._control.add(name, [], rule)
        self._ground([(name, [])])

    def add_constraint(self, constraint: str) -> None:
        self._clear_consequences()
        name = self._get_new_program_name()
        self._control.add(name, [], constraint)
        self._ground([(name, [])])
