"""
The coomsolver project.
"""

from os.path import basename, join, splitext
from typing import Optional

from antlr4 import FileStream

from .utils import run_antlr4_visitor
from .utils.logging import get_logger

log = get_logger("main")

SOLVERS = ["clingo", "fclingo"]


def convert_instance(coom_file: str, output_dir: Optional[str] = None) -> str:  # nocoverage
    """
    Converts a COOM instance into ASP
    Args:
        coom_file (str): COOM file .coom
        output_dir (str, optional): Name of the output directory, by default the same of coom_file is used
    """
    output_dir = "" if output_dir is None else output_dir
    filename = splitext(basename(coom_file))[0] + "-coom.lp"
    output_lp_file = join(output_dir, filename)

    input_stream = FileStream(coom_file, encoding="utf-8")
    asp_instance = run_antlr4_visitor(input_stream)
    asp_instance = [f"coom_{a}" if a != "" else a for a in asp_instance]

    with open(output_lp_file, "w", encoding="utf8") as f:
        f.write("\n".join(asp_instance))
        f.write("\n")
    log.info("ASP file saved in %s", output_lp_file)
    return output_lp_file
