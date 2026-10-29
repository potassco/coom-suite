#program incremental_constraint(cons,type,bound).
constraint(cons,type).

% incremental boolean constraints
% (incremental table constraints are handled by incremental_constraint_extend)
violated(cons,bound) :- constraint(cons,type), defined(F,bound), not satisfied(F,bound),
                        cons = (C,F), type = "boolean", max_bound(bound).

% violation is only checked at the current max_bound
#external max_bound(bound).
:- constraint(cons,type), type = "boolean", max_bound(bound),
   violated(cons,bound).
