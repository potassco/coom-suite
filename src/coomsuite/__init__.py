"""
The coomsuite project.
"""

from os.path import basename, join, splitext
from typing import Optional

from antlr4 import FileStream

from .utils import run_antlr4_visitor
from .utils.logging import get_logger

log = get_logger("main")

SOLVERS = ["clingo", "flingo"]


def convert_instance(coom_file: str, grammar: str, outdir: Optional[str] = None) -> str:  # nocoverage
    """
    Converts a COOM instance into ASP
    Args:
        coom_file (str): COOM file .coom
        output_dir (str, optional): Name of the output directory, by default the same of coom_file is used
    """
    input_stream = FileStream(coom_file, encoding="utf-8")
    asp_instance = "\n".join([f"coom_{a}" if a != "" else a for a in run_antlr4_visitor(input_stream, grammar=grammar)])

    if outdir is not None:
        filename = splitext(basename(coom_file))[0] + "-coom.lp"
        output_lp_file = join(outdir, filename)

        with open(output_lp_file, "w", encoding="utf8") as f:
            if grammar == "model":
                f.write("%%% COOM model\n")
            elif grammar == "user":
                f.write("%%% User Input\n")

            f.write(asp_instance)
            f.write("\n")
        log.info("ASP file saved in %s", output_lp_file)
        return output_lp_file

    return asp_instance
