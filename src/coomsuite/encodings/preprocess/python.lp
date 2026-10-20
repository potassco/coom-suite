% Python helper functions
#script (python)
from clingo import Function, Number, String, SymbolType, Tuple_
from functools import lru_cache

_ROOT = Function("", [])
_NOT = String("!")

@lru_cache(maxsize=None)
def fmt_dotpath(path):
    """
    Formats the internal dotpath representation.

    An object (F,(X,I)) is the I-th instance of feature F under parent X,
    so its path is the path of X extended by one component.
    """
    type_ = path.type
    if type_ is SymbolType.String or type_ is SymbolType.Number:
        return path
    if path == _ROOT:
        return String("root")
    feature, parent_index = path.arguments
    parent, index = parent_index.arguments
    return String(f"{fmt_dotpath(parent).string}.{feature.string}[{index.number}]")

@lru_cache(maxsize=None)
def fmt_binary(l,op,r):
    return String(f"{l.string}{op.string}{r.string}")

@lru_cache(maxsize=None)
def fmt_unary(f,op):
    if op.string == "()":
        return String(f"({f.string})")
    elif op.string in ["-","!","+"]:
        return String(f"{op.string}{f.string}")
    # elif op.string in ["sin","asin","cos","acos","tan","atan","exp","log","sqrt","abs","round","floor","ceil"]:
    #      return String(f"{op.string}({f.string})")
    else:
        return String(f"{op.string}({f.string})")

@lru_cache(maxsize=None)
def fmt_join(p1,p2):
    context = fmt_dotpath(p1).string
    if context == "":
        return p2
    else:
        return String(f"{context}.{p2.string}")

@lru_cache(maxsize=None)
def fmt_aggregate(f,c,p):
    joined = fmt_join(c,p).string
    return String(f"{f.string}({joined})")

@lru_cache(maxsize=None)
def fmt_implication(a,b):
    return String(f'{fmt_unary(a,_NOT).string}||{b.string}')

@lru_cache(maxsize=None)
def parse_dotpath(x):
    """
    Parses a dotpath string (as produced by fmt_dotpath) back into the internal representation.
    """
    path = Tuple_([])
    for p in x.string.split("."):
        if p == "root":
            continue
        open_bracket = p.find("[")
        name = String(p[:open_bracket])
        idx = Number(int(p[open_bracket+1:-1]))
        path = Tuple_([name,Tuple_([path,idx])])
    return path
#end.
