% Evaluate functions (aggregates)
value(F,V) :- function(F,"count",P), V = #count{ X    : set(P,X), include(X) }.
value(F,V) :- function(F,"sum",  P), V = #sum  { V',X : set(P,X), value(X,V')   }.
value(F,V) :- function(F,"min",  P), V = #min  { V',X : set(P,X), value(X,V')   }.
value(F,V) :- function(F,"max",  P), V = #max  { V',X : set(P,X), value(X,V')   }.

% Arithmetics
value(F,VL+VR) :- binary(F,XL,"+",XR), value(XL,VL), value(XR,VR).
value(F,VL-VR) :- binary(F,XL,"-",XR), value(XL,VL), value(XR,VR).
value(F,VL*VR) :- binary(F,XL,"*",XR), value(XL,VL), value(XR,VR).
value(F, V)    :- unary(F,"()",X),     value(X,V).
value(F, V)    :- unary(F,"+", X),     value(X,V).
value(F,-V)    :- unary(F,"-", X),     value(X,V).
% TODO: Add more arithmetics (division and power)

% Default arithmetics
value(F,VL)  :- binary(F,XL,"+",XR), value(XL,VL), not value(XR,_).
value(F,VR)  :- binary(F,XL,"+",XR), value(XR,VR), not value(XL,_).
value(F,VL)  :- binary(F,XL,"-",XR), value(XL,VL), not value(XR,_).
value(F,-VR) :- binary(F,XL,"-",XR), value(XR,VR), not value(XL,_).
% TODO: More rules for multiplication?
