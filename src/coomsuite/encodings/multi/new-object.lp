#program new_parent(name,parent).
parent(name,parent).

#program new_index(name,index).
index(name,index).

#program new_set(set,name).
set(set,name).

#program new_type(name,type,bound).
#external active(bound).

type(name,type).
bound(name,bound).

defined(name) :- value(name,_).

% an object can only be included if the bound is active
{ include(name) } :- active(bound).

:- include(name), parent(name,X), not include(X).

:-  include(name), set(P,name ), index(name,I), I > 0,
not include(X'  ), set(P,X'   ), index(X'  ,I-1), constraint((P,_),_).

% an object can be added after its successor (a user include of an unbounded feature is instantiated at bound 0)
:-  include(X'  ), set(P,X'   ), index(X'  ,I+1),
not include(name), set(P,name ), index(name,I), constraint((P,_),_), active(bound).

{ value(name,V) : domain(type,V) } = 1 :- include(name), type(name,type), discrete(type).

{ value(name,V) : V = Min..Max } = 1 :- include(name), type(name,type), integer(type), range(type,Min,Max).

% user values for objects added at later bounds (user includes are always instantiated at bound 0)
% the object is only included (and gets the value) if the bound is active
consistent(name,V) :- user_value(name,V), type(name,type), discrete(type), domain(type,V).
consistent(name,V) :- user_value(name,V), type(name,type), integer(type), range(type,Min,Max), Min <= V <= Max.
consistent(name,V) :- user_value(name,V), type(name,type), integer(type), not range(type,_,_).

include(name) :- user_value(name,V), consistent(name,V), active(bound).
value(name,V) :- user_value(name,V), consistent(name,V), active(bound).

#show include(name) : include(name), type(name,type), part(type).
#show value(name,V) : value(name,V), type(name,type), discrete(type).
#show value(name,V) : value(name,V), type(name,type), integer(type).
