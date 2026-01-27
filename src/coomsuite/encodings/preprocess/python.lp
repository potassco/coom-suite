% Python helper functions
#script (python)
from clingo import Number,String, SymbolType
import math

def dotpath(path):
    if path.type in (SymbolType.String, SymbolType.Number):
        return path
    path = unpack(path, [])
    return String(".".join(["root"]+[f"{p[0]}[{p[1]}]" for p in path]))

def unpack(p, l):
    """
    Recursively unpacks a nested path expression into a list of tuples.
    """
    if str(p) != "()":
        t = (p.arguments[0].string, str(p.arguments[1].arguments[1].number))
        l.insert(0, t)
        unpack(p.arguments[1].arguments[0], l)
    return l

def binary(l,op,r):
    return String(f"{l.string}{op.string}{r.string}")

def unary(f,op):
    if op.string == "()":
        return String(f"({f.string})")
    elif op.string in ["-","!","+"]:
        return String(f"{op.string}{f.string}")
    # elif op.string in ["sin","asin","cos","acos","tan","atan","exp","log","sqrt","abs","round","floor","ceil"]:
    #      return String(f"{op.string}({f.string})")
    else:
        return String(f"{op.string}({f.string})")

def join(p1,p2):
    context = dotpath(p1).string
    if context == "":
        return p2
    else:
        return String(f"{context}.{p2.string}")

def join_comprehension(p1,p2):
    remove_var = p2.string.split(".")[1:]
    # if "root" not in p1.string:
    return String(".".join([p1.string]+remove_var))
    # return String(".".join(remove_var))

def aggregate(f,ctx,p,val=None,var=None,c=None):
    joined = join(ctx,p).string
    if c is not None:
        return String(f"{f.string}({val.string} for {var.string} in {joined} if {c.string})")
    return String(f"{f.string}({joined})")

def implication(a,b):
    return String(f'{unary(a,String("!")).string}||{b.string}')

def number(s):
    return Number(int(s.string))
#end.
