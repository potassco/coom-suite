"""
The coomsuite project.
"""

from tempfile import NamedTemporaryFile
from typing import List, Optional, Tuple

from antlr4 import FileStream
from clingo.application import clingo_main

from .application import COOMSolverApp
from .preprocess import check_user_input, preprocess
from .utils import run_antlr4_visitor
from .utils.logging import get_logger

log = get_logger("main")

SOLVERS = ["clingo", "flingo"]


def write_facts(facts: str, outfile: str) -> None:  # nocoverage
    """
    Auxiilary function to write ASP facts to a file

    Args:
        facts (str): ASP facts
        outfile (str): Output file
    """
    with open(outfile, "w", encoding="utf8") as f:
        f.write("%%% serialized COOM facts \n")
        f.write(facts)
    log.info("ASP file saved in %s", outfile)


def convert_coom(coom_model: str, coom_user: Optional[str] = None) -> Tuple[str, bool]:  # nocoverage
    """
    Converts a COOM instance into ASP
    Args:
        coom_model (str): COOM model file .coom
        coom_user (str, optional): COOM user input file .coom
    """
    unbounded = False

    input_stream_model = FileStream(coom_model, encoding="utf-8")
    asp_instance = "\n".join(
        [f"coom_{a}" if a != "" else a for a in run_antlr4_visitor(input_stream_model, grammar="model")]
    )

    if "#sup" in asp_instance:
        unbounded = True
    if coom_user is not None:
        input_stream_user = FileStream(coom_user, encoding="utf-8")
        asp_instance += "\n".join(
            [f"coom_{a}" if a != "" else a for a in run_antlr4_visitor(input_stream_user, grammar="user")]
        )

    return asp_instance, unbounded


def solve(
    serialized_facts: List[str],
    solver: str,
    max_bound: int,
    clingo_args: List[str],
    output: str,
) -> int:  # nocoverage
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
