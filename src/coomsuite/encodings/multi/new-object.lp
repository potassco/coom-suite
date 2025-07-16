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

{ include(name) } :- active(bound).

:- include(name), parent(name,X), not include(X).

:-  include(name), set(P,name ), index(name,I), I > 0,
not include(X'  ), set(P,X'   ), index(X'  ,I-1), constraint((P,_),_).

{ value(name,V) : domain(type,V) } = 1 :- include(name), type(name,type), discrete(type).

{ value(name,V) : V = Min..Max } = 1 :- include(name), type(name,type), integer(type), range(type,Min,Max).

#show include(name) : include(name).
% #show value(name,V) : value(name,V).
#show value(X,V) : value(X,V), type(X,T), discrete(T).
#show value(X,V) : value(X,V), type(X,T), integer(T).
