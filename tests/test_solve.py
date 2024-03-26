"""
Test cases for clingo encodings.
"""

from typing import List, Optional
from unittest import TestCase

from clintest.assertion import And, Contains
from clintest.quantifier import All, Any
from clintest.test import Assert, Test

from . import get_solver

# pylint: disable=deprecated-method


class TestMain(TestCase):
    """
    Test cases for clingo encodings.
    """

    def run_test(self, test: Test, program: Optional[str] = "", files: Optional[List[str]] = None, **kwargs) -> None:
        """Creates a solver and runs a clintest test.

        Args:
            test (clintest.Test): The clintest test
            program (Optional[str], optional): A clingo program. Defaults to ""
            files (Optional[List[str]], optional): List of files saved in examples/tests
        """
        solver = get_solver(program=program, files=files, ctl_args=["0"], **kwargs)
        solver.solve(test)
        test.assert_()

    def test_require_kids(self) -> None:
        """
        Test require constraints with the clingo kids bike encoding.
        """
        test_with_number = Assert(All(), Contains(("val((size,((wheel,((),0)),0)),27)")))
        self.run_test(test_with_number, files=["require_with_number.lp"], solver="clingo", profile="kids")

        test_with_number_ge = Assert(All(), Contains(("val((size,((wheel,((),0)),0)),28)")))
        self.run_test(test_with_number_ge, files=["require_with_number_ge.lp"], solver="clingo", profile="kids")

        test_with_constant = Assert(All(), Contains(("val((size,((wheel,((),0)),0)),28)")))
        self.run_test(test_with_constant, files=["require_with_constant.lp"], solver="clingo", profile="kids")

        test_two_wheels28 = Assert(
            Any(),
            And(
                Contains(("val((size,((frontWheel,((),0)),0)),28)")),
                Contains(("val((size,((rearWheel,((),0)),0)),28)")),
            ),
        )
        self.run_test(test_two_wheels28, files=["require_two_wheels.lp"], solver="clingo", profile="kids")

        test_two_wheels27 = Assert(
            Any(),
            And(
                Contains(("val((size,((frontWheel,((),0)),0)),27)")),
                Contains(("val((size,((rearWheel,((),0)),0)),27)")),
            ),
        )
        self.run_test(test_two_wheels27, files=["require_two_wheels.lp"], solver="clingo", profile="kids")
