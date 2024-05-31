% Derive range for each numeric feature variable
range(X,Min,Max) :- range(C,N,Min,Max),
                    type(X,"num"), name(X,N), parent(X,P), type(P,C).

% Numeric variables are always included when its parents are included
include(X) :- type(X,"num"), parent(X,P), include(P).

% Generate numeric values
{ value(X,V) : V = Min..Max } = 1 :- include(X), type(X,"num"), range(X,Min,Max).

% Do not generate value if variable is not included
% Rule already in enumeration.lp
% :- type(X,"num"), value(X,_), not include(X).

% If variable is included generate exactly one value
% :- type(X,"num"), include(X), not { value(X,_) } = 1.

% Check ranges
:- type(X,"num"), value(X,V), range(X,Min,Max), not Min <= V <= Max.

% Evaluate functions (aggregates)
value(F,V) :- function(F,"count",P), V = #count{ X    : path(P,X), include(X) }.
value(F,V) :- function(F,"sum",  P), V = #sum  { V',X : path(P,X), value(X,V')   }.
value(F,V) :- function(F,"min",  P), V = #min  { V',X : path(P,X), value(X,V')   }.
value(F,V) :- function(F,"max",  P), V = #max  { V',X : path(P,X), value(X,V')   }.


% Arithmetics
value(F,VL+VR) :- binary(F,XL,"+",XR), value(XL,VL), value(XR,VR).
value(F,VL-VR) :- binary(F,XL,"-",XR), value(XL,VL), value(XR,VR).
value(F,VL*VR) :- binary(F,XL,"*",XR), value(XL,VL), value(XR,VR).
% TODO: Add more arithmetics (division and power)

% Default arithmetics
value(F,VL)  :- binary(F,XL,"+",XR), value(XL,VL), not value(XR,_).
value(F,VR)  :- binary(F,XL,"+",XR), value(XR,VR), not value(XL,_).
value(F,VL)  :- binary(F,XL,"-",XR), value(XL,VL), not value(XR,_).
value(F,-VR) :- binary(F,XL,"-",XR), value(XR,VR), not value(XL,_).
% TODO: More rules for multiplication?

% Imply statements
:- imply(X,F), value(F,V), include(X), not value(X,V).

% Show statement for numeric values
#show value(X,V) : value(X,V), type(X,"num").
