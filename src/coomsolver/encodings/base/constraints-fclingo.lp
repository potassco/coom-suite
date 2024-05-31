#include "constraints.lp".

% Satisfaction of binary relations for numeric values in fclingo
defined(F) :- binary(F,X1,_,X2), &df{X1}, &df{X2}.

satisfied(F) :- binary(F,X1,"=", X2), &sum{X1} =  X2.
satisfied(F) :- binary(F,X1,"!=",X2), &sum{X1} != X2.
satisfied(F) :- binary(F,X1,">", X2), &sum{X1} >  X2.
satisfied(F) :- binary(F,X1,">=",X2), &sum{X1} >= X2.
satisfied(F) :- binary(F,X1,"<", X2), &sum{X1} <  X2.
satisfied(F) :- binary(F,X1,"<=",X2), &sum{X1} <= X2.


% Satisfaction of combinations tables for numeric values in fclingo
hit_cell(C,ID,(Col,Row)) :- allow(I,(Col,Row),V), column(C,ID,Col,X), &sum{X} = V, C=(I,_).

defined(C,ID,Col) :- column(C,ID,Col,X), &df{X}.
