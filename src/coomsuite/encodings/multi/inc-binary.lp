% for incremental binary expressions we have to distinguish whether both sub-expressions or only one are incremental as well
% (note that at least one of the sub-expressions needs to incremental)

% case 1: both sub-expressions are incremental
#program incremental_binary(f,xl,op,xr,bound).
binary(f,xl,op,xr).

defined(f,bound) :- binary(f,xl,op,xr), defined(xl,bound), defined(xr,bound).
defined(f,bound) :- binary(f,xl,op,xr), value(f,_,bound).

value(f,VL+VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR,bound), op = "+".
value(f,VL-VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR,bound), op = "-".
value(f,VL*VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR,bound), op = "*".

value(f, VL,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), not value(xr,_,bound), op = "+".
value(f, VR,bound) :- binary(f,xl,op,xr), value(xr,VR,bound), not value(xl,_,bound), op = "+".
value(f, VL,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), not value(xr,_,bound), op = "-".
value(f,-VR,bound) :- binary(f,xl,op,xr), value(xr,VR,bound), not value(xl,_,bound), op = "-".

satisfied(f,bound) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL,bound), value(xr,VR,bound), op = "=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL != VR, value(xl,VL,bound), value(xr,VR,bound), op = "!=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL,bound), value(xr,VR,bound), op = ">".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL,bound), value(xr,VR,bound), op = ">=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL,bound), value(xr,VR,bound), op = "<".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL,bound), value(xr,VR,bound), op = "<=".

satisfied(f,bound) :- binary(f,xl,op,xr), 1 <= { satisfied(xl,bound); satisfied(xr,bound) }, op = "||".
satisfied(f,bound) :- binary(f,xl,op,xr), satisfied(xl,bound), satisfied(xr,bound), op = "&&".

% case 2: for the case that only on sub-expression is incremental we have to distinguish whether this is the left or right one

% 2.a: only the left sub-expression is incremental
#program incremental_binary_l(f,xl,op,xr,bound).
binary(f,xl,op,xr).

defined(f,bound) :- binary(f,xl,op,xr), defined(xl,bound), defined(xr).
defined(f,bound) :- binary(f,xl,op,xr), value(f,_,bound).

value(f,VL+VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR), op = "+".
value(f,VL-VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR), op = "-".
value(f,VL*VR,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), value(xr,VR), op = "*".

value(f, VL,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), not value(xr,_),       op = "+".
value(f, VR,bound) :- binary(f,xl,op,xr), value(xr,VR),       not value(xl,_,bound), op = "+".
value(f, VL,bound) :- binary(f,xl,op,xr), value(xl,VL,bound), not value(xr,_),       op = "-".
value(f,-VR,bound) :- binary(f,xl,op,xr), value(xr,VR),       not value(xl,_,bound), op = "-".

satisfied(f,bound) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL,bound), value(xr,VR), op = "=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL != VR, value(xl,VL,bound), value(xr,VR), op = "!=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL,bound), value(xr,VR), op = ">".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL,bound), value(xr,VR), op = ">=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL,bound), value(xr,VR), op = "<".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL,bound), value(xr,VR), op = "<=".

satisfied(f,bound) :- binary(f,xl,op,xr), 1 <= { satisfied(xl,bound); satisfied(xr) }, op = "||".
satisfied(f,bound) :- binary(f,xl,op,xr), satisfied(xl,bound), satisfied(xr), op = "&&".

% 2.b: only the right sub-expression is incremental
#program incremental_binary_r(f,xl,op,xr,bound).
binary(f,xl,op,xr).

defined(f,bound) :- binary(f,xl,op,xr), defined(xl), defined(xr,bound).
defined(f,bound) :- binary(f,xl,op,xr), value(f,_,bound).

value(f,VL+VR,bound) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR,bound), op = "+".
value(f,VL-VR,bound) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR,bound), op = "-".
value(f,VL*VR,bound) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR,bound), op = "*".

value(f, VL,bound) :- binary(f,xl,op,xr), value(xl,VL),       not value(xr,_,bound), op = "+".
value(f, VR,bound) :- binary(f,xl,op,xr), value(xr,VR,bound), not value(xl,_),       op = "+".
value(f, VL,bound) :- binary(f,xl,op,xr), value(xl,VL),       not value(xr,_,bound), op = "-".
value(f,-VR,bound) :- binary(f,xl,op,xr), value(xr,VR,bound), not value(xl,_),       op = "-".

satisfied(f,bound) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL), value(xr,VR,bound), op = "=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL != VR, value(xl,VL), value(xr,VR,bound), op = "!=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL), value(xr,VR,bound), op = ">".
satisfied(f,bound) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL), value(xr,VR,bound), op = ">=".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL), value(xr,VR,bound), op = "<".
satisfied(f,bound) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL), value(xr,VR,bound), op = "<=".

satisfied(f,bound) :- binary(f,xl,op,xr), 1 <= { satisfied(xl); satisfied(xr,bound) }, op = "||".
satisfied(f,bound) :- binary(f,xl,op,xr), satisfied(xl), satisfied(xr,bound), op = "&&".
