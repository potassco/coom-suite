#program incremental_constraint(cons,type,bound).
#external max_bound(bound).
constraint(cons,type).

violated(cons,bound) :- constraint(cons,type), defined(F,bound), not satisfied(F,bound), cons = (C,F), type = "boolean".

% TODO: can this be improved to only violation on the new elements is checked
% then it would be possilbe to use the add_constraint program part instead
% which would be more fitting for this type of constraint
violated((cons,ID),bound) :- constraint(cons,type), defined(cons,ID), not satisfied(cons,ID), type = "table".

:- violated(C,bound), max_bound(bound).
