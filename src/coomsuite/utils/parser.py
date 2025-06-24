"""
The command line parser for the project.
"""

import sys
from argparse import ArgumentParser
from textwrap import dedent
from typing import Any, Optional, cast

from coomsuite import SOLVERS

from . import logging

__all__ = ["get_parser"]

if sys.version_info[1] < 8:
    import importlib_metadata as metadata  # nocoverage
else:
    from importlib import metadata  # nocoverage

VERSION = metadata.version("coomsuite")


def get_parser() -> ArgumentParser:
    """
    Return the parser for command line options.
    """
    parser = ArgumentParser(
        prog="coomsuite",
        description=dedent("""\
            The COOM suite is a package providing functionality
            to parse and solve product configuration problems specified in COOM.
            """),
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

    parser.add_argument("--version",
                        "-v",
                        action="version",
                        version=f"%(prog)s {VERSION}")

    subparsers = parser.add_subparsers(help="Sub commands", dest="command")

    # -------------
    #  Instance parser
    # -------------
    parser_convert = subparsers.add_parser(
        "convert", help="Convert COOM instance to ASP.")
    parser_convert.add_argument(
        "input",
        type=str,
        help="""
        Input the COOM model file corresponding to the instance. Converted instance is printed to console by default.
        Specify output directory with '--output' to save .""",
    )
    parser_convert.add_argument(
        "--output",
        "-o",
        type=str,
        default=None,
        help="Path to output directory. (Optional)",
    )

    parser_convert.add_argument("--user-input",
                                "-u",
                                type=str,
                                help="Input the COOM user input.")
    # -------------
    # Solve parser
    # -------------
    parser_solve = subparsers.add_parser(
        "solve",
        help="Converts and solves the COOM instance",
    )
    parser_solve.add_argument(
        "input",
        type=str,
        help="Path to the COOM model file to solve",
    )
    parser_solve.add_argument("--user-input",
                              "-u",
                              type=str,
                              help="Input the COOM user input.")

    parser_solve.add_argument("--solver",
                              "-s",
                              type=str,
                              help="Set solver",
                              choices=SOLVERS,
                              default="clingo")

    parser_solve.add_argument("--output",
                              "-o",
                              type=str,
                              help="Set console output format",
                              choices=["asp", "coom"],
                              default="asp")
    parser_solve.add_argument("--show-facts",
                              action="store_true",
                              help="Show preprocessed fact format")
    parser_solve.add_argument(
        "--incremental-bounds",
        type=str,
        help="Incrementally increase the maximum for unbounded cardinalities.",
        choices=["linear", 'exponential'],
        default=None)
    return parser
