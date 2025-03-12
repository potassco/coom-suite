% Definedness of formulas
defined(X) :- value(X,_).
defined(F) :- binary(F,XL,_,XR), defined(XL), defined(XR).
defined(F) :- unary(F,_,F'), defined(F').

% Satisfaction of binary comparison relations
satisfied(F) :- binary(F,XL,"=", XR), VL =  VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,"!=",XR), VL != VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,">", XR), VL >  VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,">=",XR), VL >= VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,"<", XR), VL <  VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,"<=",XR), VL <= VR, value(XL,VL), value(XR,VR).

% Satisfaction of unary/binary logical relations
satisfied(F) :- unary(F,"!",F'), not satisfied(F').
satisfied(F) :- unary(F,"()",F'),    satisfied(F').

satisfied(F) :- binary(F,XL,"||",XR), 1 <= { satisfied(XL); satisfied(XR) }.

satisfied(F) :- binary(F,XL,"&&",XR), satisfied(XL), satisfied(XR).

% A Boolean formula is violated if it is defined and not satisfied
violated(C,F) :- constraint((C,F),"boolean"), defined(F), not satisfied(F).
