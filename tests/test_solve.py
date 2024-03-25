"""
Test cases for clingo encodings.
"""

from unittest import TestCase

from clintest.assertion import Contains
from clintest.quantifier import All
from clintest.test import Assert

from . import get_solver

# pylint: disable=deprecated-method


class TestMain(TestCase):
    """
    Test cases for clingo encodings.
    """

    def test_city(self) -> None:
        """
        Test encoding for the COOM city bike language profile.
        """
        solver = get_solver(files=["require_with_number.lp"])
        test = Assert(All(), Contains(("val((size,((wheel,((),0)),0)),27)")))
        solver.solve(test)
        test.assert_()
