#program new_aggregate(fun,agg,p).
aggregate(fun,agg,p).

defined(fun) :- aggregate(fun,agg,p), value(fun,_).

value(fun,V) :- aggregate(fun,agg,p), V = #count{ X    : set(p,X), include(X)  }, agg = "count".
value(fun,V) :- aggregate(fun,agg,p), V = #sum  { V',X : set(p,X), value(X,V') }, agg = "sum".
value(fun,V) :- aggregate(fun,agg,p), V = #min  { V',X : set(p,X), value(X,V') }, agg = "min".
value(fun,V) :- aggregate(fun,agg,p), V = #max  { V',X : set(p,X), value(X,V') }, agg = "max".
