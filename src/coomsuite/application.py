"""
Clingo application class extended to solve COOM configuration problems
"""

import textwrap
from typing import Any, Callable, Dict, List, Optional, Sequence

from clingcon import ClingconTheory
from clingo import Control, Model, Symbol
from clingo.application import Application, ApplicationOptions, Flag
from clingo.ast import Location, Position, ProgramBuilder, Rule, parse_files
from clingo.script import enable_python
from clingo.symbol import Function, SymbolType
from fclingo.__main__ import CSP, DEF, MAX_INT, MIN_INT
from fclingo.__main__ import AppConfig as FclingoConfig
from fclingo.__main__ import Statistic
from fclingo.parsing import THEORY, HeadBodyTransformer
from fclingo.translator import AUX, Translator

from .utils import format_sym_coom, get_encoding
from .utils.logging import get_logger

# mypy: allow-untyped-calls
log = get_logger("main")


def _get_valuation(model: Model) -> List[Symbol]:
    return [
        Function("value", assignment.arguments)
        for assignment in model.symbols(theory=True)
        if assignment.name == CSP
        and len(assignment.arguments) == 2
        and model.contains(
            Function(DEF, [Function(str(assignment.arguments[0]), [], True)])
        )  # Temporary fix until fclingo fixes String behavior
        and not (assignment.arguments[0].type is SymbolType.Function and assignment.arguments[0].name == AUX)
    ]


def _sym_to_prg(symbols: Sequence[Symbol], output: Optional[str] = "asp") -> str:  # nocoverage
    """
    Turns symbols into a program.
    """
    sorted_symbols = sorted(symbols)
    if output == "asp":
        output_list = [f"{str(s)}" for s in sorted_symbols]
    elif output == "coom":
        output_list = [f"{format_sym_coom(s)}" for s in sorted_symbols]
    else:
        raise ValueError(f"Unrecognized output format: {output}")
    return "\n".join(output_list)


class COOMApp(Application):
    """
    Application class extending clingo.
    """

    _options: Dict[str, Any]
    # _solver: str
    # _output: str
    # _show_facts: bool
    _istest: bool
    _log_level: str
    config: FclingoConfig
    _propagator: ClingconTheory
    program_name: str = "COOM solver"
    version: str = "0.1"

    def __init__(
        self,
        log_level: str = "",
        options: Optional[Dict[str, Any]] = None,
        istest: bool = False,
    ):
        """
        Create application.
        """
        self._options = (
            {"solver": "clingo", "output_format": "asp", "show_facts": False, "preprocess": True}
            if options is None
            else options
        )
        self._istest = istest
        self._log_level = "WARNING" if log_level == "" else log_level
        self.config = FclingoConfig(MIN_INT, MAX_INT, Flag(False), Flag(False), DEF)
        self._propagator = ClingconTheory()

    def parse_log_level(self, log_level: str) -> bool:  # nocoverage
        """
        Parse log.
        """
        if log_level is not None:
            self._log_level = log_level.upper()
            return self._log_level in ["INFO", "WARNING", "DEBUG", "ERROR"]

        return True

    def register_options(self, options: ApplicationOptions) -> None:  # nocoverage
        """
        Add custom options.
        """
        group = "Clingo.COOM"
        options.add(
            group,
            "log",
            textwrap.dedent(
                """\
                Provide logging level.
                                            <level> ={debug|info|error|warning}
                                            (default: warning)"""
            ),
            self.parse_log_level,
            argument="<level>",
        )
        # options.add_flag(
        #     group, "view", "Visualize the first solution using clinguin", self._view
        # )

    def _parse_user_input_unsat(self, unsat: Symbol) -> str:
        """
        Parses the unsat/2 predicates of the user input check
        """
        unsat_type = unsat.arguments[0].string
        info = unsat.arguments[1]

        if unsat_type == "not exists":
            variable = info.string
            msg = f"Variable {variable} is not valid."
        elif unsat_type == "not part":
            variable = info.string
            msg = f"Variable {variable} cannot be added."
        elif unsat_type == "not attribute":
            variable = info.string
            msg = f"No value can be set for variable {variable}."
        elif unsat_type == "outside domain":
            variable = info.arguments[0].string
            if str(info.arguments[1].type) == "SymbolType.Number":
                value = str(info.arguments[1].number)
            else:
                value = info.arguments[1].string
            msg = f"Value '{value}' is not in domain of variable {variable}."
        else:
            raise ValueError(f"Unknown unsat type: {unsat_type}")  # nocoverage
        return msg

    def on_model(self, model: Model) -> None:  # nocoverage
        """
        Function called after finding each model.
        Args:
            model (Model): clingo Model
        """
        if self._options["solver"] == "fclingo":
            self._propagator.on_model(model)

            if self._istest:
                # this slows down solving considerably but makes tests for clingo and fclingo uniform
                # better way?
                model.extend(_get_valuation(model))

        # log.debug("------- Full model -----") # disabled because makes solving much slower
        # log.debug("\n".join([str(s) for s in model.symbols(atoms=True, shown=True, theory=True)]))

    def print_model(self, model: Model, printer: Callable[[], None]) -> None:  # nocoverage
        """
        Print a model on the console.
        """

        if self._options["solver"] == "clingo":
            output_symbols = model.symbols(shown=True)
        elif self._options["solver"] == "fclingo":
            output_symbols = [
                atom
                for atom in model.symbols(shown=True)
                if not (atom.name == self.config.defined and len(atom.arguments) == 1)
            ]
            output_symbols.extend(_get_valuation(model))

        print(_sym_to_prg(output_symbols, self._options["output_format"]))

    def preprocess(self, files: List[str]) -> List[str]:
        """
        Preprocesses COOM ASP facts into a "grounded" configuration fact format
        """
        # pylint: disable=not-context-manager
        input_files = files
        pre_ctl = Control(message_limit=0)
        for f in input_files:
            pre_ctl.load(f)

        if self._options["preprocess"] or self._options["show_facts"]:
            enable_python()
            pre_ctl.load(get_encoding("preprocess.lp"))
            if self._options["solver"] == "clingo":
                pre_ctl.add("base", [], "discrete.")  # nocoverage

        pre_ctl.ground()
        with pre_ctl.solve(yield_=True) as handle:
            facts = [str(s) + "." for s in handle.model().symbols(shown=True)]

        return facts

    def check_user_input(self, facts: str) -> list[str]:
        """
        Checks if the user input is valid and returns a clingo.SolveResult
        """
        user_input_ctl = Control(message_limit=0)
        user_input_ctl.load(get_encoding("user-check.lp"))
        user_input_ctl.add(facts)
        user_input_ctl.ground()
        with user_input_ctl.solve(yield_=True) as handle:
            unsat = [self._parse_user_input_unsat(s) for s in handle.model().symbols(shown=True)]
        return unsat

    def main(self, control: Control, files: Sequence[str]) -> None:
        """
        Main function ran on call.
        """
        processed_facts = self.preprocess(list(files))

        if self._options["show_facts"]:
            print("\n".join(processed_facts))  # nocoverage
        else:
            facts = "".join(processed_facts)

            if self._options["solver"] == "preprocess":
                control.add(facts)
                control.ground()
                control.solve()
            else:
                user_input_check = self.check_user_input(facts)
                if user_input_check != []:
                    error_msg = "User input not valid.\n" + "\n".join(user_input_check)
                    raise ValueError(error_msg)

                encoding = get_encoding(f"encoding-base-{self._options['solver']}.lp")

                if self._options["solver"] == "clingo":
                    control.load(encoding)
                    control.add(facts)

                    control.ground()
                    control.solve()

                elif self._options["solver"] == "fclingo":
                    self._propagator.register(control)
                    self._propagator.configure("max-int", str(self.config.max_int))
                    self._propagator.configure("min-int", str(self.config.min_int))

                    control.add("base", [], facts)
                    control.add("base", [], THEORY)

                    with ProgramBuilder(control) as bld:
                        hbt = HeadBodyTransformer()

                        parse_files([encoding], lambda ast: bld.add(hbt.visit(ast)))
                        pos = Position("<string>", 1, 1)
                        loc = Location(pos, pos)
                        for rule in hbt.rules_to_add:
                            bld.add(Rule(loc, rule[0], rule[1]))  # nocoverage # Not sure when this is needed

                    control.ground([("base", [])])
                    translator = Translator(control, self.config, Statistic())
                    translator.translate(control.theory_atoms)

                    self._propagator.prepare(control)
                    control.solve(on_model=self.on_model, on_statistics=self._propagator.on_statistics)
