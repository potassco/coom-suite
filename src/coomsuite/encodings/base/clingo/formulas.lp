#include "boolean.lp".

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
