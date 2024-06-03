% Always include root instance
include("root").

% Attribute variables are always included when its parents are included
include(X) :- type(X,T), parent(X,P), include(P), attribute(T,_).

% Generate structure object inclusion
{ include(X) : type(X,T), part(T) }.

% Always include minimal number of objects (no optimizations)
% include(X) :- feature(C,_,T,Min,_), type(X,T), index(X,I), I < Min,
%                parent(X,P), include(P), type(P,C).

% Do not include object without their parent included
:- include(X), type(X,_), parent(X,P), not include(P).

% Indices in ascending order for parts with same name
:-  include(X),  type(X, T), name(X, N), index(X, I), I > 0,
not include(X'), type(X',T), name(X',N), index(X',I-1).

% Check cardinalities
:- cardinality(C,N,Min,Max), include(P), type(P,C),
    not include(X), parent(X,P), name(X,N), index(X,Min-1).
    % include(X), parent(X,P), feature(X,F), index(X,Max+1).
%    not Min<=N<=Max, N = #count { X : include(X), parent(X,P), feature(X,F) }.

#show include(X) : include(X), type(X,T), part(T), T != "product".
