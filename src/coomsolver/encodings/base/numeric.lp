% Derive range for each numeric feature variable
range(X,Min,Max) :- feature(C,F,"num",_,_), range(C,F,Min,Max),
                    type(X,"num"), feature(X,F), parent(X,P), type(P,C).

% Numeric variables are always included when its parents are included
included(X) :- type(X,"num"), parent(X,P), included(P).

% Generate numeric values
{ val(X,V) : V = Min..Max } :- type(X,"num"), range(X,Min,Max), not imply(X,_).

% Do not generate value if variable is not included
% Rule already in enumeration.lp
% :- type(X,"num"), val(X,_), not included(X).

% If variable is included generate exactly one value
:- type(X,"num"), included(X), not { val(X,_) } = 1.

% Check ranges
:- type(X,"num"), val(X,V), range(X,Min,Max), not Min <= V <= Max.

% Evaluate functions (aggregates)
val(F,V) :- function(F,"count",P), V = #count{ X    : function_path(P,X), included(X) }.
val(F,V) :- function(F,"sum",  P), V = #sum  { V',X : function_path(P,X), val(X,V')   }.
val(F,V) :- function(F,"min",  P), V = #min  { V',X : function_path(P,X), val(X,V')   }.
val(F,V) :- function(F,"max",  P), V = #max  { V',X : function_path(P,X), val(X,V')   }.


% Arithmetics
val(F,VL+VR) :- binary(F,XL,"+",XR), val(XL,VL), val(XR,VR).
val(F,VL-VR) :- binary(F,XL,"-",XR), val(XL,VL), val(XR,VR).
val(F,VL*VR) :- binary(F,XL,"*",XR), val(XL,VL), val(XR,VR).
% TODO: Add more arithmetics (division and power)

% Default arithmetics
val(F,VL)  :- binary(F,XL,"+",XR), val(XL,VL), not val(XR,_).
val(F,VR)  :- binary(F,XL,"+",XR), val(XR,VR), not val(XL,_).
val(F,VL)  :- binary(F,XL,"-",XR), val(XL,VL), not val(XR,_).
val(F,-VR) :- binary(F,XL,"-",XR), val(XR,VR), not val(XL,_).
% TODO: More rules for multiplication?

% Imply statements
val(X,V) :- imply(X,F), included(X), val(F,V).

% Show statement for numeric values
#show val(X,V) : val(X,V), type(X,"num").
