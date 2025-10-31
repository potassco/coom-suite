"""
Test cases for bound functionalities.
"""

from contextlib import contextmanager, redirect_stdout
from os import close, devnull, dup, dup2
from os.path import join
from unittest import TestCase
from unittest.mock import patch

from coomsuite.bounds import get_bound_iter, next_bound_converge
from coomsuite.bounds.solver import BoundSolver

ALGORITHMS = ["linear", "exponential"]
INSTANCES = [
    ("cargo-bike-complex-5.lp", 5),
    ("cargo-bike-complex-7.lp", 7),
]


@contextmanager
def suppress_output_fd():  # type: ignore
    """
    Suppress all output.
    """
    with open(devnull, "w", encoding="utf-8") as f:
        old_stdout_fd = dup(1)
        old_stderr_fd = dup(2)
        try:
            dup2(f.fileno(), 1)
            dup2(f.fileno(), 2)
            yield
        finally:
            dup2(old_stdout_fd, 1)
            dup2(old_stderr_fd, 2)
            close(old_stdout_fd)
            close(old_stderr_fd)


class TestBound(TestCase):
    """
    Test cases for bound iterator and convergence functions.
    """

    def test_bound_iter_linear(self) -> None:
        """
        Test the linear bound iterator.
        """
        bound_iter = get_bound_iter(algorithm="linear", start=0)
        self.assertEqual(next(bound_iter), 1)
        self.assertEqual(next(bound_iter), 2)
        self.assertEqual(next(bound_iter), 3)
        self.assertEqual(next(bound_iter), 4)

        bound_iter = get_bound_iter(algorithm="linear", start=5)
        self.assertEqual(next(bound_iter), 6)
        self.assertEqual(next(bound_iter), 7)
        self.assertEqual(next(bound_iter), 8)

    def test_bound_iter_exponential(self) -> None:
        """
        Test the exponential bound iterator.
        """
        bound_iter = get_bound_iter(algorithm="exponential", start=0)
        self.assertEqual(next(bound_iter), 1)
        self.assertEqual(next(bound_iter), 2)
        self.assertEqual(next(bound_iter), 4)
        self.assertEqual(next(bound_iter), 8)

        bound_iter = get_bound_iter(algorithm="exponential", start=3)
        self.assertEqual(next(bound_iter), 4)
        self.assertEqual(next(bound_iter), 8)
        self.assertEqual(next(bound_iter), 16)

        bound_iter = get_bound_iter(algorithm="exponential", start=4)
        self.assertEqual(next(bound_iter), 8)
        self.assertEqual(next(bound_iter), 16)
        self.assertEqual(next(bound_iter), 32)

    def test_bound_iter_unknown(self) -> None:
        """
        Test invalid input for algorithm of bound iterator.
        """
        self.assertRaises(ValueError, get_bound_iter, "test", 0)

    def test_converge(self) -> None:
        """
        Test computation of bound for convergence step.
        """
        self.assertEqual(next_bound_converge(3, 4), None)
        self.assertEqual(next_bound_converge(8, 16), 12)
        self.assertEqual(next_bound_converge(-1, 4), 1)
        self.assertEqual(next_bound_converge(3, 8), 5)

    def test_singleshot_converge(self) -> None:
        """
        Test converge function used in single shot solving.
        """
        solver = BoundSolver([], solver="clingo", clingo_args=[], output_format="asp")

        with redirect_stdout(None):
            for init_unsat, init_sat, solve_returns, max_bound in [
                (4, 8, [True, True], 5),
                (4, 8, [True, False], 6),
                (4, 8, [False, True], 7),
                (4, 8, [False, False], 8),
            ]:
                returns = [10 if x else 20 for x in solve_returns]
                with patch.object(BoundSolver, "_solve", side_effect=returns):
                    ret = solver._converge(init_unsat, init_sat)  # pylint: disable=protected-access
                    self.assertEqual(ret, max_bound)

    def _compute_bound(self, fact_file: str, algorithm: str, initial_bound: int = 0, multishot: bool = False) -> int:
        with suppress_output_fd():
            bound_solver = BoundSolver(
                [join("examples", "tests", "bounds", fact_file)], solver="clingo", clingo_args=[], output_format="asp"
            )
            bound = bound_solver.get_bounds(algorithm, initial_bound, multishot)
            return bound

    def test_singleshot_minimal_bound(self) -> None:
        """
        Test minimal bound computed by singleshot solving.
        """
        for instance, bound in INSTANCES:
            for algorithm in ALGORITHMS:
                self.assertEqual(self._compute_bound(instance, algorithm), bound)

    def test_multishot_minimal_bound(self) -> None:
        """
        Test minimal bound computed by multishot solving.
        """
        for instance, bound in INSTANCES:
            for algorithm in ALGORITHMS:
                self.assertEqual(self._compute_bound(instance, algorithm, multishot=True), bound)
