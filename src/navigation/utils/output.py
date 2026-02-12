"""
Output utilities.
"""

from clingo.solving import Model
from clingo.symbol import Symbol


def _model_as_str(model: Model) -> str:
    """Convert a model to its (sorted) string representation."""
    atoms = []
    for a in model:
        atoms.append(str(a))
    atoms.sort()

    return "{" + ", ".join(atoms) + "}"


def print_model(model: Model):
    print(_model_as_str(model))


def print_models(models: list[Model]):
    """Print a list of models."""
    if len(models) == 0:
        print("UNSAT")

    for i, m in enumerate(models):
        print(f"Model {i+1}: {_model_as_str(m)}")


def _weights_as_str(weights: tuple[int | float, int | float]):
    """Convert a pair of weights into a string."""
    return f"+={weights[0]:.2f} ; -={weights[1]:.2f}"


def print_weight(weight):
    print(_weights_as_str(weight))


def print_weighted_facets(weighted_facets: dict[Symbol, tuple[int, int] | tuple[float, float]]) -> None:
    """Print a dictionary containing facets and their weights."""
    for sym, weights in sorted(weighted_facets.items(), key=lambda item: sorted(item[1], reverse=True), reverse=True):
        print(f"{str(sym)}: {_weights_as_str(weights)}")


def print_assumptions(assumptions: set[tuple[Symbol, bool]]) -> None:
    """Print a set of assumptions."""
    assumptions_str = []
    for a, v in assumptions:
        assumptions_str.append(f"({a}, {v})")
    assumptions_str.sort()

    print("{" + ", ".join(assumptions_str) + "}")


def print_rules(rules):
    rules_str = []
    for r in rules:
        rules_str.append(f"{r}: {rules[r]}")
    rules_str.sort()

    print("{" + ", ".join(rules_str) + "}")
