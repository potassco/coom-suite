#program incremental_constraint(cons,type,bound).
#external max_bound(bound).
constraint(cons,type).

violated(cons,bound) :- constraint(cons,type), defined(F,bound), not satisfied(F,bound), cons = (C,F), type = "boolean".

violated((cons,ID),bound) :- constraint(cons,type), defined(cons,ID), not satisfied(cons,ID), type = "table".

:- violated(C,bound), max_bound(bound).
% error(C,bound) :- violated(C,bound), max_bound(bound).
% #show error/2.
