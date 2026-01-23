from typing import List, Set, Tuple

from clingo.symbol import Symbol

from navigation.navigator import Model


def print_models(models: List[Model]) -> None:
    for i, m in enumerate(models):
        print(f"Model {i+1}: {model_as_str(m)}")


def model_as_str(model: Model) -> str:
    atoms = []
    for a in model:
        atoms.append(str(a))
    atoms.sort()

    return "{" + ", ".join(atoms) + "}"


def assumptions_as_str(assumptions: Set[Tuple[Symbol, bool]]) -> str:
    assumptions_str = []
    for a, v in assumptions:
        assumptions_str.append(f"({a}, {v})")
    assumptions_str.sort()

    return "{" + ", ".join(assumptions_str) + "}"
