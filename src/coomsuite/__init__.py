"""
The coomsuite project.
"""

from tempfile import NamedTemporaryFile

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
    Write ASP facts to a file.

    Args:
        facts (str): ASP facts
        outfile (str): Output file
    """
    with open(outfile, "w", encoding="utf8") as f:
        f.write("%%% serialized COOM facts \n")
        f.write(facts)
    log.info("ASP file saved in %s", outfile)


def convert_coom(coom_model: str, coom_user: str | None = None) -> tuple[str, bool, bool]:  # nocoverage
    """
    Convert a COOM instance into ASP.

    Args:
        coom_model (str): COOM model file .coom
        coom_user (str, optional): COOM user input file .coom
    """
    unbounded = False
    optimize = False

    input_stream_model = FileStream(coom_model, encoding="utf-8")
    asp_instance = "\n".join(
        [f"coom_{a}" if a != "" else a for a in run_antlr4_visitor(input_stream_model, grammar="model")]
    )

    if "#sup" in asp_instance:
        unbounded = True
    if "coom_minimize" in asp_instance or "coom_maximize" in asp_instance:
        optimize = True
    if coom_user is not None:
        input_stream_user = FileStream(coom_user, encoding="utf-8")
        asp_instance += "\n".join(
            [f"coom_{a}" if a != "" else a for a in run_antlr4_visitor(input_stream_user, grammar="user")]
        )

    return asp_instance, unbounded, optimize


def solve(
    serialized_facts: list[str],
    solver: str,
    max_bound: int,
    clingo_args: list[str],
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
