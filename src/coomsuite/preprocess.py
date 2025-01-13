from typing import List

from clingo import Control
from clingo.script import enable_python
from clingo.symbol import Symbol

from .utils import get_encoding


def preprocess(files: List[str], discrete: bool = True) -> List[str]:
    """
    Preprocesses COOM ASP facts into a "grounded" configuration fact format
    """
    # pylint: disable=not-context-manager
    input_files = files
    ctl = Control(message_limit=0)
    for f in input_files:
        ctl.load(f)

    # if self._options["preprocess"] or self._options["show_facts"]:
    enable_python()
    ctl.load(get_encoding("preprocess.lp"))
    # if self._options["solver"] == "clingo":
    if discrete:
        ctl.add("base", [], "discrete.")  # nocoverage

    ctl.ground()
    with ctl.solve(yield_=True) as handle:
        facts = [str(s) + "." for s in handle.model().symbols(shown=True)]

    return facts


def check_user_input(facts: str):
    """
    Checks if the user input is valid and returns a clingo.SolveResult
    """
    ctl = Control(message_limit=0)
    ctl.load(get_encoding("user-check.lp"))
    ctl.add("".join(facts))
    ctl.ground()
    with ctl.solve(yield_=True) as handle:
        unsat = [_parse_user_input_unsat(s) for s in handle.model().symbols(shown=True)]

    if unsat != []:
        error_msg = "User input not valid.\n" + "\n".join(unsat)
        raise ValueError(error_msg)


def _parse_user_input_unsat(unsat: Symbol) -> str:
    """
    Parses the unsat/2 predicates of the user input check
    """
    unsat_type = unsat.arguments[0].string
    info = unsat.arguments[1]

    if unsat_type == "not exists":
        variable = info.string
        msg = f"Variable {variable} is not valid."
    elif unsat_type == "not part":
        variable = info.string
        msg = f"Variable {variable} cannot be added."
    elif unsat_type == "not attribute":
        variable = info.string
        msg = f"No value can be set for variable {variable}."
    elif unsat_type == "outside domain":
        variable = info.arguments[0].string
        if str(info.arguments[1].type) == "SymbolType.Number":
            value = str(info.arguments[1].number)
        else:
            value = info.arguments[1].string
        msg = f"Value '{value}' is not in domain of variable {variable}."
    else:
        raise ValueError(f"Unknown unsat type: {unsat_type}")  # nocoverage
    return msg
