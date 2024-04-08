"""
Basic functions to run tests.
"""

import tempfile
from os.path import join
from typing import Callable, List, Optional, Sequence, Set, Union

from antlr4 import InputStream
from clingo import Application, Control, Symbol
from clingo.solving import Model
from clintest.assertion import Contains, SupersetOf
from clintest.solver import Solver
from clintest.test import Test

from coomsolver.application import COOMApp
from coomsolver.utils import run_antlr4_visitor


def parse_coom(coom_input: str) -> List[str]:
    """
    Helper function for testing the COOM to ASP parser.
    """
    input_stream = InputStream(coom_input)
    return run_antlr4_visitor(input_stream)


def compose(on_app: Callable, on_test: Callable) -> Callable:  # type: ignore
    """
    Composes two functions
    Args:
        on_app (Callable): Function from the application class
        on_test (Callable): Function for the test
    """

    def f(*args):  # type: ignore
        """Composed function"""
        if on_app is not None:
            on_app(*args)
        on_test(*args)

    return f


class SupersetOfTheory(SupersetOf):
    """
    A clintest SupersetOf assertion that can also check theory atoms.

    Args:
        symbol (Symbol): A clingo symbol.
        check_theory (bool): Whether to include theory atoms in the check
    """

    def __init__(self, symbols: Set[Union[Symbol, str]], check_theory: bool = False) -> None:
        super().__init__(symbols)
        self.__symbols = self._SupersetOf__symbols  # type: ignore # pylint: disable=no-member
        self.__check_theory = check_theory

    def holds_for(self, model: Model) -> bool:
        if self.__check_theory:
            return set(model.symbols(shown=True, theory=True)).issuperset(self.__symbols)
        return super().holds_for(model)


class ContainsTheory(Contains):
    """
    A clintest Contains assertion that can also check theory atoms.

    Args:
        symbol (Symbol): A clingo symbol.
        check_theory (bool): Whether to include theory atoms in the check
    """

    def __init__(self, symbol: Union[Symbol, str], check_theory: bool = False) -> None:
        super().__init__(symbol)
        self.__symbol = self._Contains__symbol  # type: ignore # pylint: disable=no-member
        self.__check_theory = check_theory

    def holds_for(self, model: Model) -> bool:
        if self.__check_theory:
            return self.__symbol in model.symbols(shown=True, theory=True)
        return super().holds_for(model)


def run_test(
    test: Test,
    files: Optional[List[str]] = None,
    program: Optional[str] = None,
    ctl_args: Optional[List[str]] = None,
    **kwargs: str,
) -> None:
    """Creates a solver and runs a clintest test.

    Args:
        test (clintest.Test): The clintest test
        files (Optional[List[str]], optional): List of files saved in examples/tests
        program (Optional[str], optional): A clingo program. Defaults to ""
        ctl_args (Optional[List[str]], optional): List of arguments for clingo.Control. Defaults to [].
    """
    coom_app = COOMApp("coom", **kwargs)
    file_paths = [join("examples", "tests", f) for f in files] if files else None
    ctl_args = [] if ctl_args is None else ctl_args
    solver = AppSolver(application=coom_app, files=file_paths, program=program, arguments=["0"])

    solver.solve(test)
    test.assert_()


class MockControl:
    """
    Mocks a clingo control object to call the Application class
    """

    def __init__(
        self,
        test: Test,
        arguments: Optional[Sequence[str]] = None,
    ) -> None:
        arguments = [] if arguments is None else arguments
        self._test = test
        self._ctl = Control(arguments=arguments)

    def __getattr__(self, attr):  # type: ignore
        try:
            return self._ctl.__getattribute__(attr)
        except AttributeError:
            return self.__get_global_handler(attr)

    def solve(  # type: ignore
        self,
        on_model=None,
        on_unsat=None,
        on_core=None,
        on_statistics=None,
        on_finish=None,
    ) -> None:
        """
        Replaced the solve of the control by calling first internal callbacks and then
        the ones from the test
        """
        if not self._test.outcome().is_certain():
            self._ctl.solve(
                on_model=compose(on_model, self._test.on_model),
                on_unsat=compose(on_unsat, self._test.on_unsat),
                on_core=compose(on_core, self._test.on_core),
                on_statistics=compose(on_statistics, self._test.on_statistics),
                on_finish=compose(on_finish, self._test.on_finish),
            )


class AppSolver(Solver):
    """
    A clintest solver wrapping an application class
    """

    def __init__(
        self,
        application: Application,
        files: Optional[List[str]] = None,
        program: Optional[str] = None,
        arguments: Optional[List[str]] = None,
    ) -> None:
        self.__application = application
        self.__arguments = [] if arguments is None else arguments
        self.__program = "" if program is None else program
        self.__files = [] if files is None else files
        if self.__program:
            with tempfile.NamedTemporaryFile(mode="w", delete=False) as tmp:
                tmp_name = tmp.name
                tmp.write(self.__program)
            self.__files.append(tmp_name)

    def solve(self, test: Test) -> None:
        """Solves with clintest."""
        ctl = MockControl(test, self.__arguments)
        self.__application.main(control=ctl, files=self.__files)  # type: ignore
