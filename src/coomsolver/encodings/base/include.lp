% Always include root instance
include("root").

% Attribute variables are always included when its parents are included
% include(X) :- type(X,T), parent(X,P), include(P), attribute(T,_).

% Generate structure object inclusion
{ include(X) : type(X,T) }.

% Always include minimal number of objects (no optimizations)
% include(X) :- feature(C,_,T,Min,_), type(X,T), index(X,I), I < Min,
%                parent(X,P), include(P), type(P,C).

% Do not include an object if their parent is not included
:- include(X), type(X,_), parent(X,P), not include(P).

% Indices in ascending order
:- cardinality(_,P,_),    include(X),  path(P,X),  index(X, I), I > 0,
                      not include(X'), path(P,X'), index(X',I-1).
% :-  include(X),  type(X, T), name(X, N), index(X, I), I > 0,
% not include(X'), type(X',T), name(X',N), index(X',I-1).


% :- cardinality(X,P,Min), include(X), Min > #count{ X' : include(X'), path(P,X') }.

% :- cardinality(C,N,Min), include(P), type(P,C),
%     not include(X), parent(X,P), name(X,N), index(X,Min-1).
    % include(X), parent(X,P), feature(X,F), index(X,Max+1).
%    not Min<=N<=Max, N = #count { X : include(X), parent(X,P), feature(X,F) }.


#show include(X) : include(X), type(X,T), part(T).
