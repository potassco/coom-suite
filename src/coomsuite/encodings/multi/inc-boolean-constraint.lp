#program incremental_boolean_constraint(cons,type,bound).
constraint(cons,type).

% incremental boolean constraints
violated(cons,bound) :- constraint(cons,type), defined(F,bound), not satisfied(F,bound),
                        cons = (C,F), type = "boolean", max_bound(bound).

% violation is only checked at the current max_bound
#external max_bound(bound).
:- constraint(cons,type), type = "boolean", max_bound(bound),
   violated(cons,bound).
