#program new_column(c,id,col,x).
% A table constraint is defined if none of its columns are undefined
undefined(c,id) :- column(c,id,_,x), not include(x).
defined(c,id)   :- column(c,id,_,_), not undefined(c,id).

% A row of a table is not satisfied if any of its entries is not satisfied.
% Note that a table entry can contain multiple values.
% This is incompatible with fclingo (mixed check of values).
not_hit(c,id,Row) :- allow(Idx,(col,Row),_), column(c,id,col,x), c=(Idx,_), not value(x,V) : allow(Idx,(col,Row),V).

% A table constraint is satisfied if one of its rows is satisfied (not not satisfied)
satisfied(c,id) :- allow(Idx,(_,Row),_), column(c,id,_,_), c=(Idx,_), not not_hit(c,id,Row).

#program new_constraint(c,type).
% A table constraint is violated if is defined and not satisfied
violated((c,ID)) :- constraint(c,type), defined(c,ID), not satisfied(c,ID), type = "table".
