"""
Contains a dictionary with all clintest tests
and the corresponding files or programs they should be run with.

The key of the dictionary corresponds to the name of the test.

Most tests run with clingo and fclingo.
All other tests contain a "ftest" entry which is a test modified for fclingo.
"""

from typing import Any as AnyType
from typing import Set, Union

from clingo import Symbol
from clingo.solving import Model
from clintest.assertion import And, Contains, Equals, False_, Implies, Or, SubsetOf, SupersetOf, True_
from clintest.quantifier import All, Any, Exact
from clintest.test import And as AndTest
from clintest.test import Assert, Test


def NumModels(n: int) -> Test:  # pylint: disable=invalid-name
    """
    clintest.Test for checking that a program has a certain number of models
    """
    return Assert(Exact(n), True_())


# class EqualsTheory(Equals):
#     """
#     A clintest Equals assertion that can also check theory atoms.

#     Args:
#         symbol (Symbol): A clingo symbol.
#         check_theory (bool): Whether to include theory atoms in the check
#     """

#     def __init__(self, symbols: Set[Union[Symbol, str]], check_theory: bool = False) -> None:
#         super().__init__(symbols)
#         self.__symbols = self._Equals__symbols  # type: ignore # pylint: disable=no-member
#         self.__check_theory = check_theory

#     def holds_for(self, model: Model) -> bool:
#         if self.__check_theory:
#             return self.__symbols == set(model.symbols(shown=True, theory=True))
#         return super().holds_for(model)


class SupersetOfTheory(SupersetOf):
    """
    A clintest SupersetOf assertion that can also check theory atoms.

    Args:
        symbol (Symbol): A clingo symbol.
        check_theory (bool): Whether to include theory atoms in the check
    """

    def __init__(self, symbols: Set[Union[Symbol, str]], check_theory: bool = False) -> None:
        super().__init__(symbols)
        self.__symbols = self._SupersetOf__symbols  # type: ignore # pylint: disable=no-member
        self.__check_theory = check_theory

    def holds_for(self, model: Model) -> bool:
        if self.__check_theory:
            return set(model.symbols(shown=True, theory=True)).issuperset(self.__symbols)
        return super().holds_for(model)


class ContainsTheory(Contains):
    """
    A clintest Contains assertion that can also check theory atoms.

    Args:
        symbol (Symbol): A clingo symbol.
        check_theory (bool): Whether to include theory atoms in the check
    """

    def __init__(self, symbol: Union[Symbol, str], check_theory: bool = False) -> None:
        super().__init__(symbol)
        self.__symbol = self._Contains__symbol  # type: ignore # pylint: disable=no-member
        self.__check_theory = check_theory

    def holds_for(self, model: Model) -> bool:
        if self.__check_theory:
            return self.__symbol in model.symbols(shown=True, theory=True)
        return super().holds_for(model)  # nocoverage


TEST_EMPTY = Assert(All(), SubsetOf(set()))
TEST_UNSAT = Assert(Exact(0), False_())

TESTS_SOLVE: dict[str, dict[str, AnyType]] = {
    "empty": {"test": TEST_EMPTY, "program": ""},
    "formula_undef": {
        "test": TEST_EMPTY,
        "program": """
            type("root","product").
            part("product").
            number("5",5).""",
    },
    "table_undef": {
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
    "optional_part": {
        "test": AndTest(
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
        "test": AndTest(NumModels(1), Assert(Exact(1), Equals({'include("root.a[0]")'}))),
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
        "test": AndTest(
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
        "test": AndTest(
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
        "test": AndTest(
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
        "test": AndTest(
            NumModels(3),
            Assert(Exact(1), Equals({})),
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
        "test": AndTest(
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
        "test": AndTest(
            NumModels(2),
            Assert(Exact(1), Equals({'value("root.a[0]",1)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",2)'})),
        ),
        "ftest": AndTest(
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
        "test": AndTest(
            NumModels(3),
            Assert(Exact(1), Equals({})),
            Assert(Exact(1), Equals({'value("root.a[0]",1)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",2)'})),
        ),
        "ftest": AndTest(
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
        "test": AndTest(
            NumModels(4),
            Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.a[1]",1)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.a[1]",2)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",2)', 'value("root.a[1]",1)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",2)', 'value("root.a[1]",2)'})),
        ),
        "ftest": AndTest(
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
    "plus_default_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"2=2+x"),"boolean").
            binary("2=2+x","2","=","2+x").
            binary("2+x","2","+","x").
            number("2",2).""",
    },
    "minus_default_sat": {
        "test": TEST_EMPTY,
        "program": """
            constraint((0,"2=2-x"),"boolean").
            binary("2=2-x","2","=","2-x").
            binary("2-x","2","-","x").
            number("2",2).""",
    },
    "plus_default_unsat": {
        "test": TEST_UNSAT,
        "program": """
            constraint((0,"4=2+x"),"boolean").
            binary("4=2+x","4","=","2+x").
            binary("2+x","2","+","x").
            number("2",2).
            number("4",4).""",
    },
    "minus_default_unsat": {
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
    "user_value_discrete": {
        "test": AndTest(
            NumModels(1),
            Assert(Exact(1), Equals({'value("root.a[0]","A1")'})),
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
            part("product").
            user_value("root.a[0]","A1").""",
    },
    "user_value_integer": {
        "test": AndTest(
            NumModels(1),
            Assert(Exact(1), Equals({'value("root.a[0]",1)'})),
            # Assert(Exact(1), Equals({'value("root.a[0]",2)'})),
        ),
        "ftest": AndTest(
            NumModels(1),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)'}, check_theory=True)),
            # Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)'}, check_theory=True)),
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
        "test": AndTest(NumModels(1), Assert(Exact(1), Equals({'include("root.a[0]")'}))),
        "program": """
            type("root","product").
            type("root.a[0]","A").
            index("root.a[0]",0).
            parent("root.a[0]","root").
            part("product").
            part("A").
            user_include("root.a[0]").""",
    },
    "set_invalid_variable": {
        "test": True_(),  # Output does not matter, tests whether Exception is raised
        "program": """
            user_value("root.color[0]","Yellow").""",
    },
    "add_invalid_variable": {
        "test": True_(),  # Output does not matter, tests whether Exception is raised
        "program": """
            user_include("root.basket[0]").""",
    },
    "set_invalid_type": {
        "test": True_(),  # Output does not matter, tests whether Exception is raised
        "program": """
            part("product").
            part("Basket").
            type("root.basket[0]","Basket").
            parent("root.basket[0]","root").
            index("root.basket[0]",0).
            user_value("root.basket[0]","Yellow").""",
    },
    "add_invalid_type": {
        "test": True_(),  # Output does not matter, tests whether Exception is raised
        "program": """
            part("product").
            discrete("Basket").
            type("root.basket[0]","Basket").
            parent("root.basket[0]","root").
            index("root.basket[0]",0).
            user_include("root.basket[0]").""",
    },
    "set_invalid_value_discrete": {
        "test": True_(),  # Output does not matter, tests whether Exception is raised
        "program": """
            part("product").
            discrete("Color").
            domain("Color","Red").
            type("root.color[0]","Color").
            parent("root.color[0]","root").
            index("root.color[0]",0).
            user_value("root.color[0]","Yellow").""",
    },
    "set_invalid_value_num": {
        "test": True_(),  # Output does not matter, tests whether Exception is raised
        "program": """
            part("product").
            integer("product.size").
            range("product.size",1,10).
            type("root.size[0]","product.size").
            parent("root.size[0]","root").
            index("root.size[0]",0).
            user_value("root.size[0]",11).""",
    },
}


TESTS_PREPROCESS = {
    "require_with_number": {
        "test": Assert(All(), ContainsTheory(('value("root.wheel[0].size[0]",27)'))),
        "ftest": Assert(All(), ContainsTheory('value("root.wheel[0].size[0]",27)', check_theory=True)),
        "files": ["require_with_number.lp"],
    },
    "require_with_number_ge": {
        "test": Assert(All(), ContainsTheory(('value("root.wheel[0].size[0]",28)'))),
        "ftest": Assert(All(), ContainsTheory('value("root.wheel[0].size[0]",28)', check_theory=True)),
        "files": ["require_with_number_ge.lp"],
    },
    "require_with_constant": {
        "test": Assert(All(), Contains(('value("root.wheel[0]","W28")'))),
        "files": ["require_with_constant.lp"],
    },
    "require_two_wheels": {
        "test": AndTest(
            Assert(
                Exact(1),
                SupersetOf({('value("root.frontWheel[0].size[0]",27)'), ('value("root.rearWheel[0].size[0]",27)')}),
            ),
            Assert(
                Exact(1),
                SupersetOf({('value("root.frontWheel[0].size[0]",28)'), ('value("root.rearWheel[0].size[0]",28)')}),
            ),
        ),
        "ftest": AndTest(
            Assert(
                Exact(1),
                SupersetOfTheory(
                    {('value("root.frontWheel[0].size[0]",27)'), ('value("root.rearWheel[0].size[0]",27)')},
                    check_theory=True,
                ),
            ),
            Assert(
                Exact(1),
                SupersetOfTheory(
                    {('value("root.frontWheel[0].size[0]",28)'), ('value("root.rearWheel[0].size[0]",28)')},
                    check_theory=True,
                ),
            ),
        ),
        "files": ["require_two_wheels.lp"],
    },
    "condition": {
        "test": Assert(
            All(), Implies(Contains('value("root.wheelSupport[0]","True")'), Contains('value("root.wheel[0]","Small")'))
        ),
        "files": ["condition.lp"],
    },
    "combination": {
        "test": AndTest(
            Assert(Any(), SupersetOf({'value("root.wheelSupport[0]","False")', 'value("root.wheel[0]","W20")'})),
            Assert(Any(), SupersetOf({'value("root.wheelSupport[0]","False")', 'value("root.wheel[0]","W18")'})),
            Assert(Any(), SupersetOf({'value("root.wheelSupport[0]","True")', 'value("root.wheel[0]","W16")'})),
            Assert(Any(), SupersetOf({'value("root.wheelSupport[0]","True")', 'value("root.wheel[0]","W14")'})),
            NumModels(4),
        ),
        "files": ["combination.lp"],
    },
    "enumeration": {
        "test": AndTest(
            Assert(Exact(1), Contains('value("root.color[0]","Red")')),
            Assert(Exact(1), Contains('value("root.color[0]","Green")')),
            Assert(Exact(1), Contains('value("root.color[0]","Blue")')),
            NumModels(3),
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","color","Color",1,1).

            coom_enumeration("Color").
            coom_option("Color", "Red").
            coom_option("Color", "Green").
            coom_option("Color", "Blue").""",
    },
    "bool_enumeration": {
        "test": AndTest(
            Assert(Exact(1), Contains('value("root.boolean[0]","True")')),
            Assert(Exact(1), Contains('value("root.boolean[0]","False")')),
            NumModels(2),
        ),
        "program": """
        coom_structure("product").
        coom_feature("product","boolean","bool",1,1).""",
    },
    "attribute": {
        "test": Assert(
            Exact(1), SupersetOfTheory({'value("root.wheel[0].size[0]",14)', 'value("root.wheel[0]","W14")'})
        ),
        "ftest": Assert(
            Exact(1),
            SupersetOfTheory({'value("root.wheel[0].size[0]",14)', 'value("root.wheel[0]","W14")'}, check_theory=True),
        ),
        "program": """
        coom_structure("product").
        coom_feature("product","wheel","Wheel",1,1).

        coom_enumeration("Wheel").
        coom_attribute("Wheel","size","num").
        coom_option("Wheel", "W14").
        coom_attribute_value("Wheel","W14","size",14).""",
    },
    "structure": {
        "test": AndTest(
            Assert(Exact(1), Contains('include("root.wheel[0]")')),
            NumModels(1),
        ),
        "program": """
        coom_structure("product").
        coom_feature("product","wheel","Wheel",1,1).
        coom_structure("Wheel").""",
    },
    "structure_optional": {
        "test": AndTest(
            Assert(Exact(1), Contains('include("root.basket[0]")')),
            NumModels(2),
        ),
        "program": """
        coom_structure("product").
        coom_feature("product","basket","Basket",0,1).
        coom_structure("Basket").""",
    },
    "structure_nested": {
        "test": AndTest(
            Assert(
                Exact(1),
                SupersetOf({'include("root.carrier[0]")', 'include("root.carrier[0].bag[0]")'}),
            ),
            NumModels(1),
        ),
        "program": """
        coom_structure("product").
        coom_feature("product","carrier","Carrier",1,1).
        coom_structure("Carrier").
        coom_feature("Carrier","bag","Bag",1,1).
        coom_structure("Bag").""",
    },
    "structure_nested_optional": {
        "test": AndTest(
            Assert(Exact(3), Contains('include("root.carrier[0]")')),
            Assert(Exact(2), Contains('include("root.carrier[0].bag[0]")')),
            Assert(
                Exact(1),
                SupersetOf(
                    {
                        'include("root.carrier[0]")',
                        'include("root.carrier[0].bag[0]")',
                        'include("root.carrier[0].bag[1]")',
                    }
                ),
            ),
            NumModels(4),
        ),
        "program": """
        coom_structure("product").
        coom_feature("product","carrier","Carrier",0,1).
        coom_structure("Carrier").
        coom_feature("Carrier","bag","Bag",0,2).
        coom_structure("Bag").""",
    },
    "require_with_partonomy": {
        "test": Assert(All(), Contains('value("root.basket[0].color[0]","Red")')),
        "files": ["require_with_partonomy.lp"],
    },
    "require_multiple_instances": {
        "test": Assert(
            All(), SupersetOf({'value("root.wheel[0].size[0]","W28")', 'value("root.wheel[1].size[0]","W28")'})
        ),
        "files": ["require_multiple_instances.lp"],
    },
    "require_with_partonomy2": {
        "test": Assert(
            All(), SupersetOf({'value("root.bag[0].color[0]","Red")', 'value("root.bag[1].color[0]","Red")'})
        ),
        "files": ["require_with_partonomy2.lp"],
    },
    "require_with_partonomy_multiple_instances": {
        "test": Assert(
            All(),
            SupersetOf(
                {
                    'value("root.compartment[0].bag[0].color[0]","Red")',
                    'value("root.compartment[0].bag[1].color[0]","Red")',
                    'value("root.compartment[1].bag[0].color[0]","Red")',
                    'value("root.compartment[1].bag[1].color[0]","Red")',
                }
            ),
        ),
        "files": ["require_with_partonomy_multiple_instances.lp"],
    },
    "combination_with_structure": {
        "test": AndTest(
            NumModels(8),
            Assert(
                All(),
                Implies(
                    Contains('value("root.wheelSupport[0]","True")'),
                    And(
                        Or(
                            Contains('value("root.wheel[0].size[0]","W14")'),
                            Contains('value("root.wheel[0].size[0]","W16")'),
                        ),
                        Or(
                            Contains('value("root.wheel[1].size[0]","W14")'),
                            Contains('value("root.wheel[1].size[0]","W16")'),
                        ),
                    ),
                ),
            ),
            Assert(
                All(),
                Implies(
                    Contains('value("root.wheelSupport[0]","False")'),
                    And(
                        Or(
                            Contains('value("root.wheel[0].size[0]","W18")'),
                            Contains('value("root.wheel[0].size[0]","W20")'),
                        ),
                        Or(
                            Contains('value("root.wheel[1].size[0]","W18")'),
                            Contains('value("root.wheel[1].size[0]","W20")'),
                        ),
                    ),
                ),
            ),
        ),
        "files": ["combination_with_structure.lp"],
    },
    "combination_at_part_with_wildcard": {
        "test": AndTest(
            NumModels(5),
            Assert(
                All(),
                Implies(
                    Contains('value("root.wheel[0].size[0]","W30")'),
                    SupersetOf(
                        {
                            'value("root.wheel[0].material[0]","Aluminum")',
                            'value("root.wheel[1].material[0]","Aluminum")',
                        }
                    ),
                ),
            ),
        ),
        "files": ["combination_at_part_with_wildcard.lp"],
    },
    "combination_at_part_multiple_instances": {
        "test": AndTest(
            NumModels(4),
            Assert(
                All(),
                Implies(
                    Contains('value("root.bike[0].material[0]","Carbon")'),
                    SupersetOf(
                        {
                            'value("root.bike[0].wheel[0]","W28")',
                            'value("root.bike[0].wheel[1]","W28")',
                        }
                    ),
                ),
            ),
            Assert(
                All(),
                Implies(
                    Contains('value("root.bike[0].material[0]","Aluminum")'),
                    SupersetOf(
                        {
                            'value("root.bike[0].wheel[0]","W30")',
                            'value("root.bike[0].wheel[1]","W30")',
                        }
                    ),
                ),
            ),
            Assert(
                All(),
                Implies(
                    Contains('value("root.bike[1].material[0]","Carbon")'),
                    SupersetOf(
                        {
                            'value("root.bike[1].wheel[0]","W28")',
                            'value("root.bike[1].wheel[1]","W28")',
                        }
                    ),
                ),
            ),
            Assert(
                All(),
                Implies(
                    Contains('value("root.bike[1].material[0]","Aluminum")'),
                    SupersetOf(
                        {
                            'value("root.bike[1].wheel[0]","W30")',
                            'value("root.bike[1].wheel[1]","W30")',
                        }
                    ),
                ),
            ),
        ),
        "files": ["combination_at_part_multiple_instances.lp"],
    },
    "simple_numeric_feature": {
        "test": AndTest(
            Assert(Exact(1), Contains('value("root.size[0]",1)')),
            Assert(Exact(1), Contains('value("root.size[0]",2)')),
            Assert(Exact(1), Contains('value("root.size[0]",3)')),
        ),
        "ftest": AndTest(
            Assert(Exact(1), ContainsTheory('value("root.size[0]",1)', check_theory=True)),
            Assert(Exact(1), ContainsTheory('value("root.size[0]",2)', check_theory=True)),
            Assert(Exact(1), ContainsTheory('value("root.size[0]",3)', check_theory=True)),
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","size","num",1,1).
            coom_range("product","size",1,3).""",
    },
    "simple_arithmetic_plus": {
        "test": AndTest(
            Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.b[0]",3)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.b[0]",4)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",2)', 'value("root.b[0]",3)'})),
        ),
        "ftest": AndTest(
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.b[0]",3)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.b[0]",4)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)', 'value("root.b[0]",3)'}, check_theory=True)),
        ),
        "files": ["simple_arithmetic_plus.lp"],
    },
    "simple_arithmetic_minus": {
        "test": AndTest(
            NumModels(1),
            Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.b[0]",4)'})),
        ),
        "ftest": AndTest(
            NumModels(1),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.b[0]",4)'}, check_theory=True)),
        ),
        "files": ["simple_arithmetic_minus.lp"],
    },
    "simple_arithmetic_multiplication": {
        "test": AndTest(
            NumModels(1),
            Assert(Exact(1), Equals({'value("root.a[0]",3)', 'value("root.b[0]",4)'})),
        ),
        "files": ["simple_arithmetic_multiplication.lp"],
    },
    "simple_arithmetic_plus_default_right": {
        "test": AndTest(
            Assert(Exact(1), Equals({'value("root.a[0]",2)'})),
        ),
        "ftest": AndTest(
            Assert(Exact(1), ContainsTheory('value("root.a[0]",2)', check_theory=True)),
        ),
        "files": ["simple_arithmetic_plus_default_right.lp"],
    },
    "simple_arithmetic_plus_default_left": {
        "test": AndTest(
            Assert(Exact(1), Equals({'value("root.b[0]",2)'})),
        ),
        "ftest": AndTest(
            Assert(Exact(1), ContainsTheory('value("root.b[0]",2)', check_theory=True)),
        ),
        "files": ["simple_arithmetic_plus_default_left.lp"],
    },
    "simple_arithmetic_minus_default_right": {
        "test": AndTest(
            Assert(Exact(1), Equals({'value("root.a[0]",2)'})),
        ),
        "ftest": AndTest(
            Assert(Exact(1), ContainsTheory('value("root.a[0]",2)', check_theory=True)),
        ),
        "files": ["simple_arithmetic_minus_default_right.lp"],
    },
    "simple_arithmetic_minus_default_left": {
        "test": AndTest(
            Assert(Exact(1), Equals({'value("root.b[0]",2)'})),
        ),
        "ftest": AndTest(
            Assert(Exact(1), ContainsTheory('value("root.b[0]",2)', check_theory=True)),
        ),
        "files": ["simple_arithmetic_minus_default_left.lp"],
    },
    "parentheses": {
        "test": AndTest(
            NumModels(2),
            Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.b[0]",1)'})),
            Assert(Exact(1), Equals({'value("root.a[0]",2)', 'value("root.b[0]",2)'})),
        ),
        "ftest": AndTest(
            NumModels(2),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.b[0]",1)'}, check_theory=True)),
            Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)', 'value("root.b[0]",2)'}, check_theory=True)),
        ),
        "files": ["parentheses.lp"],
    },
    "set_discrete": {
        "test": AndTest(NumModels(1), Assert(All(), Contains('value("root.color[0]","Yellow")'))),
        "program": """
            coom_structure("product").
            coom_feature("product","color","Color",1,1).
            coom_enumeration("Color").
            coom_option("Color","Red").
            coom_option("Color","Yellow").
            coom_user_value("root.color[0]","Yellow").""",
    },
    "set_num": {
        "test": AndTest(NumModels(1), Assert(All(), Contains('value("root.size[0]",5)'))),
        "program": """
            coom_structure("product").
            coom_feature("product","size","num",1,1).
            coom_range("product","size",1,10).
            coom_user_value("root.size[0]",5).""",
    },
    "add": {
        "test": AndTest(
            NumModels(2),
            Assert(All(), Contains('include("root.bag[0]")')),
            Assert(Exact(1), Contains('include("root.bag[1]")')),
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","bag","Bag",0,2).
            coom_structure("Bag").

            coom_user_include("root.bag[0]").""",
    },
    "add2": {
        "test": AndTest(
            NumModels(1),
            Assert(All(), Contains('include("root.bag[0]")')),
            Assert(All(), Contains('include("root.bag[1]")')),
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","bag","Bag",0,2).
            coom_structure("Bag").

            coom_user_include("root.bag[0]").
            coom_user_include("root.bag[1]").""",
    },
}
