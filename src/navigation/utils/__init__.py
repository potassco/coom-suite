"""
Some general utility functions.
"""

from clingo.symbol import Symbol, parse_term


def as_symbol(symbol: str | Symbol) -> Symbol:
    """
    Convert a symbol or string to a symbol.
    """
    if isinstance(symbol, str):
        symbol = parse_term(symbol)

    return symbol
