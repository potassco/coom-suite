% TODO: defined rule for multi shot
% (maybe add do the different program parts where values are assigned?)
% Definedness of formulas
defined(X) :- value(X,_).

#program new_constraint(cons,type).
% A Boolean formula is violated if it is defined and not satisfied
violated(cons) :- constraint(cons,type), defined(F), not satisfied(F), cons = (C,F), type = "boolean".

#program new_binary(f,xl,op,xr)
defined(f) :- binary(f,xl,_,xr), defined(xl), defined(xr).

% Satisfaction of binary comparison relations
satisfied(f) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL), value(xr,VR), op = "=".
satisfied(f) :- binary(f,xl,op,xr), VL != VR, value(xl,VL), value(xr,VR), op = "!=".
satisfied(f) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL), value(xr,VR), op = ">".
satisfied(f) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL), value(xr,VR), op = ">=".
satisfied(f) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL), value(xr,VR), op = "<".
satisfied(f) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL), value(xr,VR), op = "<=".

satisfied(f) :- binary(f,xl,op,xr), 1 <= { satisfied(xl); satisfied(xr) }, op = "||".

satisfied(f) :- binary(f,xl,op,xr), satisfied(xl), satisfied(xr), op = "&&".

#program new_unary(f,op,f').
defined(f) :- unary(f,op,f'), defined(f').

% Satisfaction of unary/binary logical relations
satisfied(f) :- unary(f,op,f'), not satisfied(f'), op = "!".
satisfied(f) :- unary(f,op,f'),     satisfied(f'), op = "()".
