"""
Test cases for preprocessing the serialized fact format.
"""

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
        self.run_test("require_with_number")
        self.run_test("require_with_number_ge")
        self.run_test("require_with_constant")
        self.run_test("require_two_wheels")
        self.run_test("conditional_require_undef")
        self.run_test("conditional_require")
        self.run_test("multiple_conditions")

        self.run_test("require_multiple_instances")
        self.run_test("require_with_optional_part")
        self.run_test("require_with_partonomy")
        self.run_test("require_with_partonomy2")
        self.run_test("require_with_partonomy_multiple_instances")

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
        Test preprocessing numeric features, arithmetics and numerical function in COOM.
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

        self.run_test("count")
        self.run_test("sum")

    def test_defaults(self) -> None:
        """
        Test defaults in COOM
        """
        self.run_test("simple_default")

    def test_optimization(self) -> None:
        """
        Test optimization in COOM
        """

        self.run_test("minimize")
        self.run_test("maximize")
        self.run_test("minimize_non_root_path")
        self.run_test("maximize_non_root_path")
        self.run_test("minimize_function")
        self.run_test("maximize_function")

    def test_user_input(self) -> None:
        """
        Test preprocessing COOM user input.
        """
        self.run_test("set_constant")
        self.run_test("set_number")
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
