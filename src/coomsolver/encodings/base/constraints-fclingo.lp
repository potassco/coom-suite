#include "constraints.lp".

% Satisfaction of binary relations for numeric values in fclingo
binary_def(Formula) :- binary(Formula,X1,_,X2), &df{X1}, &df{X2}.

binary_sat(Formula) :- binary(Formula,X1,"=", X2), &sum{X1} =  X2.
binary_sat(Formula) :- binary(Formula,X1,"!=",X2), &sum{X1} != X2.
binary_sat(Formula) :- binary(Formula,X1,">", X2), &sum{X1} >  X2.
binary_sat(Formula) :- binary(Formula,X1,">=",X2), &sum{X1} >= X2.
binary_sat(Formula) :- binary(Formula,X1,"<", X2), &sum{X1} <  X2.
binary_sat(Formula) :- binary(Formula,X1,"<=",X2), &sum{X1} <= X2.


% Satisfaction of combinations tables for numeric values in fclingo
hit_cell(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), combinations_instance(C,ID,Col,X), &sum{X} = V, C=(Idx,_).

combinations_def(C,ID,Col) :- combinations_instance(C,ID,Col,X), &df{X}.
