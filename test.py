from typing import List, Tuple

from clingo import Symbol


def _unpack_path(p: Symbol, l: List[Tuple[str]]) -> List[Tuple[str]]:
    """
    Recursively unpacks a nested path expression into one
    where the path names are separated with dots
    """
    # print("")
    # print(p)

    if str(p) != "()":
        t = (p.arguments[0].name, str(p.arguments[1].arguments[1].number))
        print(p)
        print(l)
        print(t)
        _unpack_path(p.arguments[1].arguments[0], l.insert(0, t))
    return l
