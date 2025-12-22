from typing import List, Set, Tuple

from clingo.symbol import Symbol

from navigation.navigator import Model


def print_models(models: List[Model]) -> None:
    for i, m in enumerate(models):
        print(f"Model {i+1}: {model_as_str(m)}")


def model_as_str(model: Model) -> str:
    ret = "{"
    for i, a in enumerate(model):
        if i > 0:
            ret += ", "
        ret += str(a)
    ret += "}"

    return ret


def assumptions_as_str(assumptions: Set[Tuple[Symbol, bool]]) -> str:
    ret = "{"
    for i, (a, v) in enumerate(assumptions):
        if i > 0:
            ret += ", "
        ret += f"({a}, {v})"
    ret += "}"

    return ret
