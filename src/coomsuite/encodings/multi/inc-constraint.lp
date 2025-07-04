#program incremental_constraint(cons,type,bound).
#external max_bound(bound).
violated(cons,bound) :- constraint(cons,type), defined(F,bound), not satisfied(F,bound), cons = (C,F), type = "boolean".

:- violated(C,bound), max_bound(bound).
