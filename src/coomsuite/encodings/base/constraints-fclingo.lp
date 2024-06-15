#include "clingo/violated.lp".
#include "clingo/boolean.lp".
#include "fclingo/formulas.lp".

% A row of a table is not satisfied if any of its entries is not satisfied.
% Note that a table entry can contain multiple values.
hit(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), column(C,ID,Col,X), C=(Idx,_), value(X,V).
hit(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), column(C,ID,Col,X), C=(Idx,_), &sum{X} = V.

not_hit(C,ID,Row)   :- allow(Idx,(Col,Row),_), column(C,ID,Col,_), C=(Idx,_), not hit(C,ID,(Col,Row)).
