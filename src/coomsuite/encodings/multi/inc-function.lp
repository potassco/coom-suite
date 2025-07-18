#program new_incremental_function(f,agg,p,bound).
function(f,agg,p).

defined(f,bound) :- value(f,_,bound).

value(f,V,bound) :- function(f,agg,p), agg = "count", V = #count{ X : set(p,X), bound(X,bound), include(X) }.

value(f,V,bound) :- function(f,agg,p), agg = "sum", V = #sum{ V',X : set(p,X), bound(X,bound), value(X,V') }.

value(f,V   ,bound) :- function(f,agg,p), agg = "min", V = #min{ V',X : set(p,X), bound(X,bound), value(X,V') }.

value(f,V   ,bound) :- function(f,agg,p), agg = "max", V = #max{ V',X : set(p,X), bound(X,bound), value(X,V') }.

#show value(f,V,bound) : function(f,_,_), value(f,V,bound).

#program update_incremental_function(f,agg,p,bound).
function(f,agg,p).

defined(f,bound) :- value(f,_,bound).

% compute value step-wise
value(f,V+1,N+1) :- function(f,agg,p), agg = "count", bound = N+1, set(p,X), bound(X,bound), include(X), value(f,V,N).

value(f,V+V',N+1) :- function(f,agg,p), agg = "sum", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V'), value(f,V,N).

value(f,V ,N+1) :- function(f,agg,p), agg = "min", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V < V'.
value(f,V',N+1) :- function(f,agg,p), agg = "min", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V >= V'.

value(f,V ,N+1) :- function(f,agg,p), agg = "max", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V > V'.
value(f,V',N+1) :- function(f,agg,p), agg = "max", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V <= V'.

% if object with bound N+1 is not included then the value is just the one from bound N
value(f,V,N+1) :- function(f,_,p), bound = N+1, set(p,X), bound(X,bound), not include(X), value(f,V,N).

#show value(f,V,bound) : function(f,_,_), value(f,V,bound).
