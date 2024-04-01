"""
Sanity check test cases for clingo encodings.
"""

from typing import List, Optional
from unittest import TestCase

from clintest.assertion import Contains, Equals, False_, SubsetOf
from clintest.quantifier import All, Exact
from clintest.test import Assert, Test

from . import get_solver

# pylint: disable=deprecated-method


class TestMain(TestCase):
    """
    Sanity check test cases for clingo encodings.
    """

    def run_test(self, test: Test, program: Optional[str] = "", files: Optional[List[str]] = None) -> None:
        """Creates a solver and runs a clintest test.

        Args:
            test (clintest.Test): The clintest test
            program (Optional[str], optional): A clingo program. Defaults to ""
            files (Optional[List[str]], optional): List of files saved in examples/tests
        """
        solver = get_solver(program=program, files=files, ctl_args=["0"], solver="clingo")
        solver.solve(test)
        test.assert_()

    def test_product(self) -> None:
        """
        Test solving an empty product (root structure).
        """
        program = 'structure(":root").'
        test = Assert(All(), Contains(('instance((),":root")')))
        self.run_test(test, program=program)

    def test_no_product(self) -> None:
        """
        Test solving programs without program (root structure).
        """
        test_empty = Assert(All(), SubsetOf(set()))

        program_feature = 'feature(":root",a,"b",1,1).'
        self.run_test(test_empty, program=program_feature)

        program_enum_attr = """
        enumeration("a").
        attribute("a",b,"num").
        option("a", "a1").
        attr_value("a","a1",b,1)."""
        self.run_test(test_empty, program=program_enum_attr)

    def test_undef(self) -> None:
        """
        Test solving constraints with undefined path expressions.
        """
        program = """
        structure(":root").

        behavior((":root",0)).
        require((":root",0),"color=Silver").
        binary(":root","color=Silver","color","=","Silver").
        path("color",0,color).
        constant("Silver")."""

        test = Assert(All(), Equals({'instance((),":root")'}))
        self.run_test(test, program=program)

    def test_empty_combinations(self) -> None:
        """
        Test solving empty combination tables
        """
        program = """
        structure(":root").
        feature(":root",a,"b",1,1).

        enumeration("b").

        behavior((":root",0)).
        combinations((":root",0),0,"a").
        path("a",0,a)."""

        test = Assert(Exact(0), False_)
        self.run_test(test, program=program)
