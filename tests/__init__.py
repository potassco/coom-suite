"""
Basic functions to run tests.
"""

import tempfile
from copy import deepcopy
from os.path import join
from typing import Any, Callable, List, Optional, Sequence

from antlr4 import InputStream
from clingo import Application, Control
from clintest.solver import Solver
from clintest.test import Test

from coomsuite.application import COOMApp
from coomsuite.utils import run_antlr4_visitor


def parse_coom(coom_input: str, grammar="model") -> List[str]:
    """
    Helper function for testing the COOM to ASP parser.
    """
    input_stream = InputStream(coom_input)
    asp_facts = run_antlr4_visitor(input_stream, grammar=grammar)
    return [a for a in asp_facts if a != ""]


def run_test(
    test: Test,
    files: Optional[List[str]] = None,
    program: Optional[str] = None,
    ctl_args: Optional[List[str]] = None,
    **kwargs: Any,
) -> None:
    """Creates a solver and runs a clintest test.

    Args:
        test (clintest.test.Test): The clintest test
        files (Optional[List[str]], optional): List of files saved in examples/tests
        program (Optional[str], optional): A clingo program. Defaults to ""
        ctl_args (Optional[List[str]], optional): List of arguments for clingo.Control. Defaults to [].
    """
    coom_app = COOMApp("coom", istest=True, **kwargs)
    file_paths = [join("examples", "tests", f) for f in files] if files else None
    ctl_args = [] if ctl_args is None else ctl_args
    solver = AppSolver(application=coom_app, files=file_paths, program=program, arguments=["0"])
    test_copy = deepcopy(test)
    solver.solve(test_copy)
    test_copy.assert_()


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
