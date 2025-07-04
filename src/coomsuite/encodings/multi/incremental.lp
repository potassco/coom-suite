% idea: index parameter is added to value of functions
% this parameter is then carried upwards in constraint tree to the root
% the violated constraint in the encoding then includes active(index) external
#program incremental_function(f,agg,p,index).
defined(f,index) :- value(f,_,index).

% compute value step-wise
value(f,1,  0  ) :- function(f,agg,p), agg = "count", index = 0  , set(p,X), index(X,0)  , include(X).
value(f,V+1,N+1) :- function(f,agg,p), agg = "count", index = N+1, set(p,X), index(X,N+1), include(X),     value(f,V,N).

value(f,V,   0  ) :- function(f,agg,p), agg = "sum", index = 0  , set(p,X), index(X,0),   include(X), value(X,V ).
value(f,V+V',N+1) :- function(f,agg,p), agg = "sum", index = N+1, set(p,X), index(X,N+1), include(X), value(X,V'), value(f,V,N).

value(f,V ,0  ) :- function(f,agg,p), agg = "min", index = 0  , set(p,X), index(X,0),   include(X), value(X,V).
value(f,V ,N+1) :- function(f,agg,p), agg = "min", index = N+1, set(p,X), index(X,N+1), include(X), value(X,V), value(f,V',N), V < V'.
value(f,V',N+1) :- function(f,agg,p), agg = "min", index = N+1, set(p,X), index(X,N+1), include(X), value(X,V), value(f,V',N), V >= V'.

value(f,V ,0  ) :- function(f,agg,p), agg = "max", index = 0  , set(p,X), index(X,0),   include(X), value(X,V).
value(f,V ,N+1) :- function(f,agg,p), agg = "max", index = N+1, set(p,X), index(X,N+1), include(X), value(X,V), value(f,V',N), V > V'.
value(f,V',N+1) :- function(f,agg,p), agg = "max", index = N+1, set(p,X), index(X,N+1), include(X), value(X,V), value(f,V',N), V <= V'.

% if object with index N+1 is not inlcuded then the value is just the one from index N
value(f,V  ,N+1) :- function(f,_  ,p), index = N+1, set(p,X), index(X,N+1), not include(X), value(f,V,N).
% TODO: default rule for when index 0 element is not included
%       would be dependend on the aggregate type

#program incremental_unary(f,op,x,index).
defined(f,index) :- unary(f,op,x), defined(x,index).

value(f, V,index) :- unary(f,op,x), value(x,V,index), op = "()".
value(f, V,index) :- unary(f,op,x), value(x,V,index), op = "+".
value(f, V,index) :- unary(f,op,x), value(x,V,index), op = "-".

satisfied(f,index) :- unary(f,op,x), not satisfied(x,index), op = "!".
satisfied(f,index) :- unary(f,op,x)      satisfied(x,index), op = "()".

% we have an incremental binary if at least one of the sub-expressions in incremental
% maybe this could be done nicer by having a incremental(xr) predicate?
% or by adding "projections" value(X,V,index) :- value(X,V) for all non-incrementals?
#program incremental_binary(f,xl,op,xr,index).
defined(f,index) :- binary(f,xl,_,xr), defined(xl,index), defined(xr,index).

value(f,VL+VR,index) :- binary(f,xl,op,xr), value(xl,VL,index), value(xr,VR,index), op = "+".
value(f,VL-VR,index) :- binary(f,xl,op,xr), value(xl,VL,index), value(xr,VR,index), op = "-".
value(f,VL*VR,index) :- binary(f,xl,op,xr), value(xl,VL,index), value(xr,VR,index), op = "*".

satisfied(f,index) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL,index), value(xr,VR,index), op = "=".
satisfied(f,index) :- binary(f,xl,op,xr), VL != VR, value(xl,VL,index), value(xr,VR,index), op = "!=".
satisfied(f,index) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL,index), value(xr,VR,index), op = ">".
satisfied(f,index) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL,index), value(xr,VR,index), op = ">=".
satisfied(f,index) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL,index), value(xr,VR,index), op = "<".
satisfied(f,index) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL,index), value(xr,VR,index), op = "<=".

satisfied(f,index) :- binary(f,xl,op,xr), 1 <= { satisfied(xl,index); satisfied(xr,index) }, op = "||".
satisfied(f,index) :- binary(f,xl,op,xr), satisfied(xl,index), satisfied(xr,index), op = "&&".

#program incremental_binary_l(f,xl,op,xr,index).
defined(f,index) :- binary(f,xl,_,xr), defined(xl,index), defined(xr).

value(f,VL+VR,index) :- binary(f,xl,op,xr), value(xl,VL,index), value(xr,VR), op = "+".
value(f,VL-VR,index) :- binary(f,xl,op,xr), value(xl,VL,index), value(xr,VR), op = "-".
value(f,VL*VR,index) :- binary(f,xl,op,xr), value(xl,VL,index), value(xr,VR), op = "*".

satisfied(f,index) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL,index), value(xr,VR), op = "=".
satisfied(f,index) :- binary(f,xl,op,xr), VL != VR, value(xl,VL,index), value(xr,VR), op = "!=".
satisfied(f,index) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL,index), value(xr,VR), op = ">".
satisfied(f,index) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL,index), value(xr,VR), op = ">=".
satisfied(f,index) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL,index), value(xr,VR), op = "<".
satisfied(f,index) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL,index), value(xr,VR), op = "<=".

satisfied(f,index) :- binary(f,xl,op,xr), 1 <= { satisfied(xl,index); satisfied(xr) }, op = "||".
satisfied(f,index) :- binary(f,xl,op,xr), satisfied(xl,index), satisfied(xr), op = "&&".

#program incremental_binary_r(f,xl,op,xr,index).
defined(f,index) :- binary(f,xl,_,xr), defined(xl), defined(xr,index).

value(f,VL+VR,index) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR,index), op = "+".
value(f,VL-VR,index) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR,index), op = "-".
value(f,VL*VR,index) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR,index), op = "*".

satisfied(f,index) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL), value(xr,VR,index), op = "=".
satisfied(f,index) :- binary(f,xl,op,xr), VL != VR, value(xl,VL), value(xr,VR,index), op = "!=".
satisfied(f,index) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL), value(xr,VR,index), op = ">".
satisfied(f,index) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL), value(xr,VR,index), op = ">=".
satisfied(f,index) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL), value(xr,VR,index), op = "<".
satisfied(f,index) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL), value(xr,VR,index), op = "<=".

satisfied(f,index) :- binary(f,xl,op,xr), 1 <= { satisfied(xl); satisfied(xr,index) }, op = "||".
satisfied(f,index) :- binary(f,xl,op,xr), satisfied(xl), satisfied(xr,index), op = "&&".

#program incremental_constraint(cons,type,index).
#external max_bound(index).
violated(cons,index) :- constraint(cons,type), defined(F,index), not satisfied(F,index), cons = (C,F), type = "boolean".

:- violated(C,index), max_bound(index).
