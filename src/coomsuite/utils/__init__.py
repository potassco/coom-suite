"""
Utilities.
"""

from contextlib import suppress
from importlib.resources import as_file, files
from typing import List

from antlr4 import CommonTokenStream, InputStream
from clingo import Symbol

from coomsuite.utils.parse_coom import ASPModelVisitor, ASPUserInputVisitor

from .coom_grammar.model.ModelLexer import ModelLexer
from .coom_grammar.model.ModelParser import ModelParser
from .coom_grammar.user.UserInputLexer import UserInputLexer
from .coom_grammar.user.UserInputParser import UserInputParser

# mypy: allow-untyped-calls


def get_encoding(file_name: str) -> str:  # nocoverage
    """Gets the path to a given ASP encoding in the encodings folder

    Args:
        file_name (str): The name of the ASP encoding with the extension

    Returns:
        str: The string for the path to the ASP encoding
    """
    with as_file(files("coomsuite") / "encodings" / file_name) as file:
        return str(file)


def run_antlr4_visitor(coom_input_stream: InputStream, grammar: str) -> List[str]:
    """Runs the ANTLR4 Visitor.

    Args:
        coom_input_stream (antlr4.InputStream): The input COOM encoding as a file stream

    Returns:
        List[str]: The converted ASP instance

    """
    if grammar == "model":
        lexer = ModelLexer(coom_input_stream)
        stream = CommonTokenStream(lexer)
        parser = ModelParser(stream)
        tree = parser.root()
        visitor = ASPModelVisitor()
        visitor.visitRoot(tree)
    elif grammar == "user":
        lexer = UserInputLexer(coom_input_stream)
        stream = CommonTokenStream(lexer)
        parser = UserInputParser(stream)
        tree = parser.user_input()
        visitor = ASPUserInputVisitor()
        visitor.visitUser_input(tree)
    return visitor.output_asp


def format_sym_coom(s: Symbol) -> str:
    """
    Formats output symbols to a more readable COOM format.
    """
    if s.name == "include":
        return s.arguments[0].string.removeprefix("root.")
    if s.name == "value":
        path = s.arguments[0].string.removeprefix("root.")
        value = s.arguments[1]
        return f"{path} = {value}"
    raise ValueError(f"Unrecognized predicate: {s.name}")


def sort_refined_facts(facts: List[str]) -> List[str]:
    """
    Sorts the refined facts in a human-readable order.
    """
    sorted_facts = []

    sorted_facts.append("% Parts of the model")
    parts = [f for f in facts if f.startswith("part")]
    sorted_facts.extend(sorted(parts))
    sorted_facts.append("")

    sorted_facts.append("% Attributes of the model")
    integer = [f for f in facts if f.startswith(("integer", "range"))]
    sorted_facts.extend(sorted(integer))
    sorted_facts.append("")

    discrete = [f for f in facts if f.startswith(("discrete", "domain"))]
    sorted_facts.extend(sorted(discrete))
    sorted_facts.append("")

    sorted_facts.append("% Complete instance tree")
    instances = [f for f in facts if f.startswith(("type", "parent", "index"))]
    sorted_facts.extend(reversed(sorted(instances)))
    sorted_facts.append("")

    sorted_facts.append("% Instantiated constraints")
    constraints = [f for f in facts if f.startswith(("explanation", "constraint", "imply"))]
    sorted_facts.extend(reversed(sorted(constraints)))
    sorted_facts.append("")

    formulas = [
        f
        for f in facts
        if f.startswith(
            (
                "binary",
                "unary",
                "function",
                "set",
                "number",
                "constant",
            )
        )
    ]
    sorted_facts.extend(reversed(sorted(formulas)))
    sorted_facts.append("")

    tables = [
        f
        for f in facts
        if f.startswith(
            (
                "column",
                "allow",
            )
        )
    ]
    sorted_facts.extend(reversed(sorted(tables)))
    sorted_facts.append("")

    sorted_facts.append("% User input")
    user_input = [f for f in facts if f.startswith(("user_include", "user_value"))]
    sorted_facts.extend(reversed(sorted(user_input)))
    sorted_facts.append("")

    return sorted_facts
