#program new_function(fun,agg,p).
function(fun,agg,p).

defined(fun) :- function(fun,agg,p), value(fun,_).

value(fun,V) :- function(fun,agg,p), V = #count{ X    : set(p,X), include(X)  }, agg = "count".
value(fun,V) :- function(fun,agg,p), V = #sum  { V',X : set(p,X), value(X,V') }, agg = "sum".
value(fun,V) :- function(fun,agg,p), V = #min  { V',X : set(p,X), value(X,V') }, agg = "min".
value(fun,V) :- function(fun,agg,p), V = #max  { V',X : set(p,X), value(X,V') }, agg = "max".
