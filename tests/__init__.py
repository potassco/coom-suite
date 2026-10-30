"""
Basic functions to run tests.
"""

import tempfile
from collections.abc import Callable, Sequence
from copy import deepcopy
from os.path import join
from typing import Any, cast

from antlr4 import InputStream
from clingo import Application, Control, Symbol
from clintest.solver import Clingo, Solver
from clintest.test import Context, Record, Test

from coomsuite.application import COOMSolverApp
from coomsuite.preprocess import preprocess
from coomsuite.utils import run_antlr4_visitor


def parse_coom(coom_input: str, grammar: str = "model") -> list[str]:
    """
    Help test the COOM to ASP parser.
    """
    input_stream = InputStream(coom_input)
    asp_facts = run_antlr4_visitor(input_stream, grammar=grammar)
    return [a for a in asp_facts if a != ""]


def unpack_test(test_name: str, tests: dict[str, Any], flingo: bool = False) -> tuple[Any, Any, Any]:
    """
    Unpacks a clintest.Test with parameters in a dictionary.

    Args:
        test_name (str): The dictionary key of the test
        tests (dict): A dictionary containing all tests
        flingo (bool): Whether to use flingo for the test
    """
    test_dict = tests[test_name]
    program = test_dict.get("program", None)
    files = test_dict.get("files", [f"{test_name}.lp"]) if program is None else None
    test = test_dict.get("ftest", test_dict["test"]) if flingo else test_dict["test"]
    test_with_name = Record(Context(test, str_=lambda test: f"{test_name} \n\n {test!s}"))
    return test_with_name, program, files


def get_model_from_file(model_file: str) -> set[Symbol | str]:
    """
    Get the model for a clintest from a file.

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
    files: list[str] | None = None,
    program: str | None = None,
    ctl_args: list[str] | None = None,
    **kwargs: Any,  # noqa: ANN401
) -> None:
    """
    Create a solver and runs a clintest test.

    Args:
        test (clintest.test.Test): The clintest test
        files (Optional[List[str]], optional): Test input filename saved in examples/tests
        program (Optional[str], optional): A clingo program. Defaults to ""
        ctl_args (Optional[List[str]], optional): List of arguments for clingo.Control. Defaults to [].
        **kwargs: Additional solver options.
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
        object_bounds = kwargs.get("object_bounds", False)
        max_bound = kwargs.get("max_bound", 99)
        solver = Clingo(
            program="".join(
                preprocess(
                    file_paths,
                    discrete=False,
                    max_bound=max_bound,
                    multishot=multishot,
                    object_bounds=object_bounds,
                )
            )
        )
    else:
        coom_app = COOMSolverApp(options=options, istest=True)
        solver = AppSolver(application=coom_app, files=file_paths, arguments=ctl_args)

    test_copy = deepcopy(test)
    solver.solve(test_copy)
    test_copy.assert_()


def compose(on_app: Callable[..., Any] | None, on_test: Callable[..., Any]) -> Callable[..., None]:
    """
    Composes two functions.

    Args:
        on_app (Callable): Function from the application class
        on_test (Callable): Function for the test
    """

    def f(*args: Any) -> None:  # noqa: ANN401
        """Composed function."""
        if on_app is not None:
            on_app(*args)
        on_test(*args)

    return f


class MockControl:
    """
    Mocks a clingo control object to call the Application class.
    """

    def __init__(  # noqa: D107
        self,
        test: Test,
        arguments: Sequence[str] | None = None,
    ) -> None:
        arguments = [] if arguments is None else arguments
        self._test = test
        self._ctl = Control(arguments=arguments)

    def __getattr__(self, attr: str) -> Any:  # noqa: ANN401, D105
        try:
            return self._ctl.__getattribute__(attr)
        except AttributeError:
            return self.__get_global_handler(attr)

    def solve(
        self,
        on_model: Callable[..., Any] | None = None,
        on_unsat: Callable[..., Any] | None = None,
        on_core: Callable[..., Any] | None = None,
        on_statistics: Callable[..., Any] | None = None,
        on_finish: Callable[..., Any] | None = None,
    ) -> None:
        """
        Replace the solve of the control by calling first internal callbacks and then the ones from the test.
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
    A clintest solver wrapping an application class.
    """

    def __init__(  # noqa: D107
        self,
        application: Application,
        files: list[str],
        arguments: list[str] | None = None,
    ) -> None:
        self.__application = application
        self.__arguments = [] if arguments is None else arguments
        self.__files = files

    def solve(self, test: Test) -> None:
        """Solves with clintest."""
        ctl = MockControl(test, self.__arguments)
        self.__application.main(control=cast(Control, ctl), files=self.__files)
