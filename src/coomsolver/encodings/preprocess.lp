%%% Instantiate complete instance tree
aux_instance((),":root") :- structure(":root").

aux_instance((Feature,(Instance,Idx)),Type) :- feature(Context,Feature,Type,_,Max), aux_instance(Instance,Context), Idx = 0..Max-1.
aux_instance((Attr,(Instance,0)),Attr) :- aux_instance(Instance,Type), enumeration(Type), attr_value(Type,_,Attr,_).


%%% Instantiate paths
path_aux(Instance,Path) :- binary(Context,_,Path,_,_),      path(Path,0,_), aux_instance(Instance,Context).
path_aux(Instance,Path) :- binary(Context,_,_,_,Path),      path(Path,0,_), aux_instance(Instance,Context).
path_aux(Instance,Path) :- combinations(Constraint,_,Path), path(Path,0,_), aux_instance(Instance,Context),
                                context(Constraint,Context).

path_instance(Instance,Path,0,X)  :- path(Path,0,Name),
                                     path_aux(Instance,Path), aux_instance(X,_), X=(Name,(Instance,_)).
path_instance(Instance,Path,N,X') :- path(Path,N,Name),
                                     path_instance(Instance,Path,N-1,X), aux_instance(X',_), X'=(Name,(X,_)).

path_instance(Instance,Path,X)    :- not path(Path,N+1,_), path_instance(Instance,Path,N,X).

% Constants and numbers
path_instance(Instance,Path,Path) :- binary(Context,_,_,_,Path), aux_instance(Instance,Context), constant(Path).
path_instance(Instance,Path,Path) :- binary(Context,_,_,_,Path), aux_instance(Instance,Context), number(Path,_).
path_instance(Instance,Path,Path) :- binary(Context,_,Path,_,_), aux_instance(Instance,Context), constant(Path).
path_instance(Instance,Path,Path) :- binary(Context,_,Path,_,_), aux_instance(Instance,Context), number(Path,_).


binary_instance(Instance,Formula,X1,Op,X2) :- binary(Context,Formula,Left,Op,Right), aux_instance(Instance,Context),
                                              path_instance(Instance,Left,X1), path_instance(Instance,Right,X2).


%%% Output atoms
% Structure, enumeration and attribute instances
structure_instance(":root",":root",0) :- structure(":root").
structure_instance(@dotpath(Instance),Type,Idx) :- structure(Type), aux_instance(Instance,Type), Instance=((_,(_,Idx))).
enumeration_instance(@dotpath(Instance),Type) :- enumeration(Type), aux_instance(Instance,Type).
attr_instance(@dotpath((Attr,(Instance,0))),@dotpath(Instance)) :- aux_instance((Attr,(Instance,0)),Attr), attr_value(Type,_,Attr,_).

parent(@dotpath(Instance),@dotpath(Parent))   :- aux_instance(Instance,_), Instance=(_,(Parent,_)).
feature(@dotpath(Instance),Feature) :- aux_instance(Instance,_), Instance=(Feature,(_,_)).

% #show structure_instance/3.
% #show enumeration_instance/2.
% #show attr_instance/2.
% #show parent/2.
% #show feature/2.

% Constraints
constraint((Constraint,Instance)) :- behavior(Constraint), context(Constraint,Context), aux_instance(Instance,Context).

require_instance((Constraint,@dotpath(Instance)),@binary(Left,Op,Right)) :- require(Constraint,Formula), binary_instance(Instance,Formula,Left,Op,Right).
condition_instance((Constraint,@dotpath(Instance)),@binary(Left,Op,Right)) :- condition(Constraint,Formula), binary_instance(Instance,Formula,Left,Op,Right).
binary(@binary(Left,Op,Right),@dotpath(Left),Op,@dotpath(Right)) :- binary_instance(Instance,Formula,Left,Op,Right).


combinations_instance((1,":root"),0,0,"wheelSupport[0]").
combinations_instance((1,":root"),0,1,"rearWheel[0]").


combinations(1,0,"wheelSupport").
combinations(1,1,"rearWheel").



% #show binary/4.
% #show require_instance/2.
% #show condition_instance/2.

% Pass through facts from COOM fact format
% #show feature/5.
% #show structure/1.
% #show enumeration/1.
% #show option/2.
% #show attribute/3.
% #show attr_value/4.
% #show allow/3.
% #show constant/1.
% #show number/2.

#script (python)
from clingo import String, SymbolType

def dotpath(path):
    if path.type in (SymbolType.String, SymbolType.Number):
        return path
    if str(path) == "()":
        return String(":root")
    path = unpack(path, [])
    return String(".".join([f"{p[0]}[{p[1]}]" for p in path]))

def unpack(p, l):
    """
    Recursively unpacks a nested path expression into a list of tuples.
    """
    if str(p) != "()":
        t = (p.arguments[0].name, str(p.arguments[1].arguments[1].number))
        l.insert(0, t)
        unpack(p.arguments[1].arguments[0], l)
    return l

def binary(l,op,r):
    return String(f"{dotpath(l).string}{op.string}{dotpath(r).string}")
#end.
