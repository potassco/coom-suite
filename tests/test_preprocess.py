"""
Test cases for preprocessing the serialized fact format.
"""

# pylint: disable=R0801
from typing import Any
from unittest import TestCase

from . import run_test, unpack_test
from .clintests.tests_preprocess import TESTS_PREPROCESS


class TestPreprocess(TestCase):
    """
    Test cases for the preprocessing encoding.
    """

    def run_test(self, test_name: str, **kwargs: Any) -> None:
        """
        Runs a clintest test with the preprocessing encoding (using clingo).
        """
        test, program, files = unpack_test(test_name, TESTS_PREPROCESS)
        run_test(test, files=files, program=program, ctl_args=["0"], solver="preprocess", **kwargs)

    def test_structure(self) -> None:
        """
        Test preprocessing COOM structures.
        """
        self.run_test("empty")
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

    def test_require(self) -> None:
        """
        Test preprocessing COOM require constraints.
        """
        self.run_test("require_undef")
        self.run_test("require_with_integer")
        self.run_test("require_with_integer_ge")
        self.run_test("require_with_string")
        self.run_test("require_two_wheels")
        self.run_test("conditional_require_undef")
        self.run_test("conditional_require")
        self.run_test("multiple_conditions")

        self.run_test("require_multiple_instances")
        self.run_test("require_with_optional_part")
        self.run_test("require_with_partonomy")
        self.run_test("require_with_partonomy2")
        self.run_test("require_with_partonomy_multiple_instances")

        self.run_test("require_next")
        self.run_test("require_previous")

    def test_imply(self) -> None:
        """
        Test preprocessing COOM imply constraints.
        """
        self.run_test("imply_undef")
        self.run_test("imply_undef_formula")
        self.run_test("imply_integer")
        self.run_test("imply_variable")
        self.run_test("imply_binary")
        self.run_test("imply_unary")
        self.run_test("imply_sum")
        self.run_test("conditional_imply_undef")
        self.run_test("conditional_imply")
        self.run_test("multiple_conditions_imply")

    def test_combinations_table(self) -> None:
        """
        Test preprocessing COOM combinations tables.
        """
        self.run_test("combination")
        self.run_test("combination_with_structure")
        self.run_test("combination_at_part_with_wildcard")
        self.run_test("combination_at_part_multiple_instances")

    def test_numerics(self) -> None:
        """
        Test preprocessing numeric features, arithmetics and aggregates in COOM.
        """
        self.run_test("simple_numeric_feature")
        self.run_test("simple_arithmetic_plus")
        self.run_test("simple_arithmetic_minus")
        self.run_test("simple_arithmetic_multiplication")
        self.run_test("simple_arithmetic_plus_default_right")
        self.run_test("simple_arithmetic_plus_default_left")
        self.run_test("simple_arithmetic_minus_default_right")
        self.run_test("simple_arithmetic_minus_default_left")
        self.run_test("parentheses")

        self.run_test("simple_count")
        self.run_test("simple_sum")
        self.run_test("sum_comprehension")
        # self.run_test("count_conditional")
        self.run_test("sum_conditional")
        self.run_test("max_conditional")
        self.run_test("min_conditional")

    def test_other_constraints(self) -> None:
        """
        Test preprocessing other types of constraints in COOM
        """
        self.run_test("alldiff_integer")
        self.run_test("alldiff_discrete")

    def test_optimization(self) -> None:
        """
        Test optimization in COOM
        """

        self.run_test("minimize")
        self.run_test("maximize")
        self.run_test("minimize_non_root_path")
        self.run_test("maximize_non_root_path")
        self.run_test("minimize_aggregate")
        self.run_test("maximize_aggregate")

    def test_user_input(self) -> None:
        """
        Test preprocessing COOM user input.
        """
        self.run_test("set_string")
        self.run_test("set_integer")
        self.run_test("add")

    def test_unbounded_cardinalities(self) -> None:
        """
        Test preprocessing of unbounded cardinalities.
        """
        self.run_test("unbounded_singleshot_zero_lb_zero_max", max_bound=0)
        self.run_test("unbounded_singleshot_zero_lb_one_max", max_bound=1)
        self.run_test("unbounded_singleshot_two_lb_zero_max", max_bound=0)
        self.run_test("unbounded_singleshot_two_lb_one_max", max_bound=1)
        self.run_test("unbounded_singleshot_optimize", max_bound=0)

    def test_unbounded_cardinalities_multishot(self) -> None:
        """
        Test multishot-specific preprocessing of unbounded cardinalities.
        """
        # test that multishot preprocessing results in a superset of singleshot preprocessing
        self.run_test("unbounded_multishot_zero_lb_zero_max_superset", max_bound=0, multishot=True)
        self.run_test("unbounded_multishot_zero_lb_one_max_superset", max_bound=1, multishot=True)
        self.run_test("unbounded_multishot_two_lb_zero_max_superset", max_bound=0, multishot=True)
        self.run_test("unbounded_multishot_two_lb_one_max_superset", max_bound=1, multishot=True)
        self.run_test("unbounded_multishot_optimize_superset", max_bound=0, multishot=True)

        # test models of multishot preprocessing
        self.run_test("unbounded_multishot_zero_lb_zero_max", max_bound=0, multishot=True)
        self.run_test("unbounded_multishot_zero_lb_one_max", max_bound=1, multishot=True)
        self.run_test("unbounded_multishot_two_lb_zero_max", max_bound=0, multishot=True)
        self.run_test("unbounded_multishot_two_lb_one_max", max_bound=1, multishot=True)
        self.run_test("unbounded_multishot_optimize", max_bound=0, multishot=True)
