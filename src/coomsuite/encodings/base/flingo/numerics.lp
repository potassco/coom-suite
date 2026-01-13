% Evaluate aggregates in flingo
&sum{ 1,X : set(P,X), include(X) } = F :- aggregate(F,"count",P).
&sum{   X : set(P,X), include(X) } = F :- aggregate(F,"sum",  P).
&min{   X : set(P,X), include(X) } = F :- aggregate(F,"min",  P).
&max{   X : set(P,X), include(X) } = F :- aggregate(F,"max",  P).

% Arithmetics in flingo
&sum{ XL;  XR } = F :- binary(F,XL,"+",XR).
&sum{ XL; -XR } = F :- binary(F,XL,"-",XR).

% Only linear constraints are supported
&sum{ XL*N } = F :- binary(F,XL,"*",XR), constant((XR,N),int).
&sum{ XR*N } = F :- binary(F,XL,"*",XR), constant((XL,N),int).
% TODO: Add more arithmetics (division and power)

% Unary formulas
&sus{  X } =: F :- unary(F,"()",X). % Definedness check because there exist parenthesis around Boolean formulas as well
&sum{  X } = F :- unary(F,"+", X).
&sum{ -X } = F :- unary(F,"-", X).

% Assign values of imply statements if object is included
&sum{F} = X :- imply((C,X),F), include(X), not condition((C,X),_).
&sum{F} = X :- imply((C,X),F), include(X), condition((C,X),Con), satisfied(Con).
