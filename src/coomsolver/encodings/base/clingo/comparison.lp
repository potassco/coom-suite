% Satisfaction of binary comparison relations
satisfied(F) :- binary(F,XL,"=", XR), VL =  VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,"!=",XR), VL != VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,">", XR), VL >  VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,">=",XR), VL >= VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,"<", XR), VL <  VR, value(XL,VL), value(XR,VR).
satisfied(F) :- binary(F,XL,"<=",XR), VL <= VR, value(XL,VL), value(XR,VR).

defined(F) :- binary(F,XL,_,XR), value(XL,_), value(XR,_).
