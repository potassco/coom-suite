% Generate structure object inclusion
% { included(X) : structure_type(X,T) }.
{ included(X) : type(X,T), structure(T) }.

% Always include minimal number of objects
% included(X) :- feature(C,_,T,Min,_), structure_type(X,T), index(X,I), I < Min,
%                parent(X,P), included(P), structure_type(P,C).
included(X) :- feature(C,_,T,Min,_), type(X,T), index(X,I), I < Min,
               parent(X,P), included(P), type(P,C).

% Do not include object without feature (really needed?)
% :- included(X), structure_type(X,T), not feature(_,_,T,_,_), X != "root".
% :- included(X), type(X,T), not feature(_,_,T,_,_), X != "root".

% Do not include object without their parent included
% :- included(X), structure_type(X,_), parent(X,P), not included(P).
:- included(X), type(X,_), parent(X,P), not included(P).

% Indices in ascending order for a feature
% :- feature(_,F,T,_,_),    included(X),  structure_type(X, T), feature(X, F), index(X, I), I > 0,
%                       not included(X'), structure_type(X',T), feature(X',F), index(X',I-1).
:- feature(_,F,T,_,_),    included(X),  type(X, T), feature(X, F), index(X, I), I > 0,
                      not included(X'), type(X',T), feature(X',F), index(X',I-1).

% Check cardinalities
% :- feature(C,F,T,Min,Max), included(P), structure_type(P,C),
%    not Min<=N<=Max, N = #count { X : included(X), parent(X,P), feature(X,F) }.
:- feature(C,F,T,Min,Max), included(P), type(P,C),
   not Min<=N<=Max, N = #count { X : included(X), parent(X,P), feature(X,F) }.

#show included(X) : included(X), type(X,T), structure(T), T != "product".
