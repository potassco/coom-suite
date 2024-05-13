%%% Instantiate complete instance tree
aux_type((),"") :- structure("").

aux_type((Feature,(X,Idx)),Type) :- feature(Context,Feature,Type,_,Max), aux_type(X,Context), Idx = 0..Max-1.
aux_type((Attr,(X,0)),Attr) :- aux_type(X,Type), enumeration(Type), attr_value(Type,_,Attr,_).


%%% Instantiate paths
path_aux(X,Path) :- binary(Context,_,Path,_,_),      path(Path,0,_), aux_type(X,Context).
path_aux(X,Path) :- binary(Context,_,_,_,Path),      path(Path,0,_), aux_type(X,Context).
path_aux(X,Path) :- combinations(Constraint,_,Path), path(Path,0,_), aux_type(X,Context),
                                context(Constraint,Context).
path_aux(X,Path) :- function(Context,_,_,Path), path(Path,0,_), aux_type(X,Context).
path_aux(X,Path) :- imply((Context,_),_,Path),  path(Path,0,_), aux_type(X,Context).

path_instance(PathContext,Path,0,X)  :- path(Path,0,Name),
                                    path_aux(PathContext,Path), aux_type(X,_), X=(Name,(PathContext,_)).
path_instance(PathContext,Path,N,X') :- path(Path,N,Name),
                                    path_instance(PathContext,Path,N-1,X), aux_type(X',_), X'=(Name,(X,_)).

path_instance(PathContext,Path,X)    :- not path(Path,N+1,_), path_instance(PathContext,Path,N,X).

% Constants and numbers
path_instance(PathContext,Path,Path) :- binary(Type,_,_,_,Path), aux_type(PathContext,Type), constant(Path).
path_instance(PathContext,Path,Path) :- binary(Type,_,_,_,Path), aux_type(PathContext,Type), number(Path,_).
path_instance(PathContext,Path,Path) :- binary(Type,_,Path,_,_), aux_type(PathContext,Type), constant(Path).
path_instance(PathContext,Path,Path) :- binary(Type,_,Path,_,_), aux_type(PathContext,Type), number(Path,_).

% Constraint, binaries and combinations
behavior((Constraint,X)) :- behavior(Constraint), context(Constraint,Context), aux_type(X,Context).
binary_instance(X,Formula,X1,Op,X2) :- binary(Context,Formula,Left,Op,Right), aux_type(X,Context),
                                              path_instance(X,Left,X1), path_instance(X,Right,X2).


combinations_tuple((Constraint,Context),Col,(X,())) :- behavior((Constraint,Context)),
                                                        combinations(Constraint,Col,Path), not combinations(Constraint,Col+1,_),
                                                        path_instance(Context,Path,X).
combinations_tuple((Constraint,Context),Col,(X',X)) :- combinations_tuple((Constraint,Context),Col+1,X),
                                                        combinations(Constraint,Col,Path), Col >= 0,
                                                        path_instance(Context,Path,X').
combinations_tuple(Constraint,CT) :- combinations_tuple(Constraint,0,CT).

tuple_order(Constraint,CT,ID) :-  combinations_tuple(Constraint,CT), ID = #count{ CT': combinations_tuple(Constraint,CT'), CT'<CT }.

in_tuple((X,CT'),CT',X) :- combinations_tuple(_,CT), CT=(X,CT').
in_tuple(CT,CT',X)      :- in_tuple(CT,(X,CT'),_).
in_tuple(CT,X)          :- in_tuple(CT,_,X).


% Always include boolean enumeration
enumeration("bool").
option("bool", "True").
option("bool", "False").

%%% Output atoms
% Structure, enumeration and attribute instances
struct_type("","") :- structure("").
struct_type(@dotpath(Instance),Type) :- structure(Type), aux_type(Instance,Type).
index(@dotpath(Instance),Idx) :- structure(Type), aux_type(Instance,Type), Instance=((_,(_,Idx))).
enum_type(@dotpath(Instance),Type) :- enumeration(Type), aux_type(Instance,Type).
attr_enum(@dotpath((Attr,(Instance,0))),@dotpath(Instance)) :- aux_type((Attr,(Instance,0)),Attr).
attr_name(@dotpath((Attr,(Instance,0))),Attr) :- aux_type((Attr,(Instance,0)),Attr).
isnumeric(@dotpath((Attr,(Instance,0)))) :- aux_type((Attr,(Instance,0)),Attr), attr_value(Type,_,Attr,_), attribute(Type,Attr,"num").
num(@dotpath(Instance)) :- aux_type(Instance,"num").

parent(@dotpath(Instance),@dotpath(Parent))   :- aux_type(Instance,_), Instance=(_,(Parent,_)).
feature(@dotpath(Instance),Feature) :- aux_type(Instance,_), Instance=(Feature,(_,_)).

#show struct_type/2.
#show index/2.
#show enum_type/2.
#show attr_enum/2.
#show attr_name/2.
#show isnumeric/1.
#show parent/2.
#show feature/2.
#show num/1.

% Constraints
constraint((Constraint,@dotpath(Instance))) :- behavior((Constraint,Instance)).

require_instance((Constraint,@dotpath(Instance)),@binary(Left,Op,Right)) :- require(Constraint,Formula), binary_instance(Instance,Formula,Left,Op,Right).
condition_instance((Constraint,@dotpath(Instance)),@binary(Left,Op,Right)) :- condition(Constraint,Formula), binary_instance(Instance,Formula,Left,Op,Right).
binary(@binary(Left,Op,Right),@dotpath(Left),Op,@dotpath(Right)) :- binary_instance(Instance,Formula,Left,Op,Right).

combinations_instance((Constraint,@dotpath(Instance)),ID,Col,@dotpath(X)) :- combinations(Constraint,Col,Path), path_instance(Instance,Path,X), in_tuple(CT,X), tuple_order((Constraint,Instance),CT,ID).


#show constraint/1.
#show require_instance/2.
#show condition_instance/2.
#show binary/4.
#show combinations_instance/4.


%%% Pass through facts from COOM fact format
#show feature/5.
#show structure/1.
#show enumeration/1.
#show option/2.
#show attribute/3.
#show attr_value/4.
#show allow/3.
#show constant/1.
#show number/2.

#script (python)
from clingo import String, SymbolType
import math

def dotpath(path):
    if path.type in (SymbolType.String, SymbolType.Number):
        return path
    if str(path) == "()":
        return String("")
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
