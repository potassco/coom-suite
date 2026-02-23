"""
Contains a dictionary with all clintest tests for solving
and the corresponding files or programs they should be run with.

The key of the dictionary corresponds to the name of the test.

Some tests contain a "ftest" entry which is a test modified especially to work with flingo.
All other tests work with both clingo and flingo.
"""

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
        "files": ["mandatory_part.lp"],
    },
    "part_with_cardinality": {
        "test": StableModels({'include("root.a[0]")'}, {'include("root.a[0]")', 'include("root.a[1]")'}),
        "files": ["part_with_cardinality.lp"],
    },
    "optional_part_with_subpart": {
        "test": StableModels(set(), {'include("root.a[0]")', 'include("root.a[0].b[0]")'}),
        "files": ["optional_part_with_subpart.lp"],
    },
    "simple_discrete": {
        "test": StableModels({'value("root.a[0]","A1")'}, {'value("root.a[0]","A2")'}),
        "files": ["simple_discrete.lp"],
    },
    "optional_discrete": {
        "test": StableModels(set(), {'value("root.a[0]","A1")'}, {'value("root.a[0]","A2")'}),
        "files": ["optional_discrete.lp"],
    },
    "multiple_discrete": {
        "test": StableModels(
            {'value("root.a[0]","A1")', 'value("root.a[1]","A1")'},
            {'value("root.a[0]","A1")', 'value("root.a[1]","A2")'},
            {'value("root.a[0]","A2")', 'value("root.a[1]","A1")'},
            {'value("root.a[0]","A2")', 'value("root.a[1]","A2")'},
        ),
        "files": ["multiple_discrete.lp"],
    },
    "simple_integer": {
        "test": StableModels({'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
        "files": ["simple_integer.lp"],
    },
    "optional_integer": {
        "test": StableModels(set(), {'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
        "files": ["optional_integer.lp"],
    },
    "multiple_integer": {
        "test": StableModels(
            {'value("root.a[0]",1)', 'value("root.a[1]",1)'},
            {'value("root.a[0]",1)', 'value("root.a[1]",2)'},
            {'value("root.a[0]",2)', 'value("root.a[1]",1)'},
            {'value("root.a[0]",2)', 'value("root.a[1]",2)'},
        ),
        "files": ["multiple_integer.lp"],
    },
    "unbounded_integer": {
        "test": StableModels({'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
        "files": ["unbounded_integer.lp"],
    },
    "unbounded_integer_below": {
        "test": StableModels({'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
        "files": ["unbounded_integer_below.lp"],
    },
    "unbounded_integer_above": {
        "test": StableModels({'value("root.a[0]",1)'}, {'value("root.a[0]",2)'}),
        "files": ["unbounded_integer_above.lp"],
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
        "files": ["table_discrete.lp"],
    },
    "table_integer": {
        "test": StableModels(
            {'value("root.x[0]",1)', 'value("root.y[0]",2)'},
            {'value("root.x[0]",1)', 'value("root.y[0]",3)'},
            {'value("root.x[0]",2)', 'value("root.y[0]",1)'},
            {'value("root.x[0]",3)', 'value("root.y[0]",2)'},
        ),
        "files": ["table_integer.lp"],
    },
    "table_mixed": {
        "test": StableModels(
            {'value("root.x[0]","A1")', 'value("root.y[0]",2)'},
            {'value("root.x[0]","A1")', 'value("root.y[0]",3)'},
            {'value("root.x[0]","A2")', 'value("root.y[0]",1)'},
            {'value("root.x[0]","A3")', 'value("root.y[0]",2)'},
        ),
        "files": ["table_mixed.lp"],
    },
    "table_wildcard": {
        "test": StableModels(
            {'value("root.x[0]","A1")', 'value("root.y[0]","A1")'},
            {'value("root.x[0]","A2")', 'value("root.y[0]","A1")'},
            {'value("root.x[0]","A2")', 'value("root.y[0]","A2")'},
        ),
        "files": ["table_wildcard.lp"],
    },
    "table_undef": {
        "test": StableModels({'value("root.x[0]","A1")'}, {'value("root.x[0]","A2")'}),
        "files": ["table_undef.lp"],
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
        "files": ["empty_table.lp"],
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
        "files": ["count.lp"],
    },
    "sum": {
        "test": StableModels(
            {'value("root.x[0]",1)', 'value("root.x[1]",2)'}, {'value("root.x[0]",2)', 'value("root.x[1]",1)'}
        ),
        "files": ["sum.lp"],
    },
    "min": {
        "test": StableModels(
            {'value("root.x[0]",4)', 'value("root.x[1]",3)'},
            {'value("root.x[0]",3)', 'value("root.x[1]",3)'},
            {'value("root.x[0]",3)', 'value("root.x[1]",4)'},
        ),
        "files": ["min.lp"],
    },
    "max": {
        "test": StableModels({'value("root.x[0]",3)', 'value("root.x[1]",3)'}),
        "files": ["max.lp"],
    },
    "simple_default": {"test": StableModels({'value("root.color[0]","White")'}), "files": ["simple_default.lp"]},
    "simple_default_user": {
        "test": StableModels({'value("root.color[0]","Black")'}),
        "files": ["simple_default_user.lp"],
    },
    "minimize": {
        "test": OptimalModel({'value("root.totalWeight[0]",1)'}),
        "ftest": OptimalModel({'value("root.totalWeight[0]",1)'}, flingo=True),
        "files": ["minimize.lp"],
    },
    "maximize": {
        "test": OptimalModel({'value("root.totalOutput[0]",10)'}),
        "ftest": OptimalModel({'value("root.totalOutput[0]",10)'}, flingo=True),
        "files": ["maximize.lp"],
    },
    "minimize_priority": {
        "test": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",0) '}),
        "ftest": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",0) '}, flingo=True),
        "files": ["minimize_priority.lp"],
    },
    "maximize_priority": {
        "test": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",10)'}),
        "ftest": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",10) '}, flingo=True),
        "files": ["maximize_priority.lp"],
    },
    "minimize_maximize_function": {
        "test": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",10)'}),
        "ftest": OptimalModel({'include("root.bags[0]")', 'value("root.bags[0].volume[0]",10)'}, flingo=True),
        "files": ["minimize_maximize_function.lp"],
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
        "files": ["maximize_minimize_function.lp"],
    },
    "add_part": {"test": StableModels({'include("root.a[0]")'}), "files": ["add_part.lp"]},
    "add_attribute": {
        "test": StableModels({'value("root.basket[0]","White")'}, {'value("root.basket[0]","Black")'}),
        "files": ["add_attribute.lp"],
    },
    "set_value_discrete": {"test": StableModels({'value("root.a[0]","A1")'}), "files": ["set_value_discrete.lp"]},
    "set_value_integer": {"test": StableModels({'value("root.a[0]",1)'}), "files": ["set_value_integer.lp"]},
    "add_invalid_variable": {
        "test": StableModels(set()),
        "program": """
        user_include("root.basket[0]").""",
    },
    "set_invalid_variable": {"test": StableModels(set()), "program": """user_value("root.color[0]","Yellow")."""},
    "set_invalid_type": {
        "test": StableModels(set(), {'include("root.basket[0]")'}),
        "files": ["set_invalid_type.lp"],
    },
    "set_invalid_value_discrete": {
        "test": StableModels({'value("root.color[0]","Red")'}),
        "files": ["set_invalid_value_discrete.lp"],
    },
    "set_invalid_value_num": {
        "test": StableModels({'value("root.size[0]",1)'}, {'value("root.size[0]",2)'}, {'value("root.size[0]",3)'}),
        "files": ["set_invalid_value_num.lp"],
    },
}
