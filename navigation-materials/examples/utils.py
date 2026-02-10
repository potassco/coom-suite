"""
Some simple utility functions used in the example notebooks.
"""

from clingo.solving import Model
from clingo.symbol import Symbol


def print_models(models: list[Model]) -> None:
    """Print a list of models."""
    if len(models) == 0:
        print("UNSAT")

    for i, m in enumerate(models):
        print(f"Model {i+1}: {model_as_str(m)}")


def model_as_str(model: Model) -> str:
    """Convert a model to its (sorted) string representation."""
    atoms = []
    for a in model:
        atoms.append(str(a))
    atoms.sort()

    return "{" + ", ".join(atoms) + "}"


def assumptions_as_str(assumptions: set[tuple[Symbol, bool]]) -> str:
    """Convert a set of assumptions into a string."""
    assumptions_str = []
    for a, v in assumptions:
        assumptions_str.append(f"({a}, {v})")
    assumptions_str.sort()

    return "{" + ", ".join(assumptions_str) + "}"


def weights_as_str(weights: tuple[int | float, int | float]) -> None:
    """Convert a pair of weights into a string."""
    return f"+={weights[0]:.2f} ; -={weights[1]:.2f}"


def print_weighted_facets(weighted_facets: dict[Symbol, tuple[int, int] | tuple[float, float]]) -> None:
    """Print a dictionary containing facets and their weights."""
    for sym, weights in sorted(weighted_facets.items(), key=lambda item: sorted(item[1], reverse=True), reverse=True):
        print(f"{str(sym)}: {weights_as_str(weights)}")
