% incremental table constraints
% all rows added in the gap (prev, cur] (identified by their table_bound/3 fact) are checked
% the stepwise strategy uses the gap (bound-1, bound], the jump strategy the whole range of a jump
% (rows of bound 0 are part of the base program and checked there)
#program incremental_constraint_extend(cons,type,prev,cur).
constraint(cons,type).

violated((cons,ID),B) :- constraint(cons,type), type = "table", table_bound(cons,ID,B), prev < B, B <= cur,
                         defined(cons,ID), not satisfied(cons,ID).

% violation of table constraints is checked for all active bounds
#external active(B) : B = prev+1..cur.
:- constraint(cons,type), type = "table", active(B), prev < B, B <= cur,
   violated((cons,ID),B), table_bound(cons,ID,B).
