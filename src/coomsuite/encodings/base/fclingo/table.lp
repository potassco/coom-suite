% A table constraint is defined if none of its columns are undefined
undefined(C,ID) :- column(C,ID,_,X), not include(X).
defined(C,ID)   :- column(C,ID,_,_), not undefined(C,ID).

% A row of a table is not satisfied if any of its entries is not satisfied.
% Note that a table entry can contain multiple values.
hit(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), column(C,ID,Col,X), C=(Idx,_), value(X,V).
hit(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), column(C,ID,Col,X), C=(Idx,_), &sum{X} = V.

not_hit(C,ID,Row)   :- allow(Idx,(Col,Row),_), column(C,ID,Col,_), C=(Idx,_), not hit(C,ID,(Col,Row)).

% A table constraint is satisfied if one of its rows is satisfied (not not satisfied)
satisfied(C,ID) :- allow(Idx,(_,Row),_), column(C,ID,_,_), C=(Idx,_), not not_hit(C,ID,Row).

% A table constraint is violated if is defined and not satisfied
violated((C,ID)) :- constraint(C,"table"), defined(C,ID), not satisfied(C,ID).
