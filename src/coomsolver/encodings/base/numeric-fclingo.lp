% Derive range for each numeric feature variable
range(X,Min,Max) :- feature(C,F,"num",_,_), range(C,F,Min,Max),
                    num(X), feature(X,F), parent(X,P), type(P,C).

% Numeric variables are always included when its parents are included
included(X) :- num(X), parent(X,P), included(P).

% Assign a value to a numeric feature
&in{Min..Max} =: X :- num(X), range(X,Min,Max), included(X).

% Evaluate functions (aggregates)
&sus{ 1,X : function_path(P,X), included(X) } =: F :- function(F,"count",P).
&sus{   X : function_path(P,X), included(X) } =: F :- function(F,"sum",  P).
&min{   X : function_path(P,X), included(X) } =: F :- function(F,"min",  P).
&max{   X : function_path(P,X), included(X) } =: F :- function(F,"max",  P).

% Arithmetics
&sus{ XL;  XR } =: F :- binary(F,XL,"+",XR).
&sus{ XL; -XR } =: F :- binary(F,XL,"-",XR).

% Only linear constraints are supported
&sus{ XL*N } =: F :- binary(F,XL,"*",XR), number(XR,N).
&sus{ XR*N } =: F :- binary(F,XL,"*",XR), number(XL,N).
% TODO: Is division possible in fclingo?
% TODO: Add more arithmetics (division and power)

% Imply statements
&sus{ F } =: X :- imply(X,F), included(X).

% Show statement for numeric values
&show { X : num(X), included(X) }.
