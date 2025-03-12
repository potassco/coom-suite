% A lower bound (cardinality) constraint is violated if less than the minimum number of objects are included
% (objects are included in ascending order of indices)
% (maximum does not need to be checked)
violated(X',P) :- constraint((P,Min),"lowerbound"), set(P,X), index(X,Min-1), not include(X), parent(X,X'), include(X').

% Constraints cannot be violated
:- violated(C,ID).
