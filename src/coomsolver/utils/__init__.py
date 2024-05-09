"""
Utilities.
"""

from importlib.resources import as_file, files
from typing import List, Tuple

from antlr4 import CommonTokenStream, InputStream
from clingo import Symbol

from coomsolver.utils.parse_coom import ASPModelVisitor, ASPUserInputVisitor

from .coom_grammar.model.ModelLexer import ModelLexer
from .coom_grammar.model.ModelParser import ModelParser
from .coom_grammar.user_input.UserInputLexer import UserInputLexer
from .coom_grammar.user_input.UserInputParser import UserInputParser

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
    elif grammar == "user_input":
        lexer = UserInputLexer(coom_input_stream)
        stream = CommonTokenStream(lexer)
        parser = UserInputParser(stream)
        tree = parser.user_input()
        visitor = ASPUserInputVisitor()
        visitor.visitUser_input(tree)
    return visitor.output_asp


def _unpack_path(p: Symbol, l: List[Tuple[str, str]]) -> List[Tuple[str, str]]:
    """
    Recursively unpacks a nested path expression into a list of tuples.
    """
    if str(p) != "()":
        t = (p.arguments[0].name, str(p.arguments[1].arguments[1].number))
        l.insert(0, t)
        _unpack_path(p.arguments[1].arguments[0], l)
    return l


def format_sym_coom(s: Symbol) -> str:
    """
    Formats output symbols to a more readable COOM format.
    """
    if s.name == "instance":
        path = _unpack_path(s.arguments[0], [])
        return ".".join([f"{p[0]}[{p[1]}]" for p in path])
    if s.name == "val":
        path = _unpack_path(s.arguments[0], [])
        path_joined = ".".join([f"{p[0]}[{p[1]}]" for p in path])
        return f"{path_joined} = {str(s.arguments[1])}"
    raise ValueError(f"Unrecognized predicate: {s.name}")
