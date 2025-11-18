"""
Test cases for bound functionalities.
"""

from contextlib import redirect_stdout
from unittest import TestCase
from unittest.mock import call, patch

from coomsuite.bounds import get_bound_iter, next_bound_converge
from coomsuite.bounds.solver import BoundSolver


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
                (4, 8, [10, 10], 5),
                (4, 8, [10, 20], 6),
                (4, 8, [20, 10], 7),
                (4, 8, [20, 20], 8),
                (4, 8, [65], None),
            ]:
                # returns = [10 if x else 20 for x in solve_returns]
                with patch.object(solver, "_solve", autospec=True, side_effect=solve_returns):
                    ret = solver._converge(init_unsat, init_sat)  # pylint: disable=protected-access
                    self.assertEqual(
                        ret,
                        max_bound,
                        (
                            f"failed with init_unsat={init_unsat}, init_sat={init_sat}, "
                            f"solve_returns={solve_returns}, max_bound={max_bound}"
                        ),
                    )
        # Test exception for invalid error code
        with self.assertRaises(KeyError, msg="failed with exit code=99"):
            with patch.object(solver, "_solve", autospec=True, side_effect=[99]):
                ret = solver._converge(4, 8)  # pylint: disable=protected-access

    def test_get_bounds_singleshot(self) -> None:
        """
        Test get bounds function for singleshot solving.
        """
        solver = BoundSolver([], solver="clingo", clingo_args=[], output_format="asp")

        for algorithm, initial_bound, solve_returns, converge_return, expected_converge_call in [
            ("linear", 0, [10], 0, call(-1, 0)),
            ("linear", 2, [20, 10], 3, call(2, 3)),
            ("linear", 1, [65], None, None),
            ("exponential", 3, [10], 1, call(-1, 3)),
            ("exponential", 3, [20, 10], 4, call(3, 4)),
            ("exponential", 1, [65], None, None),
        ]:
            with (
                patch.object(solver, "_solve", autospec=True, side_effect=solve_returns) as mock_solve,
                patch.object(solver, "_converge", autospec=True, side_effect=[converge_return]) as mock_converge,
            ):
                # mock_solve.side_effect = solve_returns  # [10 if x else 20 for x in solve_returns]
                # mock_converge.side_effect = [converge_return]

                with redirect_stdout(None):
                    minimal_bound = solver.get_bounds(algorithm, initial_bound, use_multishot=False)

                fail_msg = (
                    f"failed with algorithm={algorithm}, initial_bound={initial_bound}, solve_returns={solve_returns}, "
                    f"converge_return={converge_return}, expected_converge_call={expected_converge_call}"
                )

                self.assertEqual(minimal_bound, converge_return, fail_msg)
                self.assertEqual(mock_converge.call_args, expected_converge_call, fail_msg)

        # Test exception for invalid exit code
        for algorithm in ["linear", "exponential"]:
            with self.assertRaises(KeyError, msg=f"failed with algorithm={algorithm} and exit code=99"):

                with (
                    patch.object(solver, "_solve", autospec=True) as mock_solve,
                    patch.object(solver, "_converge", autospec=True) as mock_converge,
                ):
                    mock_solve.side_effect = [99]

                    with redirect_stdout(None):
                        solver.get_bounds(algorithm, 0, use_multishot=False)
