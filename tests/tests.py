"""
Contains a dictionary with all clintest tests
and the corresponding files or programs they should be run with.

The key of the dictionary corresponds to the name of the test.

Most tests run with clingo and fclingo.
All other tests contain a "ftest" entry which is a test modified for fclingo.
"""

from typing import Any as AnyType

from clintest.assertion import Contains, Equals, False_, Implies, SubsetOf, SupersetOf, True_
from clintest.quantifier import All, Any, Exact
from clintest.test import And as AndTest
from clintest.test import Assert

from . import ContainsTheory, SupersetOfTheory

TESTS: dict[str, dict[str, AnyType]] = {
    "empty": {"test": Assert(All(), SubsetOf(set()))},
    "root_only": {"test": Assert(All(), Equals({'instance((),":root")'}))},
    "unsat": {"test": Assert(Exact(0), False_)},  # type: ignore # falsely views False_ as not of type Assertion
    "require_with_number": {
        "test": Assert(All(), Contains(("val((size,((wheel,((),0)),0)),27)"))),
        "ftest": Assert(All(), ContainsTheory("val((size,((wheel,((),0)),0)),27)", check_theory=True)),
        "files": ["require_with_number.lp"],
    },
    "require_with_number_ge": {
        "test": Assert(All(), Contains(("val((size,((wheel,((),0)),0)),28)"))),
        "ftest": Assert(All(), ContainsTheory("val((size,((wheel,((),0)),0)),28)", check_theory=True)),
        "files": ["require_with_number_ge.lp"],
    },
    "require_with_constant": {
        "test": Assert(All(), Contains(('val((wheel,((),0)),"W28")'))),
        "files": ["require_with_constant.lp"],
    },
    "require_two_wheels": {
        "test": AndTest(
            Assert(
                Exact(1),
                SupersetOf({("val((size,((frontWheel,((),0)),0)),27)"), ("val((size,((rearWheel,((),0)),0)),27)")}),
            ),
            Assert(
                Exact(1),
                SupersetOf({("val((size,((frontWheel,((),0)),0)),28)"), ("val((size,((rearWheel,((),0)),0)),28)")}),
            ),
        ),
        "files": ["require_two_wheels.lp"],
    },
    "condition": {
        "test": Assert(
            All(), Implies(Contains('val((wheelSupport,((),0)),"True")'), Contains('val((wheel,((),0)),"Small")'))
        ),
        "files": ["condition.lp"],
    },
    "combination": {
        "test": AndTest(
            Assert(Any(), SupersetOf({'val((wheelSupport,((),0)),"False")', 'val((wheel,((),0)),"W20")'})),
            Assert(Any(), SupersetOf({'val((wheelSupport,((),0)),"False")', 'val((wheel,((),0)),"W18")'})),
            Assert(Any(), SupersetOf({'val((wheelSupport,((),0)),"True")', 'val((wheel,((),0)),"W16")'})),
            Assert(Any(), SupersetOf({'val((wheelSupport,((),0)),"True")', 'val((wheel,((),0)),"W14")'})),
            Assert(Exact(4), True_()),
        ),
        "files": ["combination.lp"],
    },
    "enumeration": {
        "test": AndTest(
            Assert(Any(), Contains('val((color,((),0)),"Red")')),
            Assert(Any(), Contains('val((color,((),0)),"Green")')),
            Assert(Any(), Contains('val((color,((),0)),"Blue")')),
            Assert(Exact(3), True_()),
        ),
        "program": """
            structure(":root").
            feature(":root",color,"Color",1,1).

            enumeration("Color").
            option("Color", "Red").
            option("Color", "Green").
            option("Color", "Blue").""",
    },
    "bool_enumeration": {
        "test": AndTest(
            Assert(Any(), Contains('val((boolean,((),0)),"True")')),
            Assert(Any(), Contains('val((boolean,((),0)),"False")')),
            Assert(Exact(2), True_()),
        ),
        "program": """
        structure(":root").
        feature(":root",boolean,"bool",1,1).""",
    },
    "attribute": {
        "test": Assert(Exact(1), SupersetOf({"val((size,((wheel,((),0)),0)),14)", 'val(((wheel,((),0))),"W14")'})),
        "ftest": Assert(
            Exact(1),
            SupersetOfTheory({"val((size,((wheel,((),0)),0)),14)", 'val(((wheel,((),0))),"W14")'}, check_theory=True),
        ),
        "program": """
        structure(":root").
        feature(":root",wheel,"Wheel",1,1).

        enumeration("Wheel").
        attribute("Wheel",size,"num").
        option("Wheel", "W14").
        attr_value("Wheel","W14",size,14).""",
    },
}
