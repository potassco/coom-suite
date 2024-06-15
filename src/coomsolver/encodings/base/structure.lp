% Always include root object
include("root").

% Generate include predicates for objects
{ include(X) : type(X,_) }.

% Always include minimal number of objects (no optimizations currently)
% include(X) :- feature(C,_,T,Min,_), type(X,T), index(X,I), I < Min,
%                parent(X,P), include(P), type(P,C).

% Do not include an object if their parent is not included
:- include(X), parent(X,P), not include(P).

% Indices in ascending order
:-  include(X),  path(P,X ), index(X, I), I > 0,
not include(X'), path(P,X'), index(X',I-1).

#show include(X) : include(X), type(X,T), part(T), X != "root".
