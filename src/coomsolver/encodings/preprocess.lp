%%% Instantiate complete instance tree
type((),"product") :- coom_structure("product").

% Create auxiliary predicate for every feature
type((Feat,(X,Idx)),Type) :- coom_feature(Ctx,Feat,Type,_,Max), type(X,Ctx), Idx = 0..Max-1.

% Create auxiliary prediate for attribute variables
type((Attr,(X,0)),Attr) :- type(X,Type), coom_enumeration(Type), coom_attribute_value(Type,_,Attr,_).


%%% Instantiate paths
path_start(X,Path) :- coom_binary(Ctx,_,Path,_,_), coom_path(Path,0,_), type(X,Ctx).
path_start(X,Path) :- coom_binary(Ctx,_,_,_,Path), coom_path(Path,0,_), type(X,Ctx).
path_start(X,Path) :- coom_combinations(C,_,Path), coom_path(Path,0,_), type(X,Ctx), coom_context(C,Ctx).
path_start(X,Path) :- coom_function(Ctx,_,_,Path), coom_path(Path,0,_), type(X,Ctx).
path_start(X,Path) :- coom_imply(Ctx,Path,_),      coom_path(Path,0,_), type(X,Ctx).

% Determine all grounded paths
path_to(PathCtx,Path,0,X)  :- coom_path(Path,0,Name),
                              path_start(PathCtx,Path), type(X,_), X=(Name,(PathCtx,_)).
path_to(PathCtx,Path,N,X') :- coom_path(Path,N,Name),
                              path_to(PathCtx,Path,N-1,X), type(X',_), X'=(Name,(X,_)).

path_to(PathCtx,Path,@dotpath(X)) :- not coom_path(Path,N+1,_), path_to(PathCtx,Path,N,X).

% Constants and numbers
path_to(PathCtx,Path,Path) :- coom_binary(Type,_,_,_,Path), type(PathCtx,Type), coom_constant(Path).
path_to(PathCtx,Path,Path) :- coom_binary(Type,_,Path,_,_), type(PathCtx,Type), coom_constant(Path).
path_to(PathCtx,Path,Path) :- coom_binary(Type,_,_,_,Path), type(PathCtx,Type), coom_number(Path,_).
path_to(PathCtx,Path,Path) :- coom_binary(Type,_,Path,_,_), type(PathCtx,Type), coom_number(Path,_).

% Instantiate constraints and binaries
behavior(C,X) :- coom_behavior(C), coom_context(C,Ctx), type(X,Ctx).

binary(X,Formula,@binary(X1,Op,X2),X1,Op,X2) :- coom_binary(Ctx,Formula,L,Op,R),
                                                type(X,Ctx), path_to(X,L,X1), path_to(X,R,X2).
binary(X,Formula,Grounded)  :- binary(X,Formula,Grounded,_,_,_).
path_to(X,Formula,Grounded) :- binary(X,Formula,Grounded).

% Instantiate functions
function(X,Function,Type,Path) :- coom_function(Ctx,Function,Type,Path), type(X,Ctx).
function_path(Ctx,Path,X)      :- function(Ctx,Function,_,Path), path_to(Ctx,Path,X).

% Auxiliary path for function
path_to(Ctx,Function,@function(Type,Ctx,Path)) :- function(Ctx,Function,Type,Path).

% Instantiate combinations
combinations_tuple((C,Ctx),Col,(X,())) :- behavior(C,Ctx),
                                          coom_combinations(C,Col,Path), not coom_combinations(C,Col+1,_),
                                          path_to(Ctx,Path,X).
combinations_tuple((C,Ctx),Col,(X',X)) :- combinations_tuple((C,Ctx),Col+1,X),
                                          coom_combinations(C,Col,Path), Col >= 0,
                                          path_to(Ctx,Path,X').
combinations_tuple(C,CT) :- combinations_tuple(C,0,CT).

tuple_order(C,CT,ID) :-  combinations_tuple(C,CT), ID = #count{ CT': combinations_tuple(C,CT'), CT'<CT }.

in_tuple((X,CT'),CT',X) :- combinations_tuple(_,CT), CT=(X,CT').
in_tuple(CT,CT',X)      :- in_tuple(CT,(X,CT'),_).
in_tuple(CT,X)          :- in_tuple(CT,_,X).

% Instantiate imply statement
imply(X,X',Formula) :- coom_imply(Ctx,Path,Formula), type(X,Ctx), path_to(X,Path,X').

% Always include boolean enumeration
coom_enumeration("bool").
coom_option("bool", "True").
coom_option("bool", "False").


%%% Output atoms
% Structure, enumeration and attribute instances
structure_type("root","product")   :- coom_structure("product").

structure_type(@dotpath(X),Type)   :- coom_structure(Type),   type(X,Type).
index(@dotpath(X),Idx)             :- coom_structure(Type),   type(X,Type), X=((_,(_,Idx))).
enumeration_type(@dotpath(X),Type) :- coom_enumeration(Type), type(X,Type).

attribute_enumeration(@dotpath((Attr,(X,0))),@dotpath(X)) :-    type((Attr,(X,0)),Attr).
attribute_name(@dotpath((Attr,(X,0))),Attr)               :-    type((Attr,(X,0)),Attr).
isnumeric(@dotpath((Attr,(X,0))))                         :-    type((Attr,(X,0)),Attr),
                                                                coom_attribute_value(Type,_,Attr,_),
                                                                coom_attribute(Type,Attr,"num").

num(@dotpath(X)) :- type(X,"num").

parent(@dotpath(X),@dotpath(Parent)) :- type(X,_), X=(_,(Parent,_)).
feature(@dotpath(X),Feat)            :- type(X,_), X=(Feat,(_,_)).

#show structure_type/2.
#show index/2.
#show enumeration_type/2.
#show attribute_enumeration/2.
#show attribute_name/2.
#show isnumeric/1.
#show parent/2.
#show feature/2.
#show num/1.

% Constraints
constraint((C,@dotpath(X))) :- behavior(C,X).

require((C,@dotpath(X)),Grounded)   :- coom_require(C,Formula),   binary(X,Formula,Grounded).
condition((C,@dotpath(X)),Grounded) :- coom_condition(C,Formula), binary(X,Formula,Grounded).
binary(Grounded,L,Op,R) :- binary(_,_,Grounded,L,Op,R).

combinations((C,@dotpath(X)),ID,Col,@dotpath(X')) :- coom_combinations(C,Col,Path), path_to(X,Path,X'), in_tuple(CT,X'), tuple_order((C,X),CT,ID).

function(@function(Type,Ctx,Path),Type,@join(Ctx,Path)) :- function(Ctx,_,Type,Path).

function_path(@join(Ctx,Path),@dotpath(X)) :- function_path(Ctx,Path,X).

imply(X',Grounded) :- imply(X,X',Formula), binary(X,Formula,Grounded).


#show constraint/1.
#show require/2.
#show condition/2.
#show binary/4.
#show combinations/4.
#show function/3.
#show function_path/2.
#show imply/2.

% Pass through facts from COOM fact format
feature(C,N,T,Min,Max)  :- coom_feature(C,N,T,Min,Max).
range(C,N,Min,Max)      :- coom_range(C,N,Min,Max).
structure(T)            :- coom_structure(T).
enumeration(T)          :- coom_enumeration(T).
option(T,O)             :- coom_option(T,O).
attribute(T,O,A)        :- coom_attribute(T,O,A).
attribute_value(T,O,A,V):- coom_attribute_value(T,O,A,V).
allow(C,XY,V)           :- coom_allow(C,XY,V).
constant(C)             :- coom_constant(C).
number(C,N)             :- coom_number(C,N).

#show feature/5.
#show range/4.
#show structure/1.
#show enumeration/1.
#show option/2.
#show attribute/3.
#show attribute_value/4.
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

#defined coom_structure/1.
#defined coom_feature/5.
#defined coom_range/4.
#defined coom_enumeration/1.
#defined coom_option/2.
#defined coom_attribute/3.
#defined coom_attribute_value/4.

#defined coom_behavior/1.
#defined coom_context/2.
#defined coom_require/2.
#defined coom_condition/2.
#defined coom_combinations/3.
#defined coom_allow/3.
#defined coom_binary/5.
#defined coom_path/3.
#defined coom_constant/1.
#defined coom_number/2.

#defined coom_function/4.
#defined coom_imply/3.
