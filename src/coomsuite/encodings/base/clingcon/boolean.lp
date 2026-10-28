% Satisfaction of binary comparison relations for numeric values in flingo
clingcon_var(X) :- type(X,T), integer(T).

satisfied(F) :- binary(F,X1,"=", X2), clingcon_var(X1), clingcon_var(X2), &sum{X1} =  X2.
satisfied(F) :- binary(F,X1,"!=",X2), clingcon_var(X1), clingcon_var(X2), not &sum{X1} = X2.
satisfied(F) :- binary(F,X1,">", X2), clingcon_var(X1), clingcon_var(X2), &sum{X1} >  X2.
satisfied(F) :- binary(F,X1,">=",X2), clingcon_var(X1), clingcon_var(X2), &sum{X1} >= X2.
satisfied(F) :- binary(F,X1,"<", X2), clingcon_var(X1), clingcon_var(X2), &sum{X1} <  X2.
satisfied(F) :- binary(F,X1,"<=",X2), clingcon_var(X1), clingcon_var(X2), &sum{X1} <= X2.

% defined(F) :- binary(F,X1,_,X2), &df{X1}, &df{X2}.
