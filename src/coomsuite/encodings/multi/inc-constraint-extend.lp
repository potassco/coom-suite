% incremental table constraint for the jump grounding strategy
% all rows added in the gap (prev, cur] (identified by their table_bound/3 fact) are checked
% this generalizes the table constraint part of the stepwise incremental_constraint from a single bound
% to an arbitrary gap (boolean constraints are only checked at the max_bound and still use incremental_constraint)
#program incremental_constraint_extend(cons,type,prev,cur).
constraint(cons,type).

violated((cons,ID),B) :- constraint(cons,type), type = "table", table_bound(cons,ID,B), prev < B, B <= cur,
                         defined(cons,ID), not satisfied(cons,ID).

% violation of table constraints is checked for all active bounds
#external active(B) : B = prev+1..cur.
:- constraint(cons,type), type = "table", active(B), prev < B, B <= cur,
   violated((cons,ID),B), table_bound(cons,ID,B).
