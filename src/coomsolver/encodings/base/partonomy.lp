% Generate structure objects
{ included(X) : structure_type(X,T) }.

% Always include minimal number of objects
included(X) :- feature(C,_,T,Min,_), structure_type(X,T), index(X,I), I < Min,
               parent(X,P), included(P), structure_type(P,C).

% No structure object without feature (really needed?)
:- included(X), structure_type(X,T), not feature(_,_,T,_,_), X != "root".

% No instances without their parent instantiated
:- included(X), structure_type(X,_), parent(X,P), not included(P).

% Indices in ascending order for a feature
:- feature(_,F,T,_,_),    included(X),  structure_type(X, T), feature(X, F), index(X, I), I > 0,
                      not included(X'), structure_type(X',T), feature(X',F), index(X',I-1).

% Check cardinalities
:- feature(C,F,T,Min,Max), included(P), structure_type(P,C),
   not Min<=N<=Max, N = #count { X : included(X), parent(X,P), feature(X,F) }.

#show included(X) : included(X), structure_type(X,_), X != "root".
