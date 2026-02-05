"""
Test cases for checking the user input for validity.
"""

from os.path import join
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
        test_dict = TESTS_SOLVE[test]
        program = test_dict.get("program", None)
        if not program:
            program = []
            for test_file in test_dict["files"]:
                with open(join("examples", "tests", "solve", test_file), encoding="utf-8") as f:
                    program.extend(f.readlines())
        with self.assertLogs(log, level="WARNING") as ctx:
            check_user_input(program)
        self.assertEqual(ctx.output, [f"WARNING:main:{expected_msg}"])

    def test_user_input_check(self) -> None:
        """
        Test user input check
        """
        self.user_check("set_invalid_variable", 'Invalid user input.\nVariable "root.color[0]" does not exist.')
        self.user_check("add_invalid_variable", 'Invalid user input.\nVariable "root.basket[0]" does not exist.')
        self.user_check(
            "set_invalid_type",
            'Invalid user input.\nNo value can be set for variable "root.basket[0]". Variable exists but is a part.',
        )
        # self.user_check(
        #     "add_invalid_type", "Invalid user input.\nVariable root.basket[0] cannot be added: Not a part."
        # )
        self.user_check(
            "set_invalid_value_discrete",
            'Invalid user input.\nValue "Yellow" is not in domain of variable "root.color[0]".',
        )
        self.user_check(
            "set_invalid_value_num", 'Invalid user input.\nValue "11" is not in domain of variable "root.size[0]".'
        )
