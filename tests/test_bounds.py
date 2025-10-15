"""
Test cases for bound functionalities.
"""

from unittest import TestCase

from coomsuite.bounds import get_bound_iter, next_bound_converge


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
