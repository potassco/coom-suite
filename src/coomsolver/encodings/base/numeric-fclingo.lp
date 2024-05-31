% Derive range for each numeric feature variable
range(X,Min,Max) :- range(C,N,Min,Max),
                    type(X,"num"), name(X,N), parent(X,P), type(P,C).

% Numeric variables are always included when its parents are included
include(X) :- type(X,"num"), parent(X,P), include(P).

% Assign a value to a numeric feature
&in{Min..Max} =: X :- type(X,"num"), range(X,Min,Max), include(X).

% Evaluate functions (aggregates)
&sus{ 1,X : path(P,X), include(X) } =: F :- function(F,"count",P).
&sus{   X : path(P,X), include(X) } =: F :- function(F,"sum",  P).
&min{   X : path(P,X), include(X) } =: F :- function(F,"min",  P).
&max{   X : path(P,X), include(X) } =: F :- function(F,"max",  P).

% Arithmetics
&sus{ XL;  XR } =: F :- binary(F,XL,"+",XR).
&sus{ XL; -XR } =: F :- binary(F,XL,"-",XR).

% Only linear constraints are supported
&sus{ XL*N } =: F :- binary(F,XL,"*",XR), number(XR,N).
&sus{ XR*N } =: F :- binary(F,XL,"*",XR), number(XL,N).
% TODO: Is division possible in fclingo?
% TODO: Add more arithmetics (division and power)

% Imply statements
&sus{ F } =: X :- imply(X,F), include(X).

% Show statement for numeric values
&show { X : type(X,"num"), include(X) }.
