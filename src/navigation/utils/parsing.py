"""
Parsing utilities.
"""

import argparse
import shlex

from clingo.symbol import Symbol

from navigation.utils import as_symbol


def _parse_args(parser: argparse.ArgumentParser, arg: str):
    try:
        return parser.parse_args(shlex.split(arg))
    except SystemExit:
        return None


def _parse_known_args(parser: argparse.ArgumentParser, arg: str):
    try:
        return parser.parse_known_args(shlex.split(arg))
    except SystemExit:
        return None, None


def _parse_models(models: list[str] | None) -> list[set[Symbol]] | None:
    if not models:
        return None

    return [_parse_model_str(m) for m in models]


def _parse_model_str(model_str: str) -> set[Symbol]:
    model_str = model_str.strip()

    if not (model_str.startswith("{") and model_str.endswith("}")):
        raise ValueError(f"invalid model format: {model_str}")

    inner = model_str[1:-1].strip()
    if not inner:
        return set()

    atoms = []
    current = ""
    depth = 0

    for ch in inner:
        if ch == "," and depth == 0:
            atoms.append(current.strip())
            current = ""
            continue

        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1

        current += ch

    if current.strip():
        atoms.append(current.strip())

    return {as_symbol(a) for a in atoms}
