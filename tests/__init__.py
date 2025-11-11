"""
Basic functions to run tests.
"""

import tempfile
from copy import deepcopy
from os.path import join
from typing import Any, Callable, List, Optional, Sequence, Tuple

from antlr4 import InputStream
from clingo import Application, Control, Symbol
from clintest.solver import Clingo, Solver
from clintest.test import Context, Test

from coomsuite.application import COOMSolverApp
from coomsuite.preprocess import preprocess
from coomsuite.utils import run_antlr4_visitor


def parse_coom(coom_input: str, grammar: str = "model") -> List[str]:
    """
    Helper function for testing the COOM to ASP parser.
    """
    input_stream = InputStream(coom_input)
    asp_facts = run_antlr4_visitor(input_stream, grammar=grammar)
    return [a for a in asp_facts if a != ""]


def unpack_test(test_name: str, tests: dict[str, Any], flingo: bool = False) -> Tuple[Any, Any, Any]:
    """
    Unpacks a clintest.Test with parameters in a dictionary.

    Args:
        test_name (str): The dictionary key of the test.
    """
    test_dict = tests[test_name]
    program = test_dict.get("program", None)
    files = test_dict.get("files", None)
    if flingo:
        test = test_dict.get("ftest", test_dict["test"])
    else:
        test = test_dict["test"]
    test_with_name = Context(test, str_=lambda test: f"{test_name} \n\n {str(test)}")
    return test_with_name, program, files


def get_model_from_file(model_file: str) -> set[Symbol | str]:
    """
    Helper function to get the model for a clintest from a file.

    Args:
        model_file (str): The file containing the model in the directory tests/clintests/results
    """
    model: set[Symbol | str] = set()
    with open(join("tests", "clintests", "results", model_file), "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                model.add(line[:-1])

    return model


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
    solver = kwargs.get("solver", "clingo")
    is_preprocess = solver == "preprocess"
    options = {
        "solver": solver,
        "output_format": kwargs.get("output_format", "asp"),
    }
    file_paths = (
        [join("examples", "tests", "solve" if not is_preprocess else "preprocess", f) for f in files] if files else []
    )
    if program:
        with tempfile.NamedTemporaryFile(mode="w", delete=False) as tmp:
            tmp_name = tmp.name
            tmp.write(program)
        file_paths.append(tmp_name)
    ctl_args = [] if ctl_args is None else ctl_args

    if is_preprocess:
        multishot = kwargs.get("multishot", False)
        max_bound = kwargs.get("max_bound", 99)
        solver = Clingo(
            program="".join(preprocess(file_paths, discrete=False, max_bound=max_bound, multishot=multishot))
        )
    else:
        coom_app = COOMSolverApp(options=options, istest=True)
        solver = AppSolver(application=coom_app, files=file_paths, arguments=ctl_args)

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

    def solve(  # type: ignore # pylint: disable=too-many-arguments, too-many-positional-arguments
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
        files: List[str],
        arguments: Optional[List[str]] = None,
    ) -> None:
        self.__application = application
        self.__arguments = [] if arguments is None else arguments
        self.__files = files

    def solve(self, test: Test) -> None:
        """Solves with clintest."""
        ctl = MockControl(test, self.__arguments)
        self.__application.main(control=ctl, files=self.__files)  # type: ignore
