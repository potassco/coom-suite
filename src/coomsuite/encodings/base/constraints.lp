#include "clingo/violated.lp".
#include "clingo/formulas.lp".

% A row of a table is not satisfied if any of its entries is not satisfied.
% Note that a table entry can contain multiple values.
% This is incompatible with fclingo (mixed check of values).
not_hit(C,ID,Row) :- allow(Idx,(Col,Row),_), column(C,ID,Col,X), C=(Idx,_), not value(X,V) : allow(Idx,(Col,Row),V).
