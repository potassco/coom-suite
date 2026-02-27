"""
Contains a dictionary with all clintest tests for solving
and the corresponding file (corresponds to "testname.lp") or programs they should be run with.

The key of the dictionary corresponds to the name of the test.

Some tests contain a "ftest" entry which is a test modified especially to work with flingo.
All other tests work with both clingo and flingo.
"""

# pylint: disable=line-too-long, too-many-lines
from typing import Any

from . import TEST_EMPTY, TEST_UNSAT, OptimalModel, StableModels

TESTS_SOLVE: dict[str, dict[str, Any]] = {
    "empty": {"test": TEST_EMPTY, "program": ""},
    "optional_part": {
        "test": StableModels({'include("root.a[0]")'}, set()),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            index("root.a[0]",0).
            parent("root.a[0]","root").
            part("product").
            part("A").""",
    },
    "mandatory_part": {
        "test": StableModels({'include("root.a[0]")'}),
    },
    "part_with_cardinality": {
        "test": StableModels({'include("root.a[0]")'}, {'include("root.a[0]")', 'include("root.a[1]")'}),
    },
    "optional_part_with_subpart": {
        "test": StableModels(set(), {'include("root.a[0]")', 'include("root.a[0].b[0]")'}),
    },
    "simple_discrete": {
        "test": StableModels({'value("root.a[0]","A1")'}, {'value("root.a[0]","A2")'}),
    },
    "optional_discrete": {
        "test": StableModels(set(), {'value("root.a[0]","A1")'}, {'value("root.a[0]","A2")'}),
    },
    "multiple_discrete": {
        "test": StableModels(
            {'value("root.a[0]","A1")', 'value("root.a[1]","A1")'},
            {'value("root.a[0]","A1")', 'value("root.a[1]","A2")'},
            {'value("root.a[0]","A2")', 'value("root.a[1]","A1")'},
            {'value("root.a[0]","A2")', 'value("root.a[1]","A2")'},
        ),
    },
    "simple_integer": {
        "test": StableModels({'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
    },
    "optional_integer": {
        "test": StableModels(set(), {'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
    },
    "multiple_integer": {
        "test": StableModels(
            {'value("root.a[0]",1)', 'value("root.a[1]",1)'},
            {'value("root.a[0]",1)', 'value("root.a[1]",2)'},
            {'value("root.a[0]",2)', 'value("root.a[1]",1)'},
            {'value("root.a[0]",2)', 'value("root.a[1]",2)'},
        ),
    },
    "unbounded_integer": {
        "test": StableModels({'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
    },
    "unbounded_integer_below": {
        "test": StableModels({'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
    },
    "unbounded_integer_above": {
        "test": StableModels({'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
    },
    "eq_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"10=10"),"boolean").
            binary("10=10","10","=","10").
            number("10",10).""",
    },
    "neq_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"10!=11"),"boolean").
            binary("10!=11","10","!=","11").
            number("10",10).
            number("11",11).""",
    },
    "le_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"9<10"),"boolean").
            binary("9<10","9","<","10").
            number("9",9).
            number("10",10).""",
    },
    "leq_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"10<=10"),"boolean").
            binary("10<=10","10","<=","10").
            number("10",10).""",
    },
    "ge_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"12>10"),"boolean").
            binary("12>10","12",">","10").
            number("10",10).
            number("12",12).""",
    },
    "geq_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"10>=8"),"boolean").
            binary("10>=8","10",">=","8").
            number("10",10).
            number("8",8).""",
    },
    "eq_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"10=11"),"boolean").
            binary("10=11","10","=","11").
            number("10",10).
            number("11",11).""",
    },
    "neq_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"10!=10"),"boolean").
            binary("10!=10","10","!=","10").
            number("10",10).""",
    },
    "le_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"10<10"),"boolean").
            binary("10<10","10","<","10").
            number("10",10).""",
    },
    "leq_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"11<=10"),"boolean").
            binary("11<=10","11","<=","10").
            number("10",10).
            number("11",11).""",
    },
    "ge_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"10>10"),"boolean").
            binary("10>10","10",">","10").
            number("10",10).""",
    },
    "geq_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"10>=11"),"boolean").
            binary("10>=11","10",">=","11").
            number("10",10).
            number("11",11).""",
    },
    "neg_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"!10=11"),"boolean").
            unary("!10=11","!","10=11").
            binary("10=11","10","=","11").
            number("10",10).
            number("11",11).""",
    },
    "par_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"(10=10)"),"boolean").
            unary("(10=10)","()","10=10").
            binary("10=10","10","=","10").
            number("10",10).""",
    },
    "or_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"10=11||10=10"),"boolean").
            binary("10=11||10=10","10=11","||","10=10").
            binary("10=11","10","=","11").
            binary("10=10","10","=","10").
            number("10",10).
            number("11",11).""",
    },
    "and_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"11=11&&10=10"),"boolean").
            binary("11=11&&10=10","11=11","&&","10=10").
            binary("11=11","11","=","11").
            binary("10=10","10","=","10").
            number("10",10).
            number("11",11).""",
    },
    "par_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"(10=11)"),"boolean").
            unary("(10=11)","()","10=11").
            binary("10=11","10","=","11").
            number("10",10).
            number("11",11).""",
    },
    "neg_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"!10=10"),"boolean").
            unary("!10=10","!","10=10").
            binary("10=10","10","=","10").
            number("10",10).""",
    },
    "or_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"10=11||10=9"),"boolean").
            binary("10=11||10=9","10=11","||","10=9").
            binary("10=11","10","=","11").
            binary("10=9","10","=","9").
            number("9",9).
            number("10",10).
            number("11",11).""",
    },
    "and_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"10=11&&10=10"),"boolean").
            binary("10=11&&10=10","10=11","&&","10=10").
            binary("10=11","10","=","11").
            binary("10=10","10","=","10").
            number("10",10).
            number("11",11).""",
    },
    "binary_undef": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"x=5"),"boolean").
            binary("x=5","x","=","5").
            number("5",5).""",
    },
    "unary_undef": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"!x"),"boolean").
            unary("!x","!","x").""",
    },
    "table_discrete": {
        "test": StableModels(
            {'value("root.x[0]","A1")', 'value("root.y[0]","A2")'},
            {'value("root.x[0]","A1")', 'value("root.y[0]","A3")'},
            {'value("root.x[0]","A2")', 'value("root.y[0]","A1")'},
            {'value("root.x[0]","A3")', 'value("root.y[0]","A2")'},
        ),
    },
    "table_integer": {
        "test": StableModels(
            {'value("root.x[0]",1)', 'value("root.y[0]",2)'},
            {'value("root.x[0]",1)', 'value("root.y[0]",3)'},
            {'value("root.x[0]",2)', 'value("root.y[0]",1)'},
            {'value("root.x[0]",3)', 'value("root.y[0]",2)'},
        ),
    },
    "table_mixed": {
        "test": StableModels(
            {'value("root.x[0]","A1")', 'value("root.y[0]",2)'},
            {'value("root.x[0]","A1")', 'value("root.y[0]",3)'},
            {'value("root.x[0]","A2")', 'value("root.y[0]",1)'},
            {'value("root.x[0]","A3")', 'value("root.y[0]",2)'},
        ),
    },
    "table_wildcard": {
        "test": StableModels(
            {'value("root.x[0]","A1")', 'value("root.y[0]","A1")'},
            {'value("root.x[0]","A2")', 'value("root.y[0]","A1")'},
            {'value("root.x[0]","A2")', 'value("root.y[0]","A2")'},
        ),
    },
    "table_undef": {
        "test": StableModels({'value("root.x[0]","A1")'}, {'value("root.x[0]","A2")'}),
    },
    "table_undef2": {
        "test": TEST_EMPTY,
        "program": """
            part("product").
            type("root","product").
            constraint((0,"root"),"table").
            column((0,"root"),0,0,"root.a[0]").""",
    },
    "empty_table": {
        "test": TEST_UNSAT,
    },
    "plus_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"10=5+5"),"boolean").
            binary("10=5+5","10","=","5+5").
            binary("5+5","5","+","5").
            number("5",5).
            number("10",10).""",
    },
    "minus_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"5=10-5"),"boolean").
            binary("5=10-5","5","=","10-5").
            binary("10-5","10","-","5").
            number("5",5).
            number("10",10).""",
    },
    "mult_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"4=2*2"),"boolean").
            binary("4=2*2","4","=","2*2").
            binary("2*2","2","*","2").
            number("2",2).
            number("4",4).""",
    },
    "unary_plus_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"+2=2"),"boolean").
            binary("+2=2","+2","=","2").
            unary("+2","+","2").
            number("2",2).""",
    },
    "unary_minus_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"-2=0-2"),"boolean").
            binary("-2=0-2","-2","=","0-2").
            binary("0-2","0","-","2").
            unary("-2","-","2").
            number("0",0).
            number("2",2).""",
    },
    "plus_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"11=5+5"),"boolean").
            binary("11=5+5","11","=","5+5").
            binary("5+5","5","+","5").
            number("5",5).
            number("11",11).""",
    },
    "minus_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"5=11-5"),"boolean").
            binary("5=11-5","5","=","11-5").
            binary("11-5","11","-","5").
            number("5",5).
            number("11",11).""",
    },
    "mult_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"5=2*2"),"boolean").
            binary("5=2*2","5","=","2*2").
            binary("2*2","2","*","2").
            number("2",2).
            number("5",5).""",
    },
    "unary_minus_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"-2=1-2"),"boolean").
            binary("-2=1-2","-2","=","1-2").
            binary("1-2","1","-","2").
            unary("-2","-","2").
            number("1",1).
            number("2",2).""",
    },
    "plus_undef_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"2=2+x"),"boolean").
            binary("2=2+x","2","=","2+x").
            binary("2+x","2","+","x").
            number("2",2).""",
    },
    "minus_undef_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"2=2-x"),"boolean").
            binary("2=2-x","2","=","2-x").
            binary("2-x","2","-","x").
            number("2",2).""",
    },
    "plus_undef_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"4=2+x"),"boolean").
            binary("4=2+x","4","=","2+x").
            binary("2+x","2","+","x").
            number("2",2).
            number("4",4).""",
    },
    "minus_undef_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"4=2-x"),"boolean").
            binary("4=2-x","4","=","2-x").
            binary("2-x","2","-","x").
            number("2",2).
            number("4",4).""",
    },
    "precedence_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"2*2+2=6"),"boolean").
            binary("2*2+2=6","2*2+2","=","6").
            binary("2*2+2","2*2","+","2").
            binary("2*2","2","*","2").
            number("2",2).
            number("6",6).""",
    },
    "precedence_par_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"2*(2+2)=8"),"boolean").
            binary("2*(2+2)=8","2*(2+2)","=","8").
            binary("2*(2+2)","2","*","(2+2)").
            unary("(2+2)","()","2+2").
            binary("2+2","2","+","2").
            number("2",2).
            number("8",8).""",
    },
    "precedence_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"2*2+2=8"),"boolean").
            binary("2*2+2=8","2*2+2","=","8").
            binary("2*2+2","2*2","+","2").
            binary("2*2","2","*","2").
            number("2",2).
            number("8",8).""",
    },
    "precedence_par_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"2*(2+2)=6"),"boolean").
            binary("2*(2+2)=6","2*(2+2)","=","6").
            binary("2*(2+2)","2","*","(2+2)").
            unary("(2+2)","()","2+2").
            binary("2+2","2","+","2").
            number("2",2).
            number("6",6).""",
    },
    "count": {
        "test": StableModels({'include("root.x[0]")', 'include("root.x[1]")'}),
    },
    "sum": {
        "test": StableModels(
            {'value("root.x[0]",1)', 'value("root.x[1]",2)'}, {'value("root.x[0]",2)', 'value("root.x[1]",1)'}
        ),
    },
    "min": {
        "test": StableModels(
            {'value("root.x[0]",4)', 'value("root.x[1]",3)'},
            {'value("root.x[0]",3)', 'value("root.x[1]",3)'},
            {'value("root.x[0]",3)', 'value("root.x[1]",4)'},
        ),
    },
    "max": {
        "test": StableModels({'value("root.x[0]",3)', 'value("root.x[1]",3)'}),
    },
    "simple_association": {
        "test": StableModels(
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
            },
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
            },
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'associate(("root.elements[0]","root.modules[1]"),"modules",0)',
            },
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
                'associate(("root.elements[0]","root.modules[1]"),"modules",1)',
            },
        ),
    },
    "association_boolean": {
        "test": StableModels(
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
                'value("root.modules[0].type[0]","I")',
            },
        ),
    },
    "association_boolean_user": {
        "test": StableModels(
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'associate(("root.elements[0]","root.modules[1]"),"modules",0)',
                'value("root.modules[0].type[0]","II")',
                'value("root.modules[1].type[0]","I")',
            },
        ),
    },
    "association_table": {
        "test": StableModels(
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'value("root.elements[0].type[0]","A")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
                'value("root.modules[0].type[0]","I")',
                'value("root.modules[1].type[0]","I")',
            },
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'value("root.elements[0].type[0]","A")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
                'value("root.modules[0].type[0]","I")',
                'value("root.modules[1].type[0]","II")',
            },
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'value("root.elements[0].type[0]","A")',
                'associate(("root.elements[0]","root.modules[1]"),"modules",0)',
                'value("root.modules[0].type[0]","I")',
                'value("root.modules[1].type[0]","I")',
            },
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'value("root.elements[0].type[0]","A")',
                'associate(("root.elements[0]","root.modules[1]"),"modules",0)',
                'value("root.modules[0].type[0]","II")',
                'value("root.modules[1].type[0]","I")',
            },
        ),
    },
    "association_count": {
        "test": StableModels(
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
                'associate(("root.elements[0]","root.modules[1]"),"modules",1)',
            },
        ),
    },
    "association_sum": {
        "test": StableModels(
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
                'value("root.modules[0].size[0]",10)',
                'value("root.modules[1].size[0]",10)',
            },
            {
                'include("root.elements[0]")',
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'associate(("root.elements[0]","root.modules[1]"),"modules",0)',
                'value("root.modules[0].size[0]",10)',
                'value("root.modules[1].size[0]",10)',
            },
        ),
    },
    "association_match_parent": {
        "test": StableModels(
            {
                'include("root.bikes[0]")',
                'include("root.bikes[0].frame[0]")',
                'include("root.bikes[0].saddle[0]")',
                'include("root.bikes[1]")',
                'include("root.bikes[1].frame[0]")',
                'include("root.bikes[1].saddle[0]")',
                'associate(("root.bikes[0].frame[0]","root.bikes[0].saddle[0]"),"saddle",0)',
                'associate(("root.bikes[0].saddle[0]","root.bikes[0].frame[0]"),"frame",0)',
                'associate(("root.bikes[1].frame[0]","root.bikes[1].saddle[0]"),"saddle",0)',
                'associate(("root.bikes[1].saddle[0]","root.bikes[1].frame[0]"),"frame",0)',
            }
        ),
    },
    "self_association": {
        "test": StableModels(
            {
                'include("root.left_bag[0]")',
                'include("root.left_bag[1]")',
                'include("root.right_bag[0]")',
                'include("root.right_bag[1]")',
                'associate(("root.left_bag[0]","root.right_bag[1]"),"other_side",0)',
                'associate(("root.left_bag[1]","root.right_bag[0]"),"other_side",0)',
                'associate(("root.right_bag[0]","root.left_bag[1]"),"other_side",0)',
                'associate(("root.right_bag[1]","root.left_bag[0]"),"other_side",0)',
            },
            {
                'include("root.left_bag[0]")',
                'include("root.left_bag[1]")',
                'include("root.right_bag[0]")',
                'include("root.right_bag[1]")',
                'associate(("root.left_bag[0]","root.right_bag[0]"),"other_side",0)',
                'associate(("root.left_bag[1]","root.right_bag[1]"),"other_side",0)',
                'associate(("root.right_bag[1]","root.left_bag[1]"),"other_side",0)',
                'associate(("root.right_bag[0]","root.left_bag[0]"),"other_side",0)',
            },
        )
    },
    "double_association": {
        "test": StableModels(
            {
                'include("root.persons[0]")',
                'include("root.persons[1]")',
                'include("root.rooms[0]")',
                'include("root.rooms[1]")',
                'include("root.things[0]")',
                'include("root.things[1]")',
                'associate(("root.persons[0]","root.rooms[1]"),"roomsOwned",0)',
                'associate(("root.persons[0]","root.things[0]"),"thingOwned",0)',
                'associate(("root.persons[1]","root.rooms[0]"),"roomsOwned",0)',
                'associate(("root.persons[1]","root.things[1]"),"thingOwned",0)',
                'associate(("root.rooms[0]","root.persons[1]"),"owner",0)',
                'associate(("root.rooms[0]","root.things[1]"),"things",0)',
                'associate(("root.rooms[1]","root.persons[0]"),"owner",0)',
                'associate(("root.rooms[1]","root.things[0]"),"things",0)',
                'associate(("root.things[0]","root.persons[0]"),"owner",0)',
                'associate(("root.things[0]","root.rooms[1]"),"storedInRoom",0)',
                'associate(("root.things[1]","root.persons[1]"),"owner",0)',
                'associate(("root.things[1]","root.rooms[0]"),"storedInRoom",0)',
            },
            {
                'include("root.persons[0]")',
                'include("root.persons[1]")',
                'include("root.rooms[0]")',
                'include("root.rooms[1]")',
                'include("root.things[0]")',
                'include("root.things[1]")',
                'associate(("root.persons[0]","root.rooms[0]"),"roomsOwned",0)',
                'associate(("root.persons[0]","root.things[0]"),"thingOwned",0)',
                'associate(("root.persons[1]","root.rooms[1]"),"roomsOwned",0)',
                'associate(("root.persons[1]","root.things[1]"),"thingOwned",0)',
                'associate(("root.rooms[0]","root.persons[0]"),"owner",0)',
                'associate(("root.rooms[0]","root.things[0]"),"things",0)',
                'associate(("root.rooms[1]","root.persons[1]"),"owner",0)',
                'associate(("root.rooms[1]","root.things[1]"),"things",0)',
                'associate(("root.things[0]","root.persons[0]"),"owner",0)',
                'associate(("root.things[0]","root.rooms[0]"),"storedInRoom",0)',
                'associate(("root.things[1]","root.persons[1]"),"owner",0)',
                'associate(("root.things[1]","root.rooms[1]"),"storedInRoom",0)',
            },
        )
    },
    "simple_default": {"test": StableModels({'value("root.color[0]","White")'})},
    "simple_default_user": {
        "test": StableModels({'value("root.color[0]","Black")'}),
    },
    "simple_default_include": {
        "test": StableModels(set(), {'include("root.bike[0]")', 'value("root.bike[0].color[0]","White")'}),
        "files": ["simple_default_include.lp"],
    },
    "minimize": {
        "test": OptimalModel({'value("root.totalWeight[0]",1)'}),
        "ftest": OptimalModel({'value("root.totalWeight[0]",1)'}, flingo=True),
    },
    "maximize": {
        "test": OptimalModel({'value("root.totalOutput[0]",10)'}),
        "ftest": OptimalModel({'value("root.totalOutput[0]",10)'}, flingo=True),
    },
    "minimize_priority": {
        "test": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",0) '}),
        "ftest": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",0) '}, flingo=True),
    },
    "maximize_priority": {
        "test": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",10)'}),
        "ftest": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",10) '}, flingo=True),
    },
    "minimize_maximize_function": {
        "test": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",10)'}),
        "ftest": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",10)'}, flingo=True),
    },
    "maximize_minimize_function": {
        "test": OptimalModel(
            {
                'include("root.bags[0]")',
                'include("root.bags[1]")',
                'value("root.bags[0].volume[0]",10)',
                'value("root.bags[1].volume[0]",10)',
            }
        ),
        "ftest": OptimalModel(
            {
                'include("root.bags[0]")',
                'include("root.bags[1]")',
                'value("root.bags[0].volume[0]",10)',
                'value("root.bags[1].volume[0]",10)',
            },
            flingo=True,
        ),
    },
    "add_part": {"test": StableModels({'include("root.a[0]")'})},
    "add_attribute": {
        "test": StableModels({'value("root.basket[0]","White")'}, {'value("root.basket[0]","Black")'}),
    },
    "associate": {
        "test": StableModels(
            {
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'include("root.elements[0]")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
            },
        ),
    },
    "set_value_discrete": {"test": StableModels({'value("root.a[0]","A1")'})},
    "set_value_integer": {"test": StableModels({'value("root.a[0]",1)'})},
    "add_invalid_variable": {
        "test": StableModels(set()),
        "program": """
        user_include("root.basket[0]").""",
    },
    "set_invalid_variable": {"test": StableModels(set()), "program": """user_value("root.color[0]","Yellow")."""},
    "associate_invalid_variable": {
        "test": StableModels({'include("root.modules[0]")'}),
    },
    "associate_invalid_variable2": {
        "test": StableModels({'include("root.modules[0]")'}),
    },
    "set_invalid_type": {
        "test": StableModels(set(), {'include("root.basket[0]")'}),
    },
    "set_invalid_value_discrete": {
        "test": StableModels({'value("root.color[0]","Red")'}),
    },
    "set_invalid_value_num": {
        "test": StableModels({'value("root.size[0]",1)'}, {'value("root.size[0]",2)'}, {'value("root.size[0]",3)'}),
    },
    "invalid_association": {
        "test": StableModels(
            {
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'include("root.elements[0]")',
                'associate(("root.elements[0]","root.modules[0]"),"modules",0)',
            },
            {
                'include("root.modules[0]")',
                'include("root.modules[1]")',
                'include("root.elements[0]")',
                'associate(("root.elements[0]","root.modules[1]"),"modules",0)',
            },
        ),
    },
    "too_many_associations": {"test": TEST_UNSAT},
}
