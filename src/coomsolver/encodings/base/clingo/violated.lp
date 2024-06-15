% Constraints cannot be violated
:- violated(C,ID).

% A formula is violated if it is defined and not satisfied
violated(C,F) :- constraint((C,F),"boolean"), defined(F), not satisfied(F).

% A table constraint is violated if is defined and not satisfied
violated(C,ID) :- constraint(C,"table"), defined(C,ID), not satisfied(C,ID).

% A table constraint is satisfied if one of its rows is satisfied (not not satisfied)
satisfied(C,ID) :- allow(Idx,(_,Row),_), column(C,ID,_,_), C=(Idx,_), not not_hit(C,ID,Row).

% A table constraint is defined if none of its columns are undefined
undefined(C,ID) :- column(C,ID,_,X), not include(X).
defined(C,ID)   :- column(C,ID,_,_), not undefined(C,ID).

% A lower bound (cardinality) constraint is violated if less than the minimum number of objects are included
% (objects are included in ascending order of indices)
% (maximum does not need to be checked)
violated(X',P) :- constraint((P,Min),"lowerbound"), path(P,X), index(X,Min-1), not include(X), parent(X,X'), include(X').
