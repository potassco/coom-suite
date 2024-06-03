#include "../clingo/binary.lp".

% Satisfaction of binary relations for numeric values in fclingo
defined(F) :- binary(F,X1,_,X2), &df{X1}, &df{X2}.

satisfied(F) :- binary(F,X1,"=", X2), &sum{X1} =  X2.
satisfied(F) :- binary(F,X1,"!=",X2), &sum{X1} != X2.
satisfied(F) :- binary(F,X1,">", X2), &sum{X1} >  X2.
satisfied(F) :- binary(F,X1,">=",X2), &sum{X1} >= X2.
satisfied(F) :- binary(F,X1,"<", X2), &sum{X1} <  X2.
satisfied(F) :- binary(F,X1,"<=",X2), &sum{X1} <= X2.
