"""
Utilities.
"""

from importlib.resources import as_file, files
from typing import List

from antlr4 import CommonTokenStream, InputStream
from clingo import Symbol

from coomsolver.utils.parse_coom import ASPVisitor

from .coom_grammar.ModelLexer import ModelLexer
from .coom_grammar.ModelParser import ModelParser

# mypy: allow-untyped-calls


def get_encoding(file_name: str) -> str:  # nocoverage
    """Gets the path to a given ASP encoding in the encodings folder

    Args:
        file_name (str): The name of the ASP encoding with the extension

    Returns:
        str: The string for the path to the ASP encoding
    """
    with as_file(files("coomsolver") / "encodings" / file_name) as file:
        return str(file)


def run_antlr4_visitor(coom_input_stream: InputStream) -> List[str]:
    """Runs the ANTLR4 Visitor.

    Args:
        coom_input_stream (antlr4.InputStream): The input COOM encoding as a file stream

    Returns:
        List[str]: The converted ASP instance

    """
    lexer = ModelLexer(coom_input_stream)
    stream = CommonTokenStream(lexer)
    parser = ModelParser(stream)
    tree = parser.root()
    visitor = ASPVisitor()
    visitor.visitRoot(tree)
    return visitor.output_asp


def format_sym_coom(s: Symbol) -> str:
    """
    Formats output symbols to a more readable COOM format.
    """
    if s.name == "included":
        return s.arguments[0].string
    if s.name == "val":
        path = s.arguments[0].string
        value = s.arguments[1]
        return f"{path} = {value}"
    raise ValueError(f"Unrecognized predicate: {s.name}")
