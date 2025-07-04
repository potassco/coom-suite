#program new_object(name,type,parent,index,set,bound).
#external active(bound).

type(name,type).
parent(name,parent).
index(name,index).
set(set,name).

defined(name) :- value(name,_).

{ include(name) } :- active(bound).

:- include(name), parent(name,parent), not include(parent).

:-  include(name), set(set,name ), index(name,index  ), index > 0,
not include(X'  ), set(set,X'   ), index(X'  ,index-1), constraint((set,_),_).

{ value(name,V) : domain(type,V) } = 1 :- include(name), type(name,type), discrete(type).

{ value(name,V) : V = Min..Max } = 1 :- include(name), type(name,type), integer(type), range(type,Min,Max).
