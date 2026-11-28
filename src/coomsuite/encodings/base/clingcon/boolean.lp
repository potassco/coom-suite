% Satisfaction of binary comparison relations for numeric values in flingo
integer(X) :- type(X,T), numeric(T,"int").
integer(X) :- type(X,T), discrete(T,"int").
integer(X) :- constant(X,"int").
integer(F) :- binary(F,X1,Op,X2), integer(X1), integer(X2), Op = ("+";"-";"*";"/").
integer(F) :- unary(F,Op,X), integer(X), Op = ("+";"-").
integer(F) :- function(F,Agg,P), Agg = ("sum";"count").

satisfied(F) :- binary(F,X1,"=", X2), integer(X1), integer(X2), &sum{X1} =  X2.
satisfied(F) :- binary(F,X1,"!=",X2), integer(X1), integer(X2), not &sum{X1} = X2.
satisfied(F) :- binary(F,X1,">", X2), integer(X1), integer(X2), &sum{X1} >  X2.
satisfied(F) :- binary(F,X1,">=",X2), integer(X1), integer(X2), &sum{X1} >= X2.
satisfied(F) :- binary(F,X1,"<", X2), integer(X1), integer(X2), &sum{X1} <  X2.
satisfied(F) :- binary(F,X1,"<=",X2), integer(X1), integer(X2), &sum{X1} <= X2.
