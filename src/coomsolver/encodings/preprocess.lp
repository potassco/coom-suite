%%% Instantiate complete instance tree

% Root is always included
type_aux((),"product") :- coom_structure("product").

% Create auxiliary predicate for every feature
type_aux((F,(X,I)),T) :- coom_feature(C,F,T,_,Max), type_aux(X,C), I = 0..Max-1.

% Create auxiliary prediate for attribute variables
type_aux((A,(X,0)),A) :- type_aux(X,T), coom_enumeration(T), coom_attribute_value(T,_,A,_).


%%% Constraints

% Instantiate constraints for each path
behavior(C,X) :- coom_behavior(C), coom_context(C,Ctx), type_aux(X,Ctx).

% Get binary context
binary_context(F,Ctx) :- coom_binary(F,_,_,_), coom_require(C,F),   coom_context(C,Ctx).
binary_context(F,Ctx) :- coom_binary(F,_,_,_), coom_condition(C,F), coom_context(C,Ctx).
binary_context(F,Ctx) :- coom_binary(F,_,_,_), coom_imply(Ctx,_,F).

binary_context(L,Ctx)  :- coom_binary(L,_,_,_), coom_binary(F,L,_,_), binary_context(F,Ctx).
binary_context(R,Ctx)  :- coom_binary(R,_,_,_), coom_binary(F,_,_,R), binary_context(F,Ctx).

% Instantiate paths
path_start(X,P) :- coom_binary(F,P,_,_),     coom_path(P,0,_), type_aux(X,Ctx), binary_context(F,Ctx).
path_start(X,P) :- coom_binary(F,_,_,P),     coom_path(P,0,_), type_aux(X,Ctx), binary_context(F,Ctx).
path_start(X,P) :- coom_combinations(C,_,P), coom_path(P,0,_), type_aux(X,Ctx), coom_context(C,Ctx).
path_start(X,P) :- coom_function(Ctx,_,_,P), coom_path(P,0,_), type_aux(X,Ctx).
path_start(X,P) :- coom_imply(Ctx,P,_),      coom_path(P,0,_), type_aux(X,Ctx).

% Determine all ground paths
path_to(X,P,0,X')  :- coom_path(P,0,N),
                      path_start(X,P),     type_aux(X',_),  X' =(N,(X,_)).
path_to(X,P,I,X'') :- coom_path(P,I,N),
                      path_to(X,P,I-1,X'), type_aux(X'',_), X''=(N,(X',_)).

path_to(X,P,@dotpath(X')) :- not coom_path(P,I+1,_), path_to(X,P,I,X').

% Constants and numbers
path_to(X,P,P) :- coom_binary(F,_,_,P), coom_constant(P), binary_context(F,T), type_aux(X,T).
path_to(X,P,P) :- coom_binary(F,P,_,_), coom_constant(P), binary_context(F,T), type_aux(X,T).
path_to(X,P,P) :- coom_binary(F,_,_,P), coom_number(P,_), binary_context(F,T), type_aux(X,T).
path_to(X,P,P) :- coom_binary(F,P,_,_), coom_number(P,_), binary_context(F,T), type_aux(X,T).

% Instantiate binaries
binary(X,F,@binary(XL,Op,XR),XL,Op,XR) :- coom_binary(F,L,Op,R),
                                          binary_context(F,C),
                                          type_aux(X,C), path_to(X,L,XL), path_to(X,R,XR).
binary(X,F,G)  :- binary(X,F,G,_,_,_).

% Auxiliary paths for arithmetic binary evaluation
path_to(X,F,G) :- binary(X,F,G).

% Instantiate functions
function(X,F,T,P)    :- coom_function(C,F,T,P), type_aux(X,C).
function_path(C,P,X) :- function(C,F,_,P), path_to(C,P,X).

% Auxiliary path for function
path_to(C,F,@function(T,C,P)) :- function(C,F,T,P).

% Instantiate combinations
combinations_tuple((C,Ctx),Col,(X,())) :- behavior(C,Ctx),
                                          coom_combinations(C,Col,P), not coom_combinations(C,Col+1,_),
                                          path_to(Ctx,P,X).
combinations_tuple((C,Ctx),Col,(X',X)) :- combinations_tuple((C,Ctx),Col+1,X),
                                          coom_combinations(C,Col,P), Col >= 0,
                                          path_to(Ctx,P,X').
combinations_tuple(C,CT) :- combinations_tuple(C,0,CT).

tuple_order(C,CT,ID) :-  combinations_tuple(C,CT), ID = #count{ CT': combinations_tuple(C,CT'), CT'<CT }.

in_tuple((X,CT'),CT',X) :- combinations_tuple(_,CT), CT=(X,CT').
in_tuple(CT,CT',X)      :- in_tuple(CT,(X,CT'),_).
in_tuple(CT,X)          :- in_tuple(CT,_,X).

% Instantiate imply statement
imply(X,X',F) :- coom_imply(Ctx,P,F), type_aux(X,Ctx), path_to(X,P,X').

% Always include boolean enumeration
coom_enumeration("bool").
coom_option("bool", "True").
coom_option("bool", "False").


%%% Output atoms

% Structure, enumeration and attribute instances
type("root","product") :- coom_structure("product").

type(@dotpath(X),T)    :- type_aux(X,T).
index(@dotpath(X),Idx) :- type_aux(X,T), coom_structure(T), X=((_,(_,Idx))).

parent(@dotpath(X),@dotpath(P)) :- type_aux(X,_), X=(_,(P,_)).
feature(@dotpath(X),F)          :- type_aux(X,_), X=(F,(_,_)).

isnumeric(@dotpath((A,(X,0))))  :- type_aux((A,(X,0)),A),
                                   coom_attribute_value(T,_,A,_),
                                   coom_attribute(T,A,"num").

#show type/2.
#show index/2.
#show parent/2.
#show feature/2.
#show isnumeric/1.

% Constraints
constraint((C,@dotpath(X))) :- behavior(C,X).

require((C,@dotpath(X)),G)   :- coom_require(C,F),   binary(X,F,G).
condition((C,@dotpath(X)),G) :- coom_condition(C,F), binary(X,F,G).
condition(C)                 :- coom_condition(C,_).
binary(G,L,Op,R) :- binary(_,_,G,L,Op,R).

combinations((C,@dotpath(X)),ID,Col,@dotpath(X')) :- coom_combinations(C,Col,P),
                                                     path_to(X,P,X'), in_tuple(CT,X'), tuple_order((C,X),CT,ID).

function(@function(T,C,P),T,@join(C,P)) :- function(C,_,T,P).

function_path(@join(C,P),@dotpath(X)) :- function_path(C,P,X).

imply(X',G) :- imply(X,X',F), binary(X,F,G).


#show constraint/1.
#show require/2.
#show condition/2.
#show condition/1.
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
#defined coom_binary/4.
#defined coom_path/3.
#defined coom_constant/1.
#defined coom_number/2.

#defined coom_function/4.
#defined coom_imply/3.
