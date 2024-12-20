"""
Test cases for preprocessing the serialized fact format.
"""

from unittest import TestCase

from . import run_test, unpack_test
from .clintests.tests_preprocess import TESTS_PREPROCESS


class TestPreprocess(TestCase):
    """
    Test cases for the preprocessing encoding.
    """

    def run_test(self, test_name: str) -> None:
        """
        Runs a clintest test with the preprocessing encoding (using clingo).
        """
        test, program, files = unpack_test(test_name, TESTS_PREPROCESS)
        run_test(test, files=files, program=program, ctl_args=["0"], solver="preprocess", preprocess=True)

    def test_structure(self) -> None:
        """
        Test preprocessing COOM structures
        """
        self.run_test("empty_product")
        self.run_test("structure_mandatory")
        self.run_test("structure_optional")
        self.run_test("structure_nested")
        self.run_test("structure_nested_optional")

    def test_enumeration(self) -> None:
        """
        Test preprocessing COOM enumerations.
        """
        self.run_test("enumeration")
        self.run_test("bool_enumeration")
        self.run_test("attribute")


#     def test_boolean_constraints(self) -> None:
#         """
#         Test solving boolean constraints (clingo).
#         """
#         # require
#         self.run_test("require_with_number")
#         self.run_test("require_with_number_ge")
#         self.run_test("require_with_constant")
#         self.run_test("require_two_wheels")

#         # condition
#         self.run_test("condition")

#         # Boolean formulas

# def test_table_constraints(self) -> None:
#     """
#     Test solving table constraints (cclingo).
#     """
#     self.run_test("combination")


# def test_require_with_partonomy(self) -> None:
#     """
#     Test solving require constraints with partonomy involved (clingo).
#     """
#     self.run_test("require_multiple_instances")
#     self.run_test("require_with_partonomy")
#     self.run_test("require_with_partonomy2")
#     self.run_test("require_with_partonomy_multiple_instances")

# def test_table_constraints_with_partonomy(self) -> None:
#     """
#     Test solving table constraints with partonomy involve (clingo).
#     """
#     self.run_test("combination_with_structure")
#     self.run_test("combination_at_part_with_wildcard")
#     self.run_test("combination_at_part_multiple_instances")

# def test_arithmetics(self) -> None:
#     """
#     Test arithmetic language features (clingo).
#     """
#     self.run_test("simple_numeric_feature")
#     self.run_test("simple_arithmetic_plus")
#     self.run_test("simple_arithmetic_minus")
#     self.run_test("simple_arithmetic_multiplication")
#     self.run_test("simple_arithmetic_plus_default_right")
#     self.run_test("simple_arithmetic_plus_default_left")
#     self.run_test("simple_arithmetic_minus_default_right")
#     self.run_test("simple_arithmetic_minus_default_left")
#     self.run_test("parentheses")

# def test_aggregates(self) -> None:
#     """
#     Test aggregate function language features (clingo).
#     """

#     def test_set(self) -> None:
#         """
#         Test setting a value by the user.
#         """
#         self.run_test("set_discrete")
#         self.run_test("set_num")

#     def test_add(self) -> None:
#         """
#         Test adding an object by the user.
#         """
#         self.run_test("add")
#         self.run_test("add2")
