% Generate structure object inclusion
{ include(X) : type(X,T), structure(T) }.

% Always include minimal number of objects
% include(X) :- feature(C,_,T,Min,_), type(X,T), index(X,I), I < Min,
%                parent(X,P), include(P), type(P,C).

% Do not include object without their parent included
:- include(X), type(X,_), parent(X,P), not include(P).

% Indices in ascending order for a feature
:- feature(_,F,T,_,_),    include(X),  type(X, T), feature(X, F), index(X, I), I > 0,
                      not include(X'), type(X',T), feature(X',F), index(X',I-1).

% Check cardinalities
:- feature(C,F,T,Min,Max), include(P), type(P,C),
    not include(X), parent(X,P), feature(X,F), index(X,Min-1).
    % include(X), parent(X,P), feature(X,F), index(X,Max+1).
%    not Min<=N<=Max, N = #count { X : include(X), parent(X,P), feature(X,F) }.

#show include(X) : include(X), type(X,T), structure(T), T != "product".
