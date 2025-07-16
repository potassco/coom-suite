"""
The coomsuite project.
"""

from os.path import basename, join, splitext
from tempfile import NamedTemporaryFile
from typing import List, Optional

from antlr4 import FileStream
from clingo.application import clingo_main

from .application import COOMSolverApp
from .preprocess import check_user_input, preprocess
from .utils import run_antlr4_visitor
from .utils.logging import get_logger

log = get_logger("main")

SOLVERS = ["clingo", "fclingo"]


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


def solve(
    serialized_facts: List[str],
    solver: str,
    max_bound: int,
    clingo_args: List[str],
    output: str,
) -> int:
    """
    Preprocesses and solves a serialized COOM instance.
    """
    # Preprocess serialized ASP facts
    processed_facts = preprocess(
        serialized_facts,
        max_bound=max_bound,
        discrete=solver == "clingo",
    )
    check_user_input(processed_facts)

    with NamedTemporaryFile(mode="w", delete=False) as tmp:
        tmp_name = tmp.name
        tmp.write("".join(processed_facts))

    # Solve the ASP instance
    return clingo_main(
        COOMSolverApp(
            options={
                "solver": solver,
                "output_format": output,
            }
        ),
        [tmp_name] + clingo_args,
    )
