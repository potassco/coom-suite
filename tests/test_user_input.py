"""
Test cases for checking the user input for validity.
"""

from unittest import TestCase

from coomsuite.preprocess import check_user_input
from coomsuite.utils.logging import get_logger

from .clintests.tests_solve import TESTS_SOLVE

log = get_logger("main")


class TestUserInputCheck(TestCase):
    """
    Test user input check
    """

    def user_check(self, test: str, expected_msg: str) -> None:
        """
        Runs a test checking the user input for validity.
        """
        with self.assertLogs(log, level="WARNING") as ctx:
            check_user_input(TESTS_SOLVE[test]["program"])
        self.assertEqual(ctx.output, [f"WARNING:main:{expected_msg}"])

    def test_user_input_check(self) -> None:
        """
        Test user input check
        """
        self.user_check(
            "set_invalid_variable", "User input not valid.\nVariable root.color[0] is not valid: Does not exist."
        )
        self.user_check(
            "add_invalid_variable", "User input not valid.\nVariable root.basket[0] is not valid: Does not exist."
        )
        self.user_check(
            "set_invalid_type",
            "User input not valid.\nNo value can be set for variable root.basket[0]: Not an attribute.",
        )
        self.user_check(
            "add_invalid_type", "User input not valid.\nVariable root.basket[0] cannot be added: Not a part."
        )
        self.user_check(
            "set_invalid_value_discrete",
            "User input not valid.\nValue 'Yellow' is not in domain of variable root.color[0].",
        )
        self.user_check(
            "set_invalid_value_num", "User input not valid.\nValue '11' is not in domain of variable root.size[0]."
        )
