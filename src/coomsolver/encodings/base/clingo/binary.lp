% Satisfaction of unary/binary relations
satisfied(F) :- unary(F,"!",F'), not satisfied(F').

satisfied(F) :- binary(F,XL,"||",XR), satisfied(XL).
satisfied(F) :- binary(F,XL,"||",XR), satisfied(XR).
satisfied(F) :- binary(F,XL,"&&",XR), satisfied(XL), satisfied(XR).

satisfied(F) :- binary(F,XL,"=", XR), VL =  VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,"!=",XR), VL != VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,">", XR), VL >  VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,">=",XR), VL >= VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,"<", XR), VL <  VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,"<=",XR), VL <= VR, value(XL,VL), value(XR,VR).

defined(F) :- binary(F,XL,_,XR), value(XL,_), value(XR,_).
defined(F) :- binary(F,XL,_,XR), defined(XL), defined(XR).
defined(F) :- unary(F,_,F'), defined(F').
