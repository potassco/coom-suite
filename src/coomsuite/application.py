"""
Clingo application class extended to solve COOM configuration problems
"""

import textwrap
from typing import Callable, List, Optional, Sequence

from clingcon import ClingconTheory
from clingo import Control, Model, Symbol
from clingo.application import Application, ApplicationOptions, Flag
from clingo.ast import Location, Position, ProgramBuilder, Rule, parse_files
from clingo.script import enable_python
from clingo.solving import SolveResult
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

    _solver: str
    _output: str
    _show: bool
    _istest: bool
    _log_level: str
    config: FclingoConfig
    _propagator: ClingconTheory
    program_name: str = "COOM solver"
    version: str = "0.1"

    def __init__(
        self,
        log_level: str = "",
        solver: str = "",
        output: str = "",
        show: bool = False,
        istest: bool = False,
    ):
        """
        Create application.
        """
        self._solver = "clingo" if solver == "" else solver
        self._output = "asp" if output == "" else output
        self._show = show
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

    def on_model(self, model: Model) -> None:  # nocoverage
        """
        Function called after finding each model.
        Args:
            model (Model): clingo Model
        """
        if self._solver == "fclingo":
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

        if self._solver == "clingo":
            output_symbols = model.symbols(shown=True)
        elif self._solver == "fclingo":
            output_symbols = [
                atom
                for atom in model.symbols(shown=True)
                if not (atom.name == self.config.defined and len(atom.arguments) == 1)
            ]
            output_symbols.extend(_get_valuation(model))

        print(_sym_to_prg(output_symbols, self._output))

    def preprocess(self, files: List[str]) -> List[str]:
        """
        Preprocesses COOM ASP facts into a "grounded" configuration fact format
        """
        # pylint: disable=not-context-manager
        input_files = files
        preprocess = get_encoding("preprocess.lp")
        input_files.append(preprocess)
        enable_python()

        pre_ctl = Control(message_limit=0)
        for f in input_files:
            pre_ctl.load(f)
        if self._solver == "clingo":
            pre_ctl.add("base", [], "discrete.")
        pre_ctl.ground()
        with pre_ctl.solve(yield_=True) as handle:
            facts = [str(s) + "." for s in handle.model().symbols(shown=True)]

        return facts

    def check_user_input(self, facts: list[str]) -> SolveResult:
        """
        Checks if the user input is valid and returns a clingo.SolveResult
        """
        user_input_ctl = Control(message_limit=0)
        user_input_ctl.load(get_encoding("user-check.lp"))
        user_input_ctl.add("".join(facts))
        user_input_ctl.ground()
        return user_input_ctl.solve()

    def main(self, control: Control, files: Sequence[str]) -> None:
        """
        Main function ran on call.
        """
        processed_facts = self.preprocess(list(files))
        if self._show:
            print("\n".join(processed_facts))  # nocoverage
        else:
            if self.check_user_input(processed_facts).unsatisfiable:
                raise ValueError("User input not valid.")

            encoding = get_encoding(f"encoding-base-{self._solver}.lp")
            facts = "".join(processed_facts)
            if self._solver == "clingo":

                control.load(encoding)
                control.add(facts)

                control.ground()
                control.solve()
            elif self._solver == "fclingo":
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
