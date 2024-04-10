"""
Test cases for solving.
"""

from typing import Any
from unittest import TestCase

from . import run_test
from .tests import TESTS

# pylint: disable=deprecated-method


class TestClingoCore(TestCase):
    """
    Test cases for the clingo COOM core encoding.
    """

    def run_test(self, test: dict[str, Any]) -> None:
        """Runs a clintest test with the clingo COOM core encoding.

        Args:
            test (dict): The clintest test as a dictionary.
                         Should contain keys:
                            "test" (clintest.Test)
                            "files" (List[str] or "program" (str)
        """
        program = test.get("program", None)
        files = test.get("files", None)
        run_test(test["test"], files=files, program=program, ctl_args=["0"], solver="clingo", profile="core")

    def test_require(self) -> None:
        """
        Test solving require constraints with the clingo COOM core encoding.
        """
        self.run_test(TESTS["require_with_number"])
        self.run_test(TESTS["require_with_number_ge"])
        self.run_test(TESTS["require_with_constant"])
        self.run_test(TESTS["require_two_wheels"])

    def test_condition(self) -> None:
        """
        Test solving condition constraints with the clingo COOM core encoding.
        """
        self.run_test(TESTS["condition"])

    def test_combinations(self) -> None:
        """
        Test solving combinations constraints with the clingo COOM core encoding.
        """
        self.run_test(TESTS["combination"])

    def test_enumeration(self) -> None:
        """
        Test solving enumeration features with the clingo COOM core encoding.
        """
        self.run_test(TESTS["enumeration"])
        self.run_test(TESTS["bool_enumeration"])

    def test_attribute(self) -> None:
        """
        Test solving enumeration features with attributes with the clingo COOM core encoding.
        """
        self.run_test(TESTS["attribute"])


class TestFclingoCore(TestCase):
    """
    Test cases for the fclingo COOM core encoding.
    """

    def run_test(self, test: dict[str, Any]) -> None:
        """Runs a clintest test with the fclingo COOM core encoding.

        Args:
            test (dict): The clintest test as a dictionary.
                         Should contain keys:
                            "test" (clintest.Test)
                            "files" (List[str] or "program" (str)
                            "ftest" (Optional[clintest.Test]): A clintest for fclingo
        """
        fclingo_test = test.get("ftest", test["test"])
        program = test.get("program", None)
        files = test.get("files", None)
        run_test(fclingo_test, files=files, program=program, ctl_args=["0"], solver="fclingo", profile="core")

    def test_require(self) -> None:
        """
        Test solving require constraints with the fclingo COOM core encoding.
        """
        self.run_test(TESTS["require_with_number"])
        self.run_test(TESTS["require_with_number_ge"])
        self.run_test(TESTS["require_with_constant"])
        self.run_test(TESTS["require_two_wheels"])

    def test_condition(self) -> None:
        """
        Test solving condition constraints with the clingo COOM core encoding.
        """
        self.run_test(TESTS["condition"])

    def test_combinations(self) -> None:
        """
        Test solving combinations constraints with the clingo COOM core encoding.
        """
        self.run_test(TESTS["combination"])

    def test_enumeration(self) -> None:
        """
        Test solving enumeration features with the clingo COOM core encoding.
        """
        self.run_test(TESTS["enumeration"])
        self.run_test(TESTS["bool_enumeration"])

    def test_attribute(self) -> None:
        """
        Test solving enumeration features with attributes with the clingo COOM core encoding.
        """
        self.run_test(TESTS["attribute"])


class TestClingoPartonomy(TestCase):
    """
    Test cases for the clingo COOM partonomy encoding.
    """

    def run_test(self, test: dict[str, Any]) -> None:
        """Runs a clintest test with the clingo COOM partonomy encoding.

        Args:
            test (dict): The clintest test as a dictionary.
                         Should contain keys:
                            "test" (clintest.Test)
                            "files" (List[str] or "program" (str)
        """
        program = test.get("program", None)
        files = test.get("files", None)
        run_test(test["test"], files=files, program=program, ctl_args=["0"], solver="clingo", profile="partonomy")

    def test_structure(self) -> None:
        """
        Test solving structure features with the clingo COOM partonomy encoding.
        """
        self.run_test(TESTS["structure"])
        self.run_test(TESTS["structure_optional"])
        self.run_test(TESTS["structure_nested"])
        self.run_test(TESTS["structure_nested_optional"])


class TestFclingoPartonomy(TestCase):
    """
    Test cases for the fclingo COOM partonomy encoding.
    """

    def run_test(self, test: dict[str, Any]) -> None:
        """Runs a clintest test with the fclingo COOM partonomy encoding.

        Args:
            test (dict): The clintest test as a dictionary.
                         Should contain keys:
                            "test" (clintest.Test)
                            "files" (List[str] or "program" (str)
        """
        program = test.get("program", None)
        files = test.get("files", None)
        run_test(test["test"], files=files, program=program, ctl_args=["0"], solver="fclingo", profile="partonomy")

    def test_structure(self) -> None:
        """
        Test solving structure features with the fclingo COOM partonomy encoding.
        """
        self.run_test(TESTS["structure"])
        self.run_test(TESTS["structure_optional"])
        self.run_test(TESTS["structure_nested"])
        self.run_test(TESTS["structure_nested_optional"])
