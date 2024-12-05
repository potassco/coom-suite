"""
Sanity check test cases for clingo encodings.
"""

from . import run_test
from .tests import TEST_EMPTY, TEST_UNSAT

# pylint: disable=deprecated-method


# class TestSanityChecks(TestCase):
#     """
#     Sanity check test cases for clingo encodings.
#     """

#     def test_product(self) -> None:
#         """
#         Test solving an empty product (root structure).
#         """
#         program = 'structure("product").'
#         run_test(deepcopy(TEST_EMPTY), program=program)

#     def test_no_product(self) -> None:
#         """
#         Test solving programs without program (root structure).
#         """

#         program_feature = 'feature("product","a","b",1,1).'
#         run_test(deepcopy(TEST_EMPTY), program=program_feature)

#         program_enum_attr = """
#         coom_enumeration("a").
#         coom_attribute("a","b","num").
#         coom_option("a", "a1").
#         coom_attribute_value("a","a1","b",1)."""
#         run_test(deepcopy(TEST_EMPTY), program=program_enum_attr)

#     def test_no_feature(self) -> None:
#         """
#         Test solving programs without feature.
#         """
#         program_no_feature = """
#         coom_structure("product").
#         coom_enumeration("a").
#         coom_option("a","a1").
#         coom_option("a","a2")."""
#         run_test(deepcopy(TEST_EMPTY), program=program_no_feature)

#     def test_undef(self) -> None:
#         """
#         Test solving constraints with undefined path expressions.
#         """
#         program_require = """
#         coom_structure("product").

#         coom_behavior(("product",0)).
#         coom_require(("product",0),"color=Silver").
#         coom_binary("color=Silver","color","=","Silver").
#         coom_path("color",0,"color").
#         coom_constant("Silver")."""
#         run_test(deepcopy(TEST_EMPTY), program=program_require)

#         program_condition = """
#         coom_structure("product").

#         coom_behavior(("product",0)).
#         coom_condition(("product",0),"color=Silver").
#         coom_binary("color=Silver","color","=","Silver").
#         coom_path("color",0,"color").
#         coom_constant("Silver").
#         coom_require(("product",0),"size=Big").
#         coom_binary("size=Big","size","=","Big").
#         coom_path("size",0,"size").
#         coom_constant("Big")."""
#         run_test(deepcopy(TEST_EMPTY), program=program_condition)

#     def test_empty_combinations(self) -> None:
#         """
#         Test solving empty combination tables
#         """
#         program = """
#         coom_structure("product").
#         coom_feature("product","a","b",1,1).

#         coom_enumeration("b").

#         coom_behavior(0).
#         coom_context(0,"product").
#         coom_combinations(0,0,"a").
#         coom_path("a",0,"a")."""
#         run_test(deepcopy(TEST_UNSAT), program=program)
