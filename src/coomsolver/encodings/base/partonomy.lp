% Generate structure object inclusion
{ included(X) : type(X,T), structure(T) }.

% Always include minimal number of objects
% included(X) :- feature(C,_,T,Min,_), type(X,T), index(X,I), I < Min,
%                parent(X,P), included(P), type(P,C).

% Do not include object without their parent included
:- included(X), type(X,_), parent(X,P), not included(P).

% Indices in ascending order for a feature
:- feature(_,F,T,_,_),    included(X),  type(X, T), feature(X, F), index(X, I), I > 0,
                      not included(X'), type(X',T), feature(X',F), index(X',I-1).

% Check cardinalities
:- feature(C,F,T,Min,Max), included(P), type(P,C),
    not included(X), parent(X,P), feature(X,F), index(X,Min-1).
    % included(X), parent(X,P), feature(X,F), index(X,Max+1).
%    not Min<=N<=Max, N = #count { X : included(X), parent(X,P), feature(X,F) }.

#show included(X) : included(X), type(X,T), structure(T), T != "product".
