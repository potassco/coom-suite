"""
The coomsolver project.
"""

# mypy: allow-untyped-calls

from typing import Optional

from antlr4 import CommonTokenStream, FileStream

from .utils.coom_grammar.ModelLexer import ModelLexer
from .utils.coom_grammar.ModelParser import ModelParser
from .utils.logging import get_logger
from .utils.parse_coom import ASPVisitor

log = get_logger("main")


def convert_instance(coom_file: str, output_lp_file: Optional[str] = None) -> None:  # nocoverage
    """
    Converts a COOM instance into ASP
    Args:
        coom_file (str): COOM file .coom
        output_lp_file (str, optional): Name of the output file, by default the same name of coom_file is used
    """

    if output_lp_file is None:
        lp_name = coom_file.replace(".coom", ".lp")
    else:
        lp_name = output_lp_file

    input_stream = FileStream(coom_file, encoding="utf-8")
    lexer = ModelLexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = ModelParser(stream)
    tree = parser.root()
    visitor = ASPVisitor()
    visitor.visitRoot(tree)
    instance = visitor.output_asp

    with open(lp_name, "w", encoding="utf8") as f:
        f.write("\n".join(instance))
    log.info("ASP file saved in %s", lp_name)
