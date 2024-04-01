"""
Clingo application class extended to solve COOM configuration problems
"""

import textwrap
from typing import List, Sequence

# from clingo import Function, Model, Number, Symbol
from clingo import Control
from clingo.application import Application, ApplicationOptions  # , Flag

from .utils import get_encoding

# from .utils.logging import get_logger


# log = get_logger("main")


# def _sym_to_prg(symbols: Sequence[Symbol]):  # nocoverage
#     """
#     Turns symbols into a program
#     """
#     return "\n".join([f"{str(s)}." for s in symbols])


class COOMApp(Application):
    """
    Application class extending clingo
    """

    _log_level: str
    _input_files: List[str]
    _solver: str
    _profile: str
    program_name: str = "COOM solver"
    version: str = "0.1"

    def __init__(self, log_level: str = "", solver: str = "", profile: str = ""):
        """
        Create application
        """
        self._input_files = []
        self._solver = "clingo" if solver == "" else solver
        self._profile = "travel" if profile == "" else profile
        self._log_level = "WARNING" if log_level == "" else log_level

    def parse_log_level(self, log_level: str) -> bool:  # nocoverage
        """
        Parse log
        """
        if log_level is not None:
            self._log_level = log_level.upper()
            return self._log_level in ["INFO", "WARNING", "DEBUG", "ERROR"]

        return True

    def register_options(self, options: ApplicationOptions) -> None:  # nocoverage
        """
        Add custom options
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
    #     Function called after finding each model
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

    # def print_model(self, model: Model, printer) -> None:  # nocoverage
    #     """
    #     Print a model on the console
    #     """
    #     solution = _sym_to_prg(model.symbols(shown=True, theory=True))
    #     if self._option == "check" and len(solution) > 0:
    #         sys.stdout.write("\033[0;31m")
    #     else:
    #         sys.stdout.write("\033[0;32m")
    #     sys.stdout.write(solution)
    #     if self._option == "check" and len(solution) == 0:
    #         sys.stdout.write("All checks passed!")
    #     sys.stdout.write("\033[0m\n")
    #     if self._view:
    #         solution = _sym_to_prg(model.symbols(shown=True, atoms=True, theory=True))
    #         add_atexit_clinguin(solution=solution, scale=self._scale)

    def main(self, control: Control, files: Sequence[str]) -> None:
        """
        Main function ran on call
        """

        self._input_files = list(files)
        encoding = get_encoding(f"{self._solver}-{self._profile}.lp")
        self._input_files.extend([encoding])

        for f in self._input_files:
            control.load(f)

        control.ground()
        control.solve()
