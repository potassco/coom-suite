"""
Utilities.
"""

import re
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


def asp2coom(s: Symbol) -> str:
    """
    Formats ASP output symbols to a more readable COOM format.
    """
    if s.name == "include":
        return s.arguments[0].string.removeprefix("root.")
    if s.name == "value":
        path = s.arguments[0].string.removeprefix("root.")
        value = s.arguments[1]
        return f"{path} = {value}"
    if s.name == "associate":
        print(s)
        paths = [o.string.removeprefix("root.") for o in s.arguments[0].arguments]
        name = s.arguments[1].string
        idx = s.arguments[2].number
        try:
            name2 = s.arguments[3].string
            idx2 = s.arguments[4].number
        except IndexError:
            return f"{paths[0]} -> {paths[1]} ({name},{idx})"
        return f"{paths[0]} <-> {paths[1]} ({name},{idx}) ({name2},{idx2})"
    raise ValueError(f"Unrecognized predicate: {s.name}")


def coom2asp(c: str) -> List[str]:
    """
    Converts COOM facts to ASP facts.
    """
    if "=" in c:
        path, value = c.split("=")
        return [f'value("root.{path.strip()}",{value.strip()})']
    path = c.strip()
    if "<->" in c:
        subbed = re.sub(r"[<>,\-()]", " ", c)
        subbed = re.sub(r"\s+", ";", subbed.strip())
        path1, path2, name1, idx1, name2, idx2 = subbed.split(";")
        return [
            f'associate(("root.{path1.strip()}","root.{path2.strip()}"),"{name1}",{idx1})',
            f'associate(("root.{path2.strip()}","root.{path1.strip()}"),"{name2}",{idx2})',
        ]
    if "->" in c:
        subbed = re.sub(r"[>,\-()]", " ", c)
        subbed = re.sub(r"\s+", ";", subbed.strip())
        path1, path2, name, idx = subbed.split(";")
        return [f'associate(("root.{path1.strip()}","root.{path2.strip()}"),"{name.strip()}",{idx.strip()})']
    return [f'include("root.{path}")']
