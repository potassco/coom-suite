"""
Contains custom clintest Tests
"""

from typing import Set, Union

from clingo import Symbol
from clingo.solving import Model
from clintest.assertion import Equals, False_, SubsetOf, SupersetOf, True_
from clintest.quantifier import All, Exact
from clintest.test import And, Assert, Test

TEST_EMPTY = Assert(All(), SubsetOf(set()))
TEST_UNSAT = Assert(Exact(0), False_())


def NumModels(n: int) -> Test:  # pylint: disable=invalid-name
    """
    clintest.Test for checking that a program has a certain number of models
    """
    return Assert(Exact(n), True_())


def StableModels(*args: set[Symbol | str], fclingo: bool = False) -> Test:  # pylint: disable=invalid-name
    """
    clintest.Test for checking that a program has a certain set of stable models

    Args:
        args: The set of stable models as a set of sets of strings or clingo symbols
        fclingo (bool): Whether to prepare the test for use with the fclingo solver
    """
    if not fclingo:
        return And(NumModels(len(args)), *(Assert(Exact(1), Equals(a)) for a in args))
    else:
        return And(NumModels(len(args)), *(Assert(Exact(1), SupersetOfTheory(a, check_theory=True)) for a in args))


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
        return super().holds_for(model)  # nocoverage


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


# class ContainsTheory(Contains):
#     """
#     A clintest Contains assertion that can also check theory atoms.

#     Args:
#         symbol (Symbol): A clingo symbol.
#         check_theory (bool): Whether to include theory atoms in the check
#     """

#     def __init__(self, symbol: Union[Symbol, str], check_theory: bool = False) -> None:
#         super().__init__(symbol)
#         self.__symbol = self._Contains__symbol  # type: ignore # pylint: disable=no-member
#         self.__check_theory = check_theory

#     def holds_for(self, model: Model) -> bool:
#         if self.__check_theory:
#             return self.__symbol in model.symbols(shown=True, theory=True)
#         return super().holds_for(model)  # nocoverage
