"""
Clingo application class extended to solve COOM configuration problems
"""

import textwrap
from typing import Callable, List, Optional, Sequence

from clingcon import ClingconTheory
from clingo import Control, Model, Symbol
from clingo.application import Application, ApplicationOptions, Flag
from clingo.ast import Location, Position, ProgramBuilder, Rule, parse_files
from clingo.symbol import Function
from fclingo.__main__ import CSP, DEF, MAX_INT, MIN_INT
from fclingo.__main__ import AppConfig as FclingoConfig
from fclingo.parsing import THEORY, HeadBodyTransformer
from fclingo.translator import AUX, Translator

from .utils import format_sym_coom, get_encoding
from .utils.logging import get_logger

# mypy: allow-untyped-calls
log = get_logger("main")


def _sym_to_prg(symbols: Sequence[Symbol], output: Optional[str] = "asp") -> str:  # nocoverage
    """
    Turns symbols into a program.
    """
    sorted_symbols = sorted(symbols)
    if output == "asp":
        output_list = [f"{str(s)}" for s in sorted_symbols]
    elif output == "coom":
        output_list = [f"{format_sym_coom(s)}" for s in sorted_symbols][1:]  # First element is root = empty string
    return "\n".join(output_list)


class COOMApp(Application):
    """
    Application class extending clingo.
    """

    _input_files: List[str]
    _solver: str
    _profile: str
    _output: str
    _log_level: str
    config: FclingoConfig
    _propagator: ClingconTheory
    program_name: str = "COOM solver"
    version: str = "0.1"

    def __init__(self, log_level: str = "", solver: str = "", profile: str = "", output: str = ""):
        """
        Create application.
        """
        self._input_files = []
        self._solver = "clingo" if solver == "" else solver
        self._profile = "travel" if profile == "" else profile
        self._output = "asp" if output == "" else output
        self._log_level = "WARNING" if log_level == "" else log_level
        self.config = FclingoConfig(
            MIN_INT, MAX_INT, Flag(False), Flag(False), DEF
        )  #  if solver == "fclingo" else None
        self._propagator = ClingconTheory()  # if solver == "fclingo" else None

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

            log.debug("------- Full model -----")
            log.debug("\n".join([str(s) for s in model.symbols(atoms=True, shown=True, theory=True)]))

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
            valuation = [
                Function("val", assignment.arguments)
                for assignment in model.symbols(theory=True)
                if assignment.name == CSP
                and len(assignment.arguments) == 2
                and model.contains(Function(self.config.defined, [assignment.arguments[0]]))
                and not assignment.arguments[0].name == AUX
            ]
            output_symbols.extend(valuation)

        print(_sym_to_prg(output_symbols, self._output))

    def main(self, control: Control, files: Sequence[str]) -> None:
        """
        Main function ran on call.
        """

        self._input_files = list(files)
        encoding = get_encoding(f"{self._solver}-{self._profile}.lp")
        self._input_files.extend([encoding])

        if self._solver == "clingo":
            for f in self._input_files:
                control.load(f)

            control.ground()
            control.solve()
        elif self._solver == "fclingo":  # nocoverage
            self._propagator.register(control)
            self._propagator.configure("max-int", str(self.config.max_int))
            self._propagator.configure("min-int", str(self.config.min_int))

            with ProgramBuilder(control) as bld:
                hbt = HeadBodyTransformer()

                parse_files(self._input_files, lambda ast: bld.add(hbt.visit(ast)))
                pos = Position("<string>", 1, 1)
                loc = Location(pos, pos)
                for rule in hbt.rules_to_add:
                    bld.add(Rule(loc, rule[0], rule[1]))

            control.add("base", [], THEORY)
            control.ground([("base", [])])
            translator = Translator(control, self.config)
            translator.translate(control.theory_atoms)

            self._propagator.prepare(control)
            control.solve(on_model=self.on_model, on_statistics=self._propagator.on_statistics)
