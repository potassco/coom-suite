#include "base/boolean.lp".

%%% Instantiate complete instance tree
aux_type((),"") :- structure("").

% Create auxiliary predicate for every feature
aux_type((Feat,(X,Idx)),Type) :- feature(Ctx,Feat,Type,_,Max), aux_type(X,Ctx), Idx = 0..Max-1.

% Create auxiliary prediate for attribute variables
aux_type((Attr,(X,0)),Attr) :- aux_type(X,Type), enumeration(Type), attr_value(Type,_,Attr,_).


%%% Instantiate paths
path_start(X,Path) :- binary(Ctx,_,Path,_,_), path(Path,0,_), aux_type(X,Ctx).
path_start(X,Path) :- binary(Ctx,_,_,_,Path), path(Path,0,_), aux_type(X,Ctx).
path_start(X,Path) :- combinations(C,_,Path), path(Path,0,_), aux_type(X,Ctx), context(C,Ctx).
path_start(X,Path) :- function(Ctx,_,_,Path), path(Path,0,_), aux_type(X,Ctx).
path_start(X,Path) :- imply(Ctx,Path,_),      path(Path,0,_), aux_type(X,Ctx).

% Determine all grounded paths
path_to(PathCtx,Path,0,X)  :- path(Path,0,Name),
                              path_start(PathCtx,Path), aux_type(X,_), X=(Name,(PathCtx,_)).
path_to(PathCtx,Path,N,X') :- path(Path,N,Name),
                              path_to(PathCtx,Path,N-1,X), aux_type(X',_), X'=(Name,(X,_)).

path_to(PathCtx,Path,@dotpath(X)) :- not path(Path,N+1,_), path_to(PathCtx,Path,N,X).

% Constants and numbers
path_to(PathCtx,Path,Path) :- binary(Type,_,_,_,Path), aux_type(PathCtx,Type), constant(Path).
path_to(PathCtx,Path,Path) :- binary(Type,_,Path,_,_), aux_type(PathCtx,Type), constant(Path).
path_to(PathCtx,Path,Path) :- binary(Type,_,_,_,Path), aux_type(PathCtx,Type), number(Path,_).
path_to(PathCtx,Path,Path) :- binary(Type,_,Path,_,_), aux_type(PathCtx,Type), number(Path,_).

% Instantiate constraints and binaries
behavior_instance(C,X) :- behavior(C), context(C,Ctx), aux_type(X,Ctx).

binary_instance(X,Formula,@binary(X1,Op,X2),X1,Op,X2) :- binary(Ctx,Formula,L,Op,R), aux_type(X,Ctx),
                                                         path_to(X,L,X1), path_to(X,R,X2).
binary_instance(X,Formula,Grounded) :- binary_instance(X,Formula,Grounded,_,_,_).
path_to(X,Formula,Grounded)         :- binary_instance(X,Formula,Grounded).

% Instantiate functions
function_aux(X,Function,Type,Path) :- function(Ctx,Function,Type,Path), aux_type(X,Ctx).
function_path(Ctx,Path,X)          :- function_aux(Ctx,Function,_,Path), path_to(Ctx,Path,X).

% Auxiliary path for function
path_to(Ctx,Function,@function(Type,Ctx,Path)) :- function_aux(Ctx,Function,Type,Path).

% Instantiate combinations
combinations_tuple((C,Ctx),Col,(X,())) :- behavior_instance(C,Ctx),
                                          combinations(C,Col,Path), not combinations(C,Col+1,_),
                                          path_to(Ctx,Path,X).
combinations_tuple((C,Ctx),Col,(X',X)) :- combinations_tuple((C,Ctx),Col+1,X),
                                          combinations(C,Col,Path), Col >= 0,
                                          path_to(Ctx,Path,X').
combinations_tuple(C,CT) :- combinations_tuple(C,0,CT).

tuple_order(C,CT,ID) :-  combinations_tuple(C,CT), ID = #count{ CT': combinations_tuple(C,CT'), CT'<CT }.

in_tuple((X,CT'),CT',X) :- combinations_tuple(_,CT), CT=(X,CT').
in_tuple(CT,CT',X)      :- in_tuple(CT,(X,CT'),_).
in_tuple(CT,X)          :- in_tuple(CT,_,X).

% Instantiate imply statement
imply_aux(X,X',Formula) :- imply(Ctx,Path,Formula), aux_type(X,Ctx), path_to(X,Path,X').

%%% Output atoms
% Structure, enumeration and attribute instances
struct_type("","") :- structure("").

struct_type(@dotpath(X),Type) :- structure(Type),   aux_type(X,Type).
index(@dotpath(X),Idx)        :- structure(Type),   aux_type(X,Type), X=((_,(_,Idx))).
enum_type(@dotpath(X),Type)   :- enumeration(Type), aux_type(X,Type).

attr_enum(@dotpath((Attr,(X,0))),@dotpath(X)) :-    aux_type((Attr,(X,0)),Attr).
attr_name(@dotpath((Attr,(X,0))),Attr)        :-    aux_type((Attr,(X,0)),Attr).
isnumeric(@dotpath((Attr,(X,0))))             :-    aux_type((Attr,(X,0)),Attr),
                                                    attr_value(Type,_,Attr,_), attribute(Type,Attr,"num").

num(@dotpath(X)) :- aux_type(X,"num").

parent(@dotpath(X),@dotpath(Parent)) :- aux_type(X,_), X=(_,(Parent,_)).
feature(@dotpath(X),Feat)         :- aux_type(X,_), X=(Feat,(_,_)).

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
constraint((C,@dotpath(X))) :- behavior_instance(C,X).

require_instance((C,@dotpath(X)),Grounded)   :- require(C,Formula),   binary_instance(X,Formula,Grounded).
condition_instance((C,@dotpath(X)),Grounded) :- condition(C,Formula), binary_instance(X,Formula,Grounded).
binary(Grounded,L,Op,R) :- binary_instance(_,_,Grounded,L,Op,R).

combinations_instance((C,@dotpath(X)),ID,Col,@dotpath(X')) :- combinations(C,Col,Path), path_to(X,Path,X'), in_tuple(CT,X'), tuple_order((C,X),CT,ID).

function_instance(@function(Type,Ctx,Path),Type,@join(Ctx,Path)) :- function_aux(Ctx,_,Type,Path).
function_path(@join(Ctx,Path),@dotpath(X)) :- function_path(Ctx,Path,X).

imply_instance(@join(X,X'),Grounded) :- imply_aux(X,X',Formula), binary_instance(X,Formula,Grounded).


#show constraint/1.
#show require_instance/2.
#show condition_instance/2.
#show binary/4.
#show combinations_instance/4.
#show function_instance/3.
#show function_path/2.
#show imply_instance/2.

% Pass through facts from COOM fact format
#show feature/5.
#show range/4.
#show structure/1.
#show enumeration/1.
#show option/2.
#show attribute/3.
#show attr_value/4.
#show allow/3.
#show constant/1.
#show number/2.

% Python helper functions
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
    return String(f"{l.string}{op.string}{r.string}")

def join(p1,p2):
    context = dotpath(p1).string
    if context == "":
        return p2
    else:
        return String(f"{context}.{p2.string}")

def function(f,c,p):
    joined = join(c,p).string
    return String(f"{f.string}({joined})")
#end.

#defined structure/1.
#defined feature/5.
#defined range/4.
#defined structure/1.
#defined enumeration/1.
#defined option/2.
#defined attribute/3.
#defined attr_value/4.

#defined behavior/1.
#defined context/2.
#defined require/2.
#defined condition/2.
#defined combinations/3.
#defined allow/3.
#defined binary/5.
#defined path/3.
#defined constant/1.
#defined number/2.

#defined function/4.
#defined imply/3.
