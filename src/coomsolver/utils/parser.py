"""
The command line parser for the project.
"""

import sys
from argparse import ArgumentParser
from textwrap import dedent
from typing import Any, Optional, cast

from coomsolver import SOLVERS

from . import logging

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
        type=str,
        help="Input the COOM model file corresponding to the instance.",
    )
    parser_convert.add_argument(
        "--output",
        "-o",
        type=str,
        help="Path to output directory. Same directory as input by default.",
    )
    parser_convert.add_argument("--user-input", "-u", type=str, help="Input the COOM user input.")

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
    parser_solve.add_argument("--user_input", "-u", type=str, help="Input the COOM user input.")
    parser_solve.add_argument("--solver", "-s", type=str, help="Set solver", choices=SOLVERS, default="clingo")

    # parser_solve.add_argument(
    #     "--profile", "-p", type=str, help="Set COOM profile", choices=COOM_PROFILES, default="all"
    # )

    parser_solve.add_argument(
        "--output", "-o", type=str, help="Set console output format", choices=["asp", "coom"], default="asp"
    )
    parser_solve.add_argument("--show", action="store_true", help="Show preprocessed fact format")
    return parser
