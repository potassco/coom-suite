#program new_function(f,agg,p).
% Evaluate aggregates
value(f,V) :- function(f,agg,p), V = #count{ X    : set(p,X), include(X)  }, agg = "count".
value(f,V) :- function(f,agg,p), V = #sum  { V',X : set(p,X), value(X,V') }, agg = "sum".
value(f,V) :- function(f,agg,p), V = #min  { V',X : set(p,X), value(X,V') }, agg = "min".
value(f,V) :- function(f,agg,p), V = #max  { V',X : set(p,X), value(X,V') }, agg = "max".

#program new_binary(f,xl,op,xr).
% Arithmetics
value(f,VL+VR) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR), op ="+".
value(f,VL-VR) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR), op ="-".
value(f,VL*VR) :- binary(f,xl,op,xr), value(xl,VL), value(xr,VR), op ="*".

#program new_unary(f,op,x).
value(f, V) :- unary(f,op,x), value(x,V), op ="()".
value(f, V) :- unary(f,op,x), value(x,V), op ="+".
value(f,-V) :- unary(f,op,x), value(x,V), op ="-".

#program new_binary(f,xl,op,xr).
% Default arithmetics
value(f, VL) :- binary(f,xl,op,xr), value(xl,VL), not value(xr,_), op ="+".
value(f, VR) :- binary(f,xl,op,xr), value(xr,VR), not value(xl,_), op ="+".
value(f, VL) :- binary(f,xl,op,xr), value(xl,VL), not value(xr,_), op ="-".
value(f,-VR) :- binary(f,xl,op,xr), value(xr,VR), not value(xl,_), op ="-".
