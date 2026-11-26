% Satisfaction of binary comparison relations for numeric values in flingo
numeric(X) :- type(X,T), integer(T).
numeric(X) :- number(X,_).
numeric(F) :- binary(F,X1,Op,X2), numeric(X1), numeric(X2), Op = ("+";"-";"*";"/").
numeric(F) :- unary(F,Op,X), numeric(X), Op = ("+";"-").
numeric(F) :- function(F,Agg,P), Agg = ("sum";"count").

{ satisfied(F) } :- binary(F,X1,"=", X2), numeric(X1), numeric(X2).
{ satisfied(F) } :- binary(F,X1,"!=",X2), numeric(X1), numeric(X2).
{ satisfied(F) } :- binary(F,X1,">", X2), numeric(X1), numeric(X2).
{ satisfied(F) } :- binary(F,X1,">=",X2), numeric(X1), numeric(X2).
{ satisfied(F) } :- binary(F,X1,"<", X2), numeric(X1), numeric(X2).
{ satisfied(F) } :- binary(F,X1,"<=",X2), numeric(X1), numeric(X2).

&sum{X1} = X2 :-  binary(F,X1,"=", X2), numeric(X1), numeric(X2), satisfied(F).
&sum{X1} = X2 :-  binary(F,X1,"!=",X2), numeric(X1), numeric(X2), defined(F), not satisfied(F).
&sum{X1} >  X2 :- binary(F,X1,">", X2), numeric(X1), numeric(X2), satisfied(F).
&sum{X1} >= X2 :- binary(F,X1,">=",X2), numeric(X1), numeric(X2), satisfied(F).
&sum{X1} <  X2 :- binary(F,X1,"<", X2), numeric(X1), numeric(X2), satisfied(F).
&sum{X1} <= X2 :- binary(F,X1,"<=",X2), numeric(X1), numeric(X2), satisfied(F).
