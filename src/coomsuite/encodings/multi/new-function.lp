#program new_function(fun,agg,p).
function(fun,agg,p).

defined(fun) :- function(fun,agg,p), value(fun,_).

value(f,V) :- function(f,agg,p), V = #count{ X    : set(p,X), include(X)  }, agg = "count".
value(f,V) :- function(f,agg,p), V = #sum  { V',X : set(p,X), value(X,V') }, agg = "sum".
value(f,V) :- function(f,agg,p), V = #min  { V',X : set(p,X), value(X,V') }, agg = "min".
value(f,V) :- function(f,agg,p), V = #max  { V',X : set(p,X), value(X,V') }, agg = "max".
