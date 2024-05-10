% Satisfaction of binary relations for numeric values in fclingo
binary_def(Formula) :- binary(Formula,X1,_,X2), &df{X1}, &df{X2}.

binary_sat(Formula) :- binary(Formula,X1,"=", X2), &sum{X1} =  X2.
binary_sat(Formula) :- binary(Formula,X1,"!=",X2), &sum{X1} != X2.
binary_sat(Formula) :- binary(Formula,X1,">", X2), &sum{X1} >  X2.
binary_sat(Formula) :- binary(Formula,X1,">=",X2), &sum{X1} >= X2.
binary_sat(Formula) :- binary(Formula,X1,"<", X2), &sum{X1} <  X2.
binary_sat(Formula) :- binary(Formula,X1,"<=",X2), &sum{X1} <= X2.


% Satisfaction of combinations tables for numeric values in fclingo
hit_cell(Constraint,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), combinations_instance(Constraint,ID,Col,X), &sum{X} = V, Constraint=(Idx,_).

combinations_def(Constraint,ID) :- combinations_instance(Constraint,ID,_,X), &df{X}.
