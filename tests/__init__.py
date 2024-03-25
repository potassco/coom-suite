"""
Basic functions to run tests.
"""

import os
import tempfile
from typing import Callable, List, Optional, Sequence

from antlr4 import InputStream
from clingo import Application, Control
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


def compose(on_app: Callable, on_test: Callable) -> Callable:
    """
    Composes two functions
    Args:
        on_app (Callable): Function from the application class
        on_test (Callable): Function for the test
    """

    def f(*args):
        """Composed function"""
        if on_app is not None:
            on_app(*args)
        on_test(*args)

    return f


def get_solver(program: Optional[str] = "", files=None, ctl_args=None, **kwargs) -> Solver:
    """
    Gets the test solver for the tests
    Args:
        program (Optional[str], optional): A clingo program. Defaults to "".
        files (Optional[str], optional): List of files saved in examples/tests
    Returns:
        _type_: The solver wrapping the application class
    """
    coom_app = COOMApp("coom", **kwargs)
    files = [] if files is None else files
    file_paths = [os.path.join("examples", "tests", f) for f in files]
    return AppSolver(application=coom_app, files=file_paths, program=program, arguments=ctl_args)


class MockControl:
    """
    Mocks a clingo control object to call the Application class
    """

    def __init__(
        self,
        test: Test,
        arguments: Optional[Sequence[str]] = None,
    ):
        arguments = [] if arguments is None else arguments
        self._test = test
        self._ctl = Control(arguments=arguments)

    def __getattr__(self, attr):
        try:
            return self._ctl.__getattribute__(attr)
        except AttributeError:
            return self.__get_global_handler(attr)

    def solve(
        self,
        on_model=None,
        on_unsat=None,
        on_core=None,
        on_statistics=None,
        on_finish=None,
    ):
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
        """Solves with clintest"""
        ctl = MockControl(test, self.__arguments)
        self.__application.main(control=ctl, files=self.__files)  # type: ignore
