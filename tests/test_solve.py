"""
Test cases for solving.
"""

from unittest import TestCase

from . import run_test, unpack_test
from .clintests.tests_solve import TESTS_SOLVE


class TestClingo(TestCase):
    """
    Test cases for the clingo encoding.
    """

    def run_test(self, test_name: str) -> None:
        """
        Runs a clintest test with the clingo encoding.
        """
        test, program, files = unpack_test(test_name, TESTS_SOLVE)
        run_test(test, files=files, program=program, ctl_args=["0"], solver="clingo", preprocess="False")

    def test_structure(self) -> None:
        """
        Test structure generation (clingo).
        """
        self.run_test("empty")
        self.run_test("optional_part")
        self.run_test("mandatory_part")
        self.run_test("part_with_cardinality")
        self.run_test("optional_part_with_subpart")

    def test_attributes(self) -> None:
        """
        Test attribute generation (clingo).
        """
        self.run_test("simple_discrete")
        self.run_test("optional_discrete")
        self.run_test("multiple_discrete")

        self.run_test("simple_integer")
        self.run_test("optional_integer")
        self.run_test("multiple_integer")

    def test_boolean_constraints(self) -> None:
        """
        Test Boolean constraints (clingo).
        """
        self.run_test("eq_sat")
        self.run_test("neq_sat")
        self.run_test("le_sat")
        self.run_test("leq_sat")
        self.run_test("ge_sat")
        self.run_test("geq_sat")

        self.run_test("eq_unsat")
        self.run_test("neq_unsat")
        self.run_test("le_unsat")
        self.run_test("leq_unsat")
        self.run_test("ge_unsat")
        self.run_test("geq_unsat")

        self.run_test("par_sat")
        self.run_test("neg_sat")
        self.run_test("or_sat")
        self.run_test("and_sat")

        self.run_test("par_unsat")
        self.run_test("neg_unsat")
        self.run_test("or_unsat")
        self.run_test("and_unsat")

        self.run_test("binary_undef")
        self.run_test("unary_undef")

    def test_table_constraints(self) -> None:
        """
        Test table constraints (clingo).
        """
        self.run_test("table_discrete")
        self.run_test("table_wildcard")
        self.run_test("table_integer")
        self.run_test("table_mixed")
        self.run_test("table_undef")
        self.run_test("table_undef2")
        self.run_test("empty_table")

    def test_arithmetics(self) -> None:
        """
        Test arithmetic formulas (clingo).
        """
        self.run_test("plus_sat")
        self.run_test("minus_sat")
        self.run_test("mult_sat")
        self.run_test("unary_plus_sat")
        self.run_test("unary_minus_sat")

        self.run_test("plus_unsat")
        self.run_test("minus_unsat")
        self.run_test("mult_unsat")
        self.run_test("unary_minus_unsat")

        self.run_test("plus_undef_sat")
        self.run_test("minus_undef_sat")
        self.run_test("plus_undef_unsat")
        self.run_test("minus_undef_unsat")

        self.run_test("precedence_sat")
        self.run_test("precedence_par_sat")
        self.run_test("precedence_unsat")
        self.run_test("precedence_par_unsat")

    def test_aggregates(self) -> None:
        """
        Test aggregation functions (clingo).
        """
        self.run_test("count")
        self.run_test("sum")
        self.run_test("min")
        self.run_test("max")

    def test_user_input(self) -> None:
        """
        Test user input (clingo)
        """

        def user_check(test: str, expected_msg: str) -> None:
            """
            Runs a test checking the user input for validity.
            """
            with self.assertRaises(ValueError) as ctx:
                self.run_test(test)
            self.assertEqual(str(ctx.exception), expected_msg)

        self.run_test("user_value_discrete")
        self.run_test("user_value_integer")
        self.run_test("user_include")

        user_check("set_invalid_variable", "User input not valid.\nVariable root.color[0] is not valid.")
        user_check("add_invalid_variable", "User input not valid.\nVariable root.basket[0] is not valid.")
        user_check("set_invalid_type", "User input not valid.\nNo value can be set for variable root.basket[0].")
        user_check("add_invalid_type", "User input not valid.\nVariable root.basket[0] cannot be added.")
        user_check(
            "set_invalid_value_discrete",
            "User input not valid.\nValue 'Yellow' is not in domain of variable root.color[0].",
        )
        user_check(
            "set_invalid_value_num", "User input not valid.\nValue '11' is not in domain of variable root.size[0]."
        )


class TestFclingo(TestCase):
    """
    Test cases for the fclingo encoding.
    """

    def run_test(self, test_name: str) -> None:
        """
        Runs a clintest test with the fclingo encoding.
        """
        test, program, files = unpack_test(test_name, TESTS_SOLVE, fclingo=True)
        run_test(test, files=files, program=program, ctl_args=["0"], solver="fclingo", preprocess="False")

    def test_structure(self) -> None:
        """
        Test structure generation (fclingo).
        """
        self.run_test("empty")
        self.run_test("optional_part")
        self.run_test("mandatory_part")
        self.run_test("part_with_cardinality")
        self.run_test("optional_part_with_subpart")

    def test_attributes(self) -> None:
        """
        Test attribute generation (fclingo).
        """
        self.run_test("simple_discrete")
        self.run_test("optional_discrete")
        self.run_test("multiple_discrete")

        self.run_test("simple_integer")
        self.run_test("optional_integer")
        self.run_test("multiple_integer")

    def test_boolean_constraints(self) -> None:
        """
        Test Boolean constraints (fclingo).
        """
        self.run_test("eq_sat")
        self.run_test("neq_sat")
        self.run_test("le_sat")
        self.run_test("leq_sat")
        self.run_test("ge_sat")
        self.run_test("geq_sat")

        self.run_test("eq_unsat")
        self.run_test("neq_unsat")
        self.run_test("le_unsat")
        self.run_test("leq_unsat")
        self.run_test("ge_unsat")
        self.run_test("geq_unsat")

        self.run_test("par_sat")
        self.run_test("neg_sat")
        self.run_test("or_sat")
        self.run_test("and_sat")

        self.run_test("par_unsat")
        self.run_test("neg_unsat")
        self.run_test("or_unsat")
        self.run_test("and_unsat")

        self.run_test("binary_undef")
        self.run_test("unary_undef")

    def test_table_constraints(self) -> None:
        """
        Test table constraints (fclingo).
        """
        self.run_test("table_discrete")
        self.run_test("table_wildcard")
        self.run_test("table_integer")
        self.run_test("table_mixed")
        self.run_test("table_undef")
        self.run_test("table_undef2")
        self.run_test("empty_table")

    def test_arithmetics(self) -> None:
        """
        Test arithmetic formulas (fclingo).
        """
        self.run_test("plus_sat")
        self.run_test("minus_sat")
        self.run_test("unary_plus_sat")
        self.run_test("unary_minus_sat")

        self.run_test("plus_unsat")
        self.run_test("minus_unsat")
        self.run_test("unary_minus_unsat")

        self.run_test("plus_undef_sat")
        self.run_test("minus_undef_sat")
        self.run_test("plus_undef_unsat")
        self.run_test("minus_undef_unsat")

        self.run_test("precedence_sat")
        self.run_test("precedence_par_sat")
        self.run_test("precedence_unsat")
        self.run_test("precedence_par_unsat")

    def test_aggregates(self) -> None:
        """
        Test aggregation functions (fclingo).
        """
        self.run_test("count")
        self.run_test("sum")
        self.run_test("min")
        self.run_test("max")

    def test_user_input(self) -> None:
        """
        Test user input (fclingo)
        """

        def user_check(test: str, expected_msg: str) -> None:
            """
            Runs a test checking the user input for validity.
            """
            with self.assertRaises(ValueError) as ctx:
                self.run_test(test)
            self.assertEqual(str(ctx.exception), expected_msg)

        self.run_test("user_value_discrete")
        self.run_test("user_value_integer")
        self.run_test("user_include")

        user_check("set_invalid_variable", "User input not valid.\nVariable root.color[0] is not valid.")
        user_check("add_invalid_variable", "User input not valid.\nVariable root.basket[0] is not valid.")
        user_check("set_invalid_type", "User input not valid.\nNo value can be set for variable root.basket[0].")
        user_check("add_invalid_type", "User input not valid.\nVariable root.basket[0] cannot be added.")
        user_check(
            "set_invalid_value_discrete",
            "User input not valid.\nValue 'Yellow' is not in domain of variable root.color[0].",
        )
        user_check(
            "set_invalid_value_num", "User input not valid.\nValue '11' is not in domain of variable root.size[0]."
        )
