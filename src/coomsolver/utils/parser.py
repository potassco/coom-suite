"""
The command line parser for the project.
"""

import sys
from argparse import ArgumentParser
from textwrap import dedent
from typing import Any, Optional, cast

from . import COOM_PROFILES, SOLVERS, logging

__all__ = ["get_parser"]

if sys.version_info[1] < 8:
    import importlib_metadata as metadata  # nocoverage
else:
    from importlib import metadata  # nocoverage

VERSION = metadata.version("coomsolver")


def get_parser() -> ArgumentParser:
    """
    Return the parser for command line options.
    """
    parser = ArgumentParser(
        prog="coomsolver",
        description=dedent(
            """\
            coomsolver
            filldescription
            """
        ),
    )
    levels = [
        ("error", logging.ERROR),
        ("warning", logging.WARNING),
        ("info", logging.INFO),
        ("debug", logging.DEBUG),
    ]

    def get(levels: list[tuple[str, int]], name: str) -> Optional[int]:
        for key, val in levels:
            if key == name:
                return val
        return None  # nocoverage

    parser.add_argument(
        "--log",
        default="warning",
        choices=[val for _, val in levels],
        metavar=f'{{{",".join(key for key, _ in levels)}}}',
        help="set log level [%(default)s]",
        type=cast(Any, lambda name: get(levels, name)),
    )

    parser.add_argument("--version", "-v", action="version", version=f"%(prog)s {VERSION}")

    subparsers = parser.add_subparsers(help="Sub commands", dest="command")

    # -------------
    #  Instance parser
    # -------------
    parser_convert = subparsers.add_parser("convert", help="Convert COOM instance to ASP.")
    parser_convert.add_argument(
        "input",
        type=str,  # FileType('r', encoding='UTF-8'),
        help="Input the COOM file corresponding to the instance.",
        # metavar='',
    )
    parser_convert.add_argument(
        "--output",
        "-o",
        type=str,
        help="Path to output ASP file. Same directory as input by default.",
    )

    # -------------
    # Solve parser
    # -------------
    parser_solve = subparsers.add_parser(
        "solve",
        help="Converts and solves the COOM instance.",
    )
    parser_solve.add_argument(
        "input",
        type=str,  # FileType('r', encoding='UTF-8'),
        help="Path to the COOM file to solve.",
        # metavar='',
    )
    parser_solve.add_argument("--solver", type=str, help="Which solver to use.", choices=SOLVERS, default="clingo")

    parser_solve.add_argument(
        "--profile", type=str, help="Which COOM profile to use.", choices=COOM_PROFILES, default="travel"
    )

    return parser
