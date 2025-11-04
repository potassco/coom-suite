"""
Test cases for bound functionalities.
"""

from contextlib import contextmanager, redirect_stdout
from os import close, devnull, dup, dup2
from os.path import join
from unittest import TestCase
from unittest.mock import patch, call

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
                with patch.object(solver, "_solve", autospec=True, side_effect=returns):
                    ret = solver._converge(init_unsat, init_sat)  # pylint: disable=protected-access
                    self.assertEqual(
                        ret,
                        max_bound,
                        (
                            f"failed with init_unsat={init_unsat}, init_sat={init_sat}, "
                            f"solve_returns={solve_returns}, max_bound={max_bound}"
                        ),
                    )

    def test_get_bounds_singleshot(self) -> None:
        """
        Test get bounds function for singleshot solving.
        """
        for algorithm, initial_bound, solve_returns, converge_return, expected_converge_call in [
            ("linear", 0, [True], 0, call(-1, 0)),
            ("linear", 2, [False, True], 3, call(2, 3)),
            ("exponential", 3, [True], 1, call(-1, 3)),
            ("exponential", 3, [False, True], 4, call(3, 4)),
        ]:
            solver = BoundSolver([], solver="clingo", clingo_args=[], output_format="asp")

            with (
                patch.object(solver, "_solve", autospec=True) as mock_solve,
                patch.object(solver, "_converge", autospec=True) as mock_converge,
            ):
                mock_solve.side_effect = [10 if x else 20 for x in solve_returns]
                mock_converge.side_effect = [converge_return]

                with redirect_stdout(None):
                    minimal_bound = solver.get_bounds(algorithm, initial_bound, use_multishot=False)

                fail_msg = (
                    f"failed with algorithm={algorithm}, initial_bound={initial_bound}, solve_returns={solve_returns}, "
                    f"converge_return={converge_return}, expected_converge_call={expected_converge_call}"
                )

                self.assertEqual(minimal_bound, converge_return, fail_msg)
                self.assertEqual(mock_converge.call_args, expected_converge_call, fail_msg)

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
