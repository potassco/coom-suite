"""
Test cases for checking the user input for validity.
"""

from unittest import TestCase

from coomsuite.preprocess import check_user_input


class TestUserInputCheck(TestCase):
    """
    Test user input check
    """

    def user_check(self, test: str, expected_msg: str) -> None:
        """
        Runs a test checking the user input for validity.
        """
        with self.assertRaises(ValueError) as ctx:
            check_user_input(checks[test])
        self.assertEqual(str(ctx.exception), expected_msg)

    def test_user_input_check(self) -> None:
        """
        Test user input check
        """
        self.user_check("set_invalid_variable", "User input not valid.\nVariable root.color[0] is not valid.")
        self.user_check("add_invalid_variable", "User input not valid.\nVariable root.basket[0] is not valid.")
        self.user_check("set_invalid_type", "User input not valid.\nNo value can be set for variable root.basket[0].")
        self.user_check("add_invalid_type", "User input not valid.\nVariable root.basket[0] cannot be added.")
        self.user_check(
            "set_invalid_value_discrete",
            "User input not valid.\nValue 'Yellow' is not in domain of variable root.color[0].",
        )
        self.user_check(
            "set_invalid_value_num", "User input not valid.\nValue '11' is not in domain of variable root.size[0]."
        )


checks = {
    "set_invalid_variable": """user_value("root.color[0]","Yellow").""",
    "add_invalid_variable": """
            user_include("root.basket[0]").""",
    "set_invalid_type": """
            part("product").
            part("Basket").
            type("root.basket[0]","Basket").
            parent("root.basket[0]","root").
            index("root.basket[0]",0).
            user_value("root.basket[0]","Yellow").""",
    "add_invalid_type": """
            part("product").
            discrete("Basket").
            type("root.basket[0]","Basket").
            parent("root.basket[0]","root").
            index("root.basket[0]",0).
            user_include("root.basket[0]").""",
    "set_invalid_value_discrete": """
            part("product").
            discrete("Color").
            domain("Color","Red").
            type("root.color[0]","Color").
            parent("root.color[0]","root").
            index("root.color[0]",0).
            user_value("root.color[0]","Yellow").""",
    "set_invalid_value_num": """
            part("product").
            integer("product.size").
            range("product.size",1,10).
            type("root.size[0]","product.size").
            parent("root.size[0]","root").
            index("root.size[0]",0).
            user_value("root.size[0]",11).""",
}
