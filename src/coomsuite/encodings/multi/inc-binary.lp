% we have an incremental binary if at least one of the sub-expressions in incremental
% maybe this could be done nicer by having a incremental(xr) predicate?
% or by adding "projections" value(X,V,bound) :- value(X,V) for all non-incrementals?

% TODO: add default arithmetic rules
#program incremental_binary(f,xl,op,xr,bound).
binary(f,xl,op,xr).

defined(f,bound) :- binary(f,xl,_,xr), defined(xl,bound), defined(xr,bound).

value(f,VL+VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR,bound), op = "+".
value(f,VL-VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR,bound), op = "-".
value(f,VL*VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR,bound), op = "*".

satisfied(f,bound) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL,bound), value(xr,VR,bound), op = "=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL != VR, value(xl,VL,bound), value(xr,VR,bound), op = "!=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL,bound), value(xr,VR,bound), op = ">".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL,bound), value(xr,VR,bound), op = ">=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL,bound), value(xr,VR,bound), op = "<".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL,bound), value(xr,VR,bound), op = "<=".

satisfied(f,bound) :- binary(f,xl,op,xr), 1 <= { satisfied(xl,bound); satisfied(xr,bound) }, op = "||".
satisfied(f,bound) :- binary(f,xl,op,xr), satisfied(xl,bound), satisfied(xr,bound), op = "&&".

#program incremental_binary_l(f,xl,op,xr,bound).
binary(f,xl,op,xr).

defined(f,bound) :- binary(f,xl,_,xr), defined(xl,bound), defined(xr).

value(f,VL+VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR), op = "+".
value(f,VL-VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR), op = "-".
value(f,VL*VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR), op = "*".

satisfied(f,bound) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL,bound), value(xr,VR), op = "=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL != VR, value(xl,VL,bound), value(xr,VR), op = "!=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL,bound), value(xr,VR), op = ">".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL,bound), value(xr,VR), op = ">=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL,bound), value(xr,VR), op = "<".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL,bound), value(xr,VR), op = "<=".

satisfied(f,bound) :- binary(f,xl,op,xr), 1 <= { satisfied(xl,bound); satisfied(xr) }, op = "||".
satisfied(f,bound) :- binary(f,xl,op,xr), satisfied(xl,bound), satisfied(xr), op = "&&".

#program incremental_binary_r(f,xl,op,xr,bound).
binary(f,xl,op,xr).

defined(f,bound) :- binary(f,xl,_,xr), defined(xl), defined(xr,bound).

value(f,VL+VR,bound) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR,bound), op = "+".
value(f,VL-VR,bound) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR,bound), op = "-".
value(f,VL*VR,bound) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR,bound), op = "*".

satisfied(f,bound) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL), value(xr,VR,bound), op = "=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL != VR, value(xl,VL), value(xr,VR,bound), op = "!=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL), value(xr,VR,bound), op = ">".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL), value(xr,VR,bound), op = ">=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL), value(xr,VR,bound), op = "<".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL), value(xr,VR,bound), op = "<=".

satisfied(f,bound) :- binary(f,xl,op,xr), 1 <= { satisfied(xl); satisfied(xr,bound) }, op = "||".
satisfied(f,bound) :- binary(f,xl,op,xr), satisfied(xl), satisfied(xr,bound), op = "&&".
