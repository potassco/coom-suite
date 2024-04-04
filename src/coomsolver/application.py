"""
Clingo application class extended to solve COOM configuration problems
"""

import textwrap
from typing import Callable, List, Optional, Sequence, Tuple

from clingo import Control, Model, Symbol
from clingo.application import Application, ApplicationOptions  # , Flag

from .utils import get_encoding

# from .utils.logging import get_logger


# log = get_logger("main")


def _unpack_path(p: Symbol, l: List[Tuple[str, str]]) -> List[Tuple[str, str]]:  # nocoverage
    """
    Recursively unpacks a nested path expression into a list of tuples.
    """
    if str(p) != "()":
        t = (p.arguments[0].name, str(p.arguments[1].arguments[1].number))
        l.insert(0, t)
        _unpack_path(p.arguments[1].arguments[0], l)
    return l


def _format_sym(s: Symbol) -> str:  # nocoverage
    """
    Formats output symbols.
    """
    if s.name == "instance":
        path = _unpack_path(s.arguments[0], [])
        return ".".join([f"{p[0]}[{p[1]}]" for p in path])
    if s.name == "val":
        path = _unpack_path(s.arguments[0], [])
        path_joined = ".".join([f"{p[0]}[{p[1]}]" for p in path])
        return f"{path_joined} = {str(s.arguments[1])}"
    raise ValueError("Unrecognized predicate.")


def _sym_to_prg(symbols: Sequence[Symbol], output: Optional[str] = "asp") -> str:  # nocoverage
    """
    Turns symbols into a program.
    """
    if output == "asp":
        output_list = [f"{str(s)}" for s in sorted(symbols)]
    elif output == "coom":
        output_list = [f"{_format_sym(s)}" for s in sorted(symbols)][1:]  # First element is root = empty string
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

    # def on_model(self, model: Model) -> None:
    #     """
    #     Function called after finding each model.
    #     Args:
    #         model (Model): clingo Model
    #     """
    #     self._dl_theory.on_model(model)
    #     model.extend(
    #         [
    #             Function("start", [key.arguments[0], Number(val)])
    #             for key, val in self._dl_theory.assignment(model.thread_id)
    #         ]
    #     )
    #     log.debug("------- Full model -----")
    #     log.debug(
    #         "\n".join(
    #             [str(s) for s in model.symbols(atoms=True, shown=True, theory=True)]
    #         )
    #     )

    def print_model(self, model: Model, printer: Callable[[], None]) -> None:  # nocoverage
        """
        Print a model on the console.
        """
        print(_sym_to_prg(model.symbols(shown=True), self._output))

    def main(self, control: Control, files: Sequence[str]) -> None:
        """
        Main function ran on call.
        """

        self._input_files = list(files)
        encoding = get_encoding(f"{self._solver}-{self._profile}.lp")
        self._input_files.extend([encoding])

        for f in self._input_files:
            control.load(f)

        control.ground()
        control.solve()
