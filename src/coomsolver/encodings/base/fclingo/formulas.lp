% Satisfaction of binary comparison relations for numeric values in fclingo
satisfied(F) :- binary(F,X1,"=", X2), &sum{X1} =  X2.
satisfied(F) :- binary(F,X1,"!=",X2), &sum{X1} != X2.
satisfied(F) :- binary(F,X1,">", X2), &sum{X1} >  X2.
satisfied(F) :- binary(F,X1,">=",X2), &sum{X1} >= X2.
satisfied(F) :- binary(F,X1,"<", X2), &sum{X1} <  X2.
satisfied(F) :- binary(F,X1,"<=",X2), &sum{X1} <= X2.

defined(F) :- binary(F,X1,_,X2), &df{X1}, &df{X2}.

% Evaluate functions in fclingo (aggregates)
&sus{ 1,X : path(P,X), include(X) } =: F :- function(F,"count",P).
&sus{   X : path(P,X), include(X) } =: F :- function(F,"sum",  P).
&min{   X : path(P,X), include(X) } =: F :- function(F,"min",  P).
&max{   X : path(P,X), include(X) } =: F :- function(F,"max",  P).


% Arithmetics in fclingo
&sus{ XL;  XR } =: F :- binary(F,XL,"+",XR).
&sus{ XL; -XR } =: F :- binary(F,XL,"-",XR).

% Only linear constraints are supported
&sus{ XL*N } =: F :- binary(F,XL,"*",XR), number(XR,N).
&sus{ XR*N } =: F :- binary(F,XL,"*",XR), number(XL,N).
% TODO: Is division possible in fclingo?
% TODO: Add more arithmetics (division and power)
