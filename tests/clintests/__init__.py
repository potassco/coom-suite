"""
Contains custom clintest Tests
"""

from typing import Set, Union

from clingo import Symbol
from clingo.solving import Model
from clintest.assertion import Equals, False_, SubsetOf, SupersetOf, True_
from clintest.quantifier import All, Exact
from clintest.test import Assert, Test

TEST_EMPTY = Assert(All(), SubsetOf(set()))
TEST_UNSAT = Assert(Exact(0), False_())


def NumModels(n: int) -> Test:  # pylint: disable=invalid-name
    """
    clintest.Test for checking that a program has a certain number of models
    """
    return Assert(Exact(n), True_())


def SingleModelEquals(model: set[Symbol | str]) -> Test:  # pylint: disable=invalid-name
    """
    clintest.Test for checking that a program has a single model that is equal to the given argument

    Args:
        model (set[str]): The single model as a set of strings or clingo symbols
    """
    return Assert(All(), Equals(model))


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
