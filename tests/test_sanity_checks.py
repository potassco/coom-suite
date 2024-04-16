"""
Sanity check test cases for clingo encodings.
"""

from unittest import TestCase

from . import run_test
from .tests import TEST_EMPTY, TEST_ROOT_ONLY, TEST_UNSAT

# pylint: disable=deprecated-method


class TestSanityChecks(TestCase):
    """
    Sanity check test cases for clingo encodings.
    """

    def test_product(self) -> None:
        """
        Test solving an empty product (root structure).
        """
        program = 'structure(":root").'
        run_test(TEST_ROOT_ONLY, program=program)

    def test_no_product(self) -> None:
        """
        Test solving programs without program (root structure).
        """

        program_feature = 'feature(":root",a,"b",1,1).'
        run_test(TEST_EMPTY, program=program_feature)

        program_enum_attr = """
        enumeration("a").
        attribute("a",b,"num").
        option("a", "a1").
        attr_value("a","a1",b,1)."""
        run_test(TEST_EMPTY, program=program_enum_attr)

    def test_no_feature(self) -> None:
        """
        Test solving programs without feature.
        """
        program_no_feature = """
        structure(":root").
        enumeration("a").
        option("a","a1").
        option("a","a2")."""
        run_test(TEST_ROOT_ONLY, program=program_no_feature)

    def test_undef(self) -> None:
        """
        Test solving constraints with undefined path expressions.
        """
        program_require = """
        structure(":root").

        behavior((":root",0)).
        require((":root",0),"color=Silver").
        binary(":root","color=Silver","color","=","Silver").
        path("color",0,color).
        constant("Silver")."""
        run_test(TEST_ROOT_ONLY, program=program_require)

        program_condition = """
        structure(":root").

        behavior((":root",0)).
        condition((":root",0),"color=Silver").
        binary(":root","color=Silver","color","=","Silver").
        path("color",0,color).
        constant("Silver").
        require((":root",0),"size=Big").
        binary(":root","size=Big","size","=","Big").
        path("size",0,size).
        constant("Big")."""
        run_test(TEST_ROOT_ONLY, program=program_condition)

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
        run_test(TEST_UNSAT, program=program)
