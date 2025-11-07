#program incremental_constraint(cons,type,bound).
constraint(cons,type).

% incremental boolean constraints
violated(cons,bound) :- constraint(cons,type), defined(F,bound), not satisfied(F,bound), cons = (C,F), type = "boolean".

% violation is only checked at the current max_bound
#external max_bound(bound).
:- constraint(cons,type), type = "boolean", max_bound(bound),
   violated(cons,bound).

% incremental table constraints
% - for table constraints the table IDs are associated with a specific bound
violated((cons,ID),bound) :- constraint(cons,type), table_bound(cons,ID,bound), defined(cons,ID), not satisfied(cons,ID), type = "table".
% - for bound 0 this association does not exist
violated((cons,ID),0) :- constraint(cons,type), defined(cons,ID), not satisfied(cons,ID), type = "table", bound = 0.

% violation of table constraints is checked for all active bounds
#external active(bound).
:- constraint(cons,type), type = "table", active(bound),
   violated((cons,ID),bound), table_bound(cons,ID,bound).
