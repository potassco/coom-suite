% Constraints cannot be violated
:- violated(C,ID).

% A formula is violated if it is defined and not satisfied
violated(C,F) :- constraint((C,F),"boolean"), defined(F), not satisfied(F).

% A table constraint is violated if a tuple of paths is defined but does not satisfy any of the rows
violated(C,ID) :- constraint(C,"table"), defined(C,ID), not hit_row(C,ID).

% A lower bound (cardinality) constraint is violated if less than the minimum number of objects are included
% (objects are included in ascending order of indices)
% (maximum does not need to be checked)
violated(X',P) :- constraint((P,Min),"lowerbound"), path(X,P), index(X,Min-1), not include(X), parent(X,X'), include(X').
