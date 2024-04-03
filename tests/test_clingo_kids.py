"""
Test cases for the clingo kids bike encoding.
"""

from typing import List, Optional
from unittest import TestCase

from clintest.assertion import And, Contains, Implies, SupersetOf, True_
from clintest.quantifier import All, Any, Exact
from clintest.test import And as AndTest
from clintest.test import Assert, Test

from . import get_solver

# pylint: disable=deprecated-method


class TestMain(TestCase):
    """
    Test cases for the clingo kids bike encoding.
    """

    def run_test(self, test: Test, program: Optional[str] = "", files: Optional[List[str]] = None) -> None:
        """Creates a solver and runs a clintest test.

        Args:
            test (clintest.Test): The clintest test
            program (Optional[str], optional): A clingo program. Defaults to ""
            files (Optional[List[str]], optional): List of files saved in examples/tests
        """
        solver = get_solver(program=program, files=files, ctl_args=["0"], solver="clingo", profile="kids")
        solver.solve(test)
        test.assert_()

    def test_require_kids(self) -> None:
        """
        Test solving require constraints with the clingo kids bike encoding.
        """
        test_with_number = Assert(All(), Contains(("val((size,((wheel,((),0)),0)),27)")))
        self.run_test(test_with_number, files=["require_with_number.lp"])

        test_with_number_ge = Assert(All(), Contains(("val((size,((wheel,((),0)),0)),28)")))
        self.run_test(test_with_number_ge, files=["require_with_number_ge.lp"])

        test_with_constant = Assert(All(), Contains(('val((wheel,((),0)),"W28")')))
        self.run_test(test_with_constant, files=["require_with_constant.lp"])

        test_two_wheels = AndTest(
            Assert(
                Exact(1),
                SupersetOf({("val((size,((frontWheel,((),0)),0)),27)"), ("val((size,((rearWheel,((),0)),0)),27)")}),
            ),
            Assert(
                Exact(1),
                SupersetOf({("val((size,((frontWheel,((),0)),0)),28)"), ("val((size,((rearWheel,((),0)),0)),28)")}),
            ),
        )
        self.run_test(test_two_wheels, files=["require_two_wheels.lp"])

    def test_condition_kids(self) -> None:
        """
        Test solving condition constraints with the clingo kids bike encoding.
        """
        test_condition = Assert(
            All(), Implies(Contains('val((wheelSupport,((),0)),"True")'), Contains('val((wheel,((),0)),"Small")'))
        )
        self.run_test(test_condition, files=["condition.lp"])

    def test_combinations_kids(self) -> None:
        """
        Test solving combinations constraints with the clingo kids bike encoding.
        """
        test_combination = AndTest(
            Assert(Any(), And(Contains('val((wheelSupport,((),0)),"False")'), Contains('val((wheel,((),0)),"W20")'))),
            Assert(Any(), And(Contains('val((wheelSupport,((),0)),"False")'), Contains('val((wheel,((),0)),"W18")'))),
            Assert(Any(), And(Contains('val((wheelSupport,((),0)),"True")'), Contains('val((wheel,((),0)),"W16")'))),
            Assert(Any(), And(Contains('val((wheelSupport,((),0)),"True")'), Contains('val((wheel,((),0)),"W14")'))),
            Assert(Exact(4), True_()),
        )
        self.run_test(test_combination, files=["combination.lp"])

    def test_enumeration_kids(self) -> None:
        """
        Test solving enumeration features with the clingo kids bike encoding.
        """
        program_basic = """
            structure(":root").
            feature(":root",color,"Color",1,1).

            enumeration("Color").
            option("Color", "Red").
            option("Color", "Green").
            option("Color", "Blue")."""
        test_basic = AndTest(
            Assert(Any(), Contains('val((color,((),0)),"Red")')),
            Assert(Any(), Contains('val((color,((),0)),"Green")')),
            Assert(Any(), Contains('val((color,((),0)),"Blue")')),
            Assert(Exact(3), True_()),
        )
        self.run_test(test_basic, program=program_basic)

        program_bool = """
        structure(":root").
        feature(":root",boolean,"bool",1,1)."""

        test_bool = AndTest(
            Assert(Any(), Contains('val((boolean,((),0)),"True")')),
            Assert(Any(), Contains('val((boolean,((),0)),"False")')),
            Assert(Exact(2), True_()),
        )
        self.run_test(test_bool, program=program_bool)

    def test_attribute_kids(self) -> None:
        """
        Test solving enumeration features with attributes with the clingo kids bike encoding.
        """
        program_basic = """
        structure(":root").
        feature(":root",wheel,"Wheel",1,1).

        enumeration("Wheel").
        attribute("Wheel",size,"num").
        option("Wheel", "W14").
        attr_value("Wheel","W14",size,14)."""

        test_basic = Assert(Exact(1), SupersetOf({"val((size,((wheel,((),0)),0)),14)", 'val(((wheel,((),0))),"W14")'}))

        self.run_test(test_basic, program=program_basic)
