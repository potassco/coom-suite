% Constraints cannot be unsatisfied
:- constraint(C), unsatisfied(C,_).

:- constraint(C,F), defined(F), not satisfied(F).

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

% Strong negation of binary satisfaction if formula is defined and not satisfied
% -satisfied(F) :- binary(F,_,_,_), defined(F), not satisfied(F).


% Combinations Table (only for allow)
% Table constraint is satisfied if a row is satisfied
unsatisfied(C,ID) :- column(C,ID,_,_), not hit_row(C,ID), defined(C,ID).

%%% Check combinations
hit_cell(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), column(C,ID,Col,X), value(X,V), C=(Idx,_).

hit_row(C,ID) :- allow(Idx,(_,Row),_), column(C,ID,_,_), C=(Idx,_),
                 0 = #sum{ 1,Col : allow(Idx,(Col,Row),_);
                          -1,Col': hit_cell(C,ID,(Col',Row)) }.

defined(C,ID,Col) :- column(C,ID,Col,X), value(X,_).
defined(C,ID)     :- column(C,ID,_,_), 0 = #sum{ 1, Col: column(C,ID,Col,_);
                                                -1, Col: defined(C,ID,Col)}.
