% Evaluate functions in flingo (aggregates)
&sus{ 1,X : set(P,X), include(X) } =: F :- function(F,"count",P).
&sus{   X : set(P,X), include(X) } =: F :- function(F,"sum",  P).
&min{   X : set(P,X), include(X) } = F :- function(F,"min",  P).
&max{   X : set(P,X), include(X) } = F :- function(F,"max",  P).

% Arithmetics in flingo
&sum{ XL;  XR } = F :- binary(F,XL,"+",XR).
&sum{ XL; -XR } = F :- binary(F,XL,"-",XR).

% Only linear constraints are supported
&sum{ XL*N } = F :- binary(F,XL,"*",XR), number(XR,N).
&sum{ XR*N } = F :- binary(F,XL,"*",XR), number(XL,N).
% TODO: Add more arithmetics (division and power)

% Unary formulas
&sus{  X } =: F :- unary(F,"()",X). % Definedness check because there exist parenthesis around Boolean formulas as well
&sum{  X } = F :- unary(F,"+", X).
&sum{ -X } = F :- unary(F,"-", X).
