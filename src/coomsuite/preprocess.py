"""
Contains functions for preprocessing COOM ASP facts and checking user input
"""

from typing import List

from clingo import Control
from clingo.script import enable_python
from clingo.symbol import Symbol

from .utils import get_encoding
from .utils.logging import get_logger

log = get_logger("main")


def preprocess(
    files: List[str],
    max_bound: int = 0,
    discrete: bool = False,
    multishot: bool = False,
    object_bounds: bool = False,
) -> List[str]:  # pylint: disable=too-many-arguments,too-many-positional-arguments
    """
    Preprocesses COOM ASP facts into a "grounded" configuration fact format

    With object_bounds the bound at which every object becomes available is computed as well
    (only needed for multishot solving with jump grounding).
    """
    # pylint: disable=not-context-manager
    input_files = files
    ctl = Control(["-c", f"max_bound={max_bound}"], message_limit=0)
    for f in input_files:
        ctl.load(f)

    enable_python()
    if object_bounds:
        encoding = "preprocess-multishot-jump.lp"
    elif multishot:
        encoding = "preprocess-multishot.lp"
    else:
        encoding = "preprocess.lp"
    ctl.load(get_encoding(encoding))

    if discrete:
        ctl.add("base", [], "discrete.")  # nocoverage

    ctl.ground()
    with ctl.solve(yield_=True) as handle:
        facts = [str(s) + "." for s in handle.model().symbols(shown=True)]

    return facts


def check_user_input(facts: List[str]) -> None:
    """
    Checks if the user input is valid and returns a clingo.SolveResult
    """
    ctl = Control(message_limit=0)
    ctl.load(get_encoding("user-check.lp"))
    ctl.add("".join(facts))
    ctl.ground()
    with ctl.solve(yield_=True) as handle:
        warnings = [_parse_user_input_warnings(s) for s in handle.model().symbols(shown=True)]

    if warnings != []:
        msg = "Invalid user input.\n" + "\n".join(warnings)
        # raise ValueError(error_msg)
        # warn(msg)
        log.warning(msg)


def _parse_user_input_warnings(warning: Symbol) -> str:
    """
    Parses the warning/2 predicates of the user input check
    """
    warning_type = warning.arguments[0].string
    info = warning.arguments[1]

    match warning_type:
        case "not exists":
            variable = info.string
            return f'Variable "{variable}" does not exist.'
        # case "not part":
        #     variable = info.string
        #     return f"Variable {variable} cannot be added: Not a part."
        case "not attribute":
            variable = info.string
            return f'No value can be set for variable "{variable}". Variable exists but is a part.'
        case "outside domain":
            variable = info.arguments[0].string
            if str(info.arguments[1].type) == "SymbolType.Number":
                value = str(info.arguments[1].number)
            else:
                value = info.arguments[1].string
            return f'Value "{value}" is not in domain of variable "{variable}".'
        case _:  # nocoverage
            raise ValueError(f"Unknown warning type: {warning_type}")
