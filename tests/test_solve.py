"""
Test cases for solving.
"""

from typing import List, Optional
from unittest import TestCase

from . import run_test, unpack_test
from .clintests.tests_solve import TESTS_SOLVE


class TestClingo(TestCase):
    """
    Test cases for the clingo encoding.
    """

    def run_test(self, test_name: str, extra_ctl_args: Optional[List[str]] = None) -> None:
        """
        Runs a clintest test with the clingo encoding.
        """
        ctl_args = ["0"]
        if extra_ctl_args:
            ctl_args += extra_ctl_args
        test, program, files = unpack_test(test_name, TESTS_SOLVE)
        run_test(test, files=files, program=program, ctl_args=ctl_args, solver="clingo")

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

    def test_optimization(self) -> None:
        """
        Test solving optimization statements (clingo)
        """
        self.run_test("minimize", extra_ctl_args=["--opt-mode=optN"])
        self.run_test("maximize", extra_ctl_args=["--opt-mode=optN"])
        self.run_test("minimize_priority", extra_ctl_args=["--opt-mode=optN"])
        self.run_test("maximize_priority", extra_ctl_args=["--opt-mode=optN"])
        self.run_test("minimize_maximize_function", extra_ctl_args=["--opt-mode=optN"])
        self.run_test("maximize_minimize_function", extra_ctl_args=["--opt-mode=optN"])

    def test_user_input(self) -> None:
        """
        Test solving user input (clingo)
        """
        self.run_test("add_part")
        self.run_test("add_attribute")
        self.run_test("set_value_discrete")
        self.run_test("set_value_integer")

        self.run_test("set_invalid_variable")
        self.run_test("add_invalid_variable")
        self.run_test("set_invalid_type")
        self.run_test("set_invalid_value_discrete")
        self.run_test("set_invalid_value_num")


class TestFlingo(TestCase):
    """
    Test cases for the flingo encoding.
    """

    def run_test(self, test_name: str, extra_ctl_args: Optional[List[str]] = None) -> None:
        """
        Runs a clintest test with the flingo encoding.
        """
        ctl_args = ["0"]
        if extra_ctl_args:
            ctl_args += extra_ctl_args  # nocoverage
        test, program, files = unpack_test(test_name, TESTS_SOLVE, flingo=True)
        run_test(test, files=files, program=program, ctl_args=ctl_args, solver="flingo", preprocess="False")

    def test_structure(self) -> None:
        """
        Test structure generation (flingo).
        """
        self.run_test("empty")
        self.run_test("optional_part")
        self.run_test("mandatory_part")
        self.run_test("part_with_cardinality")
        self.run_test("optional_part_with_subpart")

    def test_attributes(self) -> None:
        """
        Test attribute generation (flingo).
        """
        # self.run_test("simple_discrete")
        # self.run_test("optional_discrete")
        # self.run_test("multiple_discrete")

        self.run_test("simple_integer")
        # self.run_test("optional_integer")
        # self.run_test("multiple_integer")
        # self.run_test("unbounded_integer")
        # self.run_test("unbounded_integer_below")
        # self.run_test("unbounded_integer_above")

    def test_boolean_constraints(self) -> None:
        """
        Test Boolean constraints (flingo).
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
        Test table constraints (flingo).
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
        Test arithmetic formulas (flingo).
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
        Test aggregation functions (flingo).
        """
        self.run_test("count")
        self.run_test("sum")
        self.run_test("min")
        self.run_test("max")

    def test_optimization(self) -> None:
        """
        Test solving optimization statements (flingo)
        """
        self.run_test("minimize")
        self.run_test("maximize")
        # self.run_test("minimize_priority")
        # self.run_test("maximize_priority")
        self.run_test("minimize_maximize_function")
        self.run_test("maximize_minimize_function")

    def test_user_input(self) -> None:
        """
        Test solving user input (flingo)
        """
        self.run_test("add_part")
        self.run_test("add_attribute")
        self.run_test("set_value_discrete")
        self.run_test("set_value_integer")

        self.run_test("set_invalid_variable")
        self.run_test("add_invalid_variable")
        self.run_test("set_invalid_type")
        self.run_test("set_invalid_value_discrete")
        # self.run_test("set_invalid_value_num")
