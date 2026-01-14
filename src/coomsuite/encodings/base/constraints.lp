% A lower bound (cardinality) constraint is violated if less than the minimum number of objects are included
% (objects are included in ascending order of indices)
% (maximum does not need to be checked)
violated((X',P)) :- constraint((P,Min),"lowerbound"), set(P,X), index(X,Min-1), not include(X), parent(X,X'), include(X').

% All-different constraints
violated((S,(X1,X2))) :- constraint(S,"alldiff"), set(S,X1), set(S,X2), X1 != X2, value(X1,V), value(X2,V).

% Define subsets for aggregates based on a satisfied condition
subset(A,S,C,X) :- set(S,X), condition(A,C), property((S,X),(C,F)), satisfied(F).

% Constraints cannot be violated
:- violated(C).
