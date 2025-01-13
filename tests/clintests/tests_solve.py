"""
Contains a dictionary with all clintest tests for solving
and the corresponding files or programs they should be run with.

The key of the dictionary corresponds to the name of the test.

Some tests contain a "ftest" entry which is a test modified especially to work with fclingo.
All other tests work with both clingo and fclingo.
"""

from typing import Any

from clintest.assertion import Equals, SubsetOf
from clintest.quantifier import Exact
from clintest.test import And, Assert

from . import TEST_EMPTY, TEST_UNSAT, NumModels, SingleModelEquals, SupersetOfTheory

TESTS_SOLVE: dict[str, dict[str, Any]] = {
    "empty": {"test": TEST_EMPTY, "program": ""},
    "optional_part": {
        "test": And(
            NumModels(2), Assert(Exact(1), SubsetOf(set())), Assert(Exact(1), Equals({'include("root.a[0]")'}))
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            index("root.a[0]",0).
            parent("root.a[0]","root").
            part("product").
            part("A").""",
    },
    "mandatory_part": {
        "test": SingleModelEquals({'include("root.a[0]")'}),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            index("root.a[0]",0).
            parent("root.a[0]","root").
            constraint(("root.a",1),"lowerbound").
            set("root.a","root.a[0]").
            part("product").
            part("A").""",
    },
    "part_with_cardinality": {
        "test": And(
            NumModels(2),
            Assert(Exact(1), Equals({'include("root.a[0]")'})),
            Assert(Exact(1), Equals({'include("root.a[0]")', 'include("root.a[1]")'})),
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            type("root.a[1]","A").
            index("root.a[0]",0).
            index("root.a[1]",1).
            parent("root.a[0]","root").
            parent("root.a[1]","root").
            constraint(("root.a",1),"lowerbound").
            set("root.a","root.a[0]").
            set("root.a","root.a[1]").
            part("product").
            part("A").""",
    },
    "optional_part_with_subpart": {
        "test": And(
            NumModels(2),
            Assert(Exact(1), SubsetOf(set())),
            Assert(Exact(1), Equals({'include("root.a[0]")', 'include("root.a[0].b[0]")'})),
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            type("root.a[0].b[0]","B").
            index("root.a[0]",0).
            index("root.a[0].b[0]",0).
            parent("root.a[0]","root").
            parent("root.a[0].b[0]","root.a[0]").
            constraint(("root.a[0].b",1),"lowerbound").
            set("root.a[0].b","root.a[0].b[0]").
            part("product").
            part("A").
            part("B").""",
    },
    "simple_discrete": {
        "test": And(
            NumModels(2),
            Assert(Exact(1), Equals({'value("root.a[0]","A1")'})),
            Assert(Exact(1), Equals({'value("root.a[0]","A2")'})),
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            discrete("A").
            domain("A","A1").
            domain("A","A2").
            index("root.a[0]",0).
            parent("root.a[0]","root").
            constraint(("root.a",1),"lowerbound").
            set("root.a","root.a[0]").
            part("product").""",
    },
    "optional_discrete": {
        "test": And(
            NumModels(3),
            Assert(Exact(1), Equals(set())),
            Assert(Exact(1), Equals({'value("root.a[0]","A1")'})),
            Assert(Exact(1), Equals({'value("root.a[0]","A2")'})),
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            discrete("A").
            domain("A","A1").
            domain("A","A2").
            index("root.a[0]",0).
            parent("root.a[0]","root").
            part("product").""",
    },
    "multiple_discrete": {
        "test": And(
            NumModels(4),
            Assert(Exact(1), Equals({'value("root.a[0]","A1")', 'value("root.a[1]","A1")'})),
            Assert(Exact(1), Equals({'value("root.a[0]","A1")', 'value("root.a[1]","A2")'})),
            Assert(Exact(1), Equals({'value("root.a[0]","A2")', 'value("root.a[1]","A1")'})),
            Assert(Exact(1), Equals({'value("root.a[0]","A2")', 'value("root.a[1]","A2")'})),
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            type("root.a[1]","A").
            discrete("A").
            domain("A","A1").
            domain("A","A2").
            index("root.a[0]",0).
            index("root.a[1]",1).
            parent("root.a[0]","root").
            parent("root.a[1]","root").
            constraint(("root.a",2),"lowerbound").
            set("root.a","root.a[0]").
            set("root.a","root.a[1]").
            part("product").""",
    },
    "simple_integer": {
        "test": And(
            NumModels(2),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)'})),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)'})),
        ),
        "ftest": And(
            NumModels(2),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)'}, check_theory=True)),
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            integer("A").
            range("A",1,2).
            index("root.a[0]",0).
            parent("root.a[0]","root").
            constraint(("root.a",1),"lowerbound").
            set("root.a","root.a[0]").
            part("product").""",
    },
    "optional_integer": {
        "test": And(
            NumModels(3),
            Assert(Exact(1), Equals(set())),
            Assert(Exact(1), Equals({'value("root.a[0]",1)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",2)'})),
        ),
        "ftest": And(
            NumModels(3),
            # Assert(Exact(1), SubsetOf({})), # How to check empty set for fclingo (with regards to output atoms)?
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)'}, check_theory=True)),
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            integer("A").
            range("A",1,2).
            index("root.a[0]",0).
            parent("root.a[0]","root").
            part("product").""",
    },
    "multiple_integer": {
        "test": And(
            NumModels(4),
            Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.a[1]",1)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.a[1]",2)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",2)', 'value("root.a[1]",1)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",2)', 'value("root.a[1]",2)'})),
        ),
        "ftest": And(
            NumModels(4),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.a[1]",1)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.a[1]",2)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)', 'value("root.a[1]",1)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)', 'value("root.a[1]",2)'}, check_theory=True)),
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            type("root.a[1]","A").
            integer("A").
            range("A",1,2).
            index("root.a[0]",0).
            index("root.a[1]",1).
            parent("root.a[0]","root").
            parent("root.a[1]","root").
            constraint(("root.a",2),"lowerbound").
            set("root.a","root.a[0]").
            set("root.a","root.a[1]").
            part("product").""",
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
        "test": And(
            NumModels(4),
            Assert(Exact(1), Equals({'value("root.x[0]","A1")', 'value("root.y[0]","A2")'})),
            Assert(Exact(1), Equals({'value("root.x[0]","A1")', 'value("root.y[0]","A3")'})),
            Assert(Exact(1), Equals({'value("root.x[0]","A2")', 'value("root.y[0]","A1")'})),
            Assert(Exact(1), Equals({'value("root.x[0]","A3")', 'value("root.y[0]","A2")'})),
        ),
        "files": ["table_discrete.lp"],
    },
    "table_integer": {
        "test": And(
            NumModels(4),
            Assert(Exact(1), Equals({'value("root.x[0]",1)', 'value("root.y[0]",2)'})),
            Assert(Exact(1), Equals({'value("root.x[0]",1)', 'value("root.y[0]",3)'})),
            Assert(Exact(1), Equals({'value("root.x[0]",2)', 'value("root.y[0]",1)'})),
            Assert(Exact(1), Equals({'value("root.x[0]",3)', 'value("root.y[0]",2)'})),
        ),
        "ftest": And(
            NumModels(4),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",1)', 'value("root.y[0]",2)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",1)', 'value("root.y[0]",3)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",2)', 'value("root.y[0]",1)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",3)', 'value("root.y[0]",2)'}, check_theory=True)),
        ),
        "files": ["table_integer.lp"],
    },
    "table_mixed": {
        "test": And(
            NumModels(4),
            Assert(Exact(1), Equals({'value("root.x[0]","A1")', 'value("root.y[0]",2)'})),
            Assert(Exact(1), Equals({'value("root.x[0]","A1")', 'value("root.y[0]",3)'})),
            Assert(Exact(1), Equals({'value("root.x[0]","A2")', 'value("root.y[0]",1)'})),
            Assert(Exact(1), Equals({'value("root.x[0]","A3")', 'value("root.y[0]",2)'})),
        ),
        "ftest": And(
            NumModels(4),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]","A1")', 'value("root.y[0]",2)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]","A1")', 'value("root.y[0]",3)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]","A2")', 'value("root.y[0]",1)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]","A3")', 'value("root.y[0]",2)'}, check_theory=True)),
        ),
        "files": ["table_mixed.lp"],
    },
    "table_wildcard": {
        "test": And(
            NumModels(3),
            Assert(Exact(1), Equals({'value("root.x[0]","A1")', 'value("root.y[0]","A1")'})),
            Assert(Exact(1), Equals({'value("root.x[0]","A2")', 'value("root.y[0]","A1")'})),
            Assert(Exact(1), Equals({'value("root.x[0]","A2")', 'value("root.y[0]","A2")'})),
        ),
        "files": ["table_wildcard.lp"],
    },
    "table_undef": {
        "test": And(
            NumModels(2),
            Assert(Exact(1), Equals({'value("root.x[0]","A1")'})),
            Assert(Exact(1), Equals({'value("root.x[0]","A2")'})),
        ),
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
        "program": """
            part("product").
            type("root","product").
            type("root.a[0]","A").
            discrete("A").
            index("root.a[0]",0).
            parent("root.a[0]","root").
            constraint((0,"root"),"table").
            column((0,"root"),0,0,"root.a[0]").""",
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
        "test": SingleModelEquals({'include("root.x[0]")', 'include("root.x[1]")'}),
        "files": ["count.lp"],
    },
    "sum": {
        "test": And(
            NumModels(2),
            Assert(Exact(1), Equals({'value("root.x[0]",1)', 'value("root.x[1]",2)'})),
            Assert(Exact(1), Equals({'value("root.x[0]",2)', 'value("root.x[1]",1)'})),
        ),
        "ftest": And(
            NumModels(2),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",1)', 'value("root.x[1]",2)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",2)', 'value("root.x[1]",1)'}, check_theory=True)),
        ),
        "files": ["sum.lp"],
    },
    "min": {
        "test": And(
            NumModels(3),
            Assert(Exact(1), Equals({'value("root.x[0]",4)', 'value("root.x[1]",3)'})),
            Assert(Exact(1), Equals({'value("root.x[0]",3)', 'value("root.x[1]",3)'})),
            Assert(Exact(1), Equals({'value("root.x[0]",3)', 'value("root.x[1]",4)'})),
        ),
        "ftest": And(
            NumModels(3),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",4)', 'value("root.x[1]",3)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",3)', 'value("root.x[1]",3)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",3)', 'value("root.x[1]",4)'}, check_theory=True)),
        ),
        "files": ["min.lp"],
    },
    "max": {
        "test": SingleModelEquals({'value("root.x[0]",3)', 'value("root.x[1]",3)'}),
        "ftest": And(
            NumModels(1),
            Assert(Exact(1), SupersetOfTheory({'value("root.x[0]",3)', 'value("root.x[1]",3)'}, check_theory=True)),
        ),
        "files": ["max.lp"],
    },
    "user_value_discrete": {
        "test": SingleModelEquals({'value("root.a[0]","A1")'}),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            discrete("A").
            domain("A","A1").
            domain("A","A2").
            index("root.a[0]",0).
            parent("root.a[0]","root").
            constraint(("root.a",1),"lowerbound").
            set("root.a","root.a[0]").
            part("product").
            user_value("root.a[0]","A1").""",
    },
    "user_value_integer": {
        "test": SingleModelEquals({'value("root.a[0]",1)'}),
        "ftest": And(
            NumModels(1),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)'}, check_theory=True)),
        ),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            integer("A").
            range("A",1,2).
            index("root.a[0]",0).
            parent("root.a[0]","root").
            constraint(("root.a",1),"lowerbound").
            set("root.a","root.a[0]").
            part("product").
            user_value("root.a[0]",1).""",
    },
    "user_include": {
        "test": SingleModelEquals({'include("root.a[0]")'}),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            index("root.a[0]",0).
            parent("root.a[0]","root").
            part("product").
            part("A").
            user_include("root.a[0]").""",
    },
}
