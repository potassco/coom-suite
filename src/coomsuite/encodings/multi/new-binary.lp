#program new_binary(f,xl,op,xr).
binary(f,xl,op,xr).

% boolean binaries
defined(f) :- binary(f,xl,op,xr), defined(xl), defined(xr).

satisfied(f) :- binary(f,xl,op,xr), VL =  VR, value(xl,VL), value(xr,VR), op = "=".
satisfied(f) :- binary(f,xl,op,xr), VL != VR, value(xl,VL), value(xr,VR), op = "!=".
satisfied(f) :- binary(f,xl,op,xr), VL >  VR, value(xl,VL), value(xr,VR), op = ">".
satisfied(f) :- binary(f,xl,op,xr), VL >= VR, value(xl,VL), value(xr,VR), op = ">=".
satisfied(f) :- binary(f,xl,op,xr), VL <  VR, value(xl,VL), value(xr,VR), op = "<".
satisfied(f) :- binary(f,xl,op,xr), VL <= VR, value(xl,VL), value(xr,VR), op = "<=".
satisfied(f) :- binary(f,xl,op,xr), 1 <= { satisfied(xl); satisfied(xr) }, op = "||".
satisfied(f) :- binary(f,xl,op,xr), satisfied(xl), satisfied(xr), op = "&&".

% numeric binaries
defined(f) :- binary(f,xl,op,xr), value(f,_).

value(f,VL+VR) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR), op = "+".
value(f,VL-VR) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR), op = "-".
value(f,VL*VR) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR), op = "*".

value(f, VL) :- binary(f,xl,op,xr), value(xl,VL), not value(xr,_), op = "+".
value(f, VR) :- binary(f,xl,op,xr), value(xr,VR), not value(xl,_), op = "+".
value(f, VL) :- binary(f,xl,op,xr), value(xl,VL), not value(xr,_), op = "-".
value(f,-VR) :- binary(f,xl,op,xr), value(xr,VR), not value(xl,_), op = "-".
