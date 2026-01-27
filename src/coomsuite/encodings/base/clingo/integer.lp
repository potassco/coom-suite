% Generate exactly one value for each integer attribute if it is included
{ value(X,V) : V = Min..Max } = 1 :- include(X), type(X,T), numeric(T,int), range(T,Min,Max).
{ value(X,V) : domain(T,V) } = 1  :- include(X), type(X,T), discrete(T,int).

% Include and assign values to auxiliary index variables
include(X) :- type(X,"_Index"), parent(X,P), include(P).
value(X,I) :- type(X,"_Index"), parent(X,P), include(P), index(P,I).
