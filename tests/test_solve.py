"""
Test cases for solving.
"""

from typing import Any, Tuple
from unittest import TestCase

from . import run_test
from .tests import TESTS

# pylint: disable=deprecated-method


def unpack_test(test_name: str, fclingo: bool = False) -> Tuple[Any, Any, Any]:
    """
    Unpacks a clintest.Test with parameters in a dictionary.

    Args:
        test_name (str): The dictionary key of the test.
    """
    test_dict = TESTS[test_name]
    program = test_dict.get("program", None)
    files = test_dict.get("files", None)
    if fclingo:
        test = test_dict.get("ftest", test_dict["test"])
    else:
        test = test_dict["test"]
    return test, program, files


class TestClingoCore(TestCase):
    """
    Test cases for the clingo COOM core encoding.
    """

    def run_test(self, test_name: str) -> None:
        """
        Runs a clintest test with the clingo COOM core encoding.

        Args:
            test (dict): The clintest test as a dictionary.
                         Should contain keys:
                            "test" (clintest.Test)
                            "files" (List[str] or "program" (str)
        """
        test, program, files = unpack_test(test_name)
        run_test(test, files=files, program=program, ctl_args=["0"], solver="clingo", profile="core")

    def test_require(self) -> None:
        """
        Test solving require constraints with the clingo COOM core encoding.
        """
        self.run_test("require_with_number")
        self.run_test("require_with_number_ge")
        self.run_test("require_with_constant")
        self.run_test("require_two_wheels")

    def test_condition(self) -> None:
        """
        Test solving condition constraints with the clingo COOM core encoding.
        """
        self.run_test("condition")

    def test_combinations(self) -> None:
        """
        Test solving combinations constraints with the clingo COOM core encoding.
        """
        self.run_test("combination")

    def test_enumeration(self) -> None:
        """
        Test solving enumeration features with the clingo COOM core encoding.
        """
        self.run_test("enumeration")
        self.run_test("bool_enumeration")

    def test_attribute(self) -> None:
        """
        Test solving enumeration features with attributes with the clingo COOM core encoding.
        """
        self.run_test("attribute")


class TestFclingoCore(TestCase):
    """
    Test cases for the fclingo COOM core encoding.
    """

    def run_test(self, test_name: str) -> None:
        """Runs a clintest test with the fclingo COOM core encoding.

        Args:
            test (dict): The clintest test as a dictionary.
                         Should contain keys:
                            "test" (clintest.Test)
                            "files" (List[str] or "program" (str)
                            "ftest" (Optional[clintest.Test]): A clintest for fclingo
        """
        test, program, files = unpack_test(test_name, fclingo=True)
        run_test(test, files=files, program=program, ctl_args=["0"], solver="fclingo", profile="core")

    def test_require(self) -> None:
        """
        Test solving require constraints with the fclingo COOM core encoding.
        """
        self.run_test("require_with_number")
        self.run_test("require_with_number_ge")
        self.run_test("require_with_constant")
        self.run_test("require_two_wheels")

    def test_condition(self) -> None:
        """
        Test solving condition constraints with the clingo COOM core encoding.
        """
        self.run_test("condition")

    def test_combinations(self) -> None:
        """
        Test solving combinations constraints with the clingo COOM core encoding.
        """
        self.run_test("combination")

    def test_enumeration(self) -> None:
        """
        Test solving enumeration features with the clingo COOM core encoding.
        """
        self.run_test("enumeration")
        self.run_test("bool_enumeration")

    def test_attribute(self) -> None:
        """
        Test solving enumeration features with attributes with the clingo COOM core encoding.
        """
        self.run_test("attribute")


class TestClingoPartonomy(TestCase):
    """
    Test cases for the clingo COOM partonomy encoding.
    """

    def run_test(self, test_name: str) -> None:
        """Runs a clintest test with the clingo COOM partonomy encoding.

        Args:
            test (dict): The clintest test as a dictionary.
                         Should contain keys:
                            "test" (clintest.Test)
                            "files" (List[str] or "program" (str)
        """
        test, program, files = unpack_test(test_name)
        run_test(test, files=files, program=program, ctl_args=["0"], solver="clingo", profile="partonomy")

    def test_structure(self) -> None:
        """
        Test solving structure features with the clingo COOM partonomy encoding.
        """
        self.run_test("structure")
        self.run_test("structure_optional")
        self.run_test("structure_nested")
        self.run_test("structure_nested_optional")

    def test_require(self) -> None:
        """
        Test solving require constraints with structure involved.

        Ideas: - Context is root and points to one instance
               - Context is root and points to multiple instances
               - Context is not root and constraint gets instantiated more than once
               - Context is not root and constraints gets instantiated more than once and points to multiple instances
        """

    def test_combinations(self) -> None:
        """
        Test solving combinations constraints with structure involed.

        Ideas:  - Context is root and points to multiple instance instances, cross-product needed
                - Context is not root and constraint gets instantiated more than once
                - Context is not root and constraints gets instantiated more than once
                  and points to multiple instances, cross-product needed
        """


class TestFclingoPartonomy(TestCase):
    """
    Test cases for the fclingo COOM partonomy encoding.
    """

    def run_test(self, test_name: str) -> None:
        """Runs a clintest test with the fclingo COOM partonomy encoding.

        Args:
            test (dict): The clintest test as a dictionary.
                         Should contain keys:
                            "test" (clintest.Test)
                            "files" (List[str] or "program" (str)
        """
        test, program, files = unpack_test(test_name, fclingo=True)
        run_test(test, files=files, program=program, ctl_args=["0"], solver="fclingo", profile="partonomy")

    def test_structure(self) -> None:
        """
        Test solving structure features with the fclingo COOM partonomy encoding.
        """
        self.run_test("structure")
        self.run_test("structure_optional")
        self.run_test("structure_nested")
        self.run_test("structure_nested_optional")
