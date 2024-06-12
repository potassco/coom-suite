% Satisfaction of unary/binary logical relations
satisfied(F) :- unary(F,"!",F'), not satisfied(F').

satisfied(F) :- binary(F,XL,"||",XR), 1 <= { satisfied(XL); satisfied(XR) }.

satisfied(F) :- binary(F,XL,"&&",XR), satisfied(XL), satisfied(XR).

defined(F) :- binary(F,XL,_,XR), defined(XL), defined(XR).
defined(F) :- unary(F,_,F'), defined(F').
