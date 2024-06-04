% Constraints cannot be violated
:- violated(C,ID).

% A formula is violated if it is defined and not satisfied
violated(C,F) :- constraint(C,F), defined(F), not satisfied(F).

% A table constraint is violated if a tuple of paths is defined but does not satisfy any of the rows
violated(C,ID) :- constraint(C), column(C,ID,_,_), defined(C,ID), not hit_row(C,ID).

% A cardinality is violated if not the minimum number of objects are included
% (objects are included in ascending order of indices)
% (maximum does not need to be checked)
violated(X,P) :- cardinality(X,P,Min), include(X), path(P,X'), not include(X'), index(X',Min-1).
