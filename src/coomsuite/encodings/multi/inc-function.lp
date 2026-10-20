% program part for initializing new incremental functions
#program new_incremental_function(f,agg,p,bound).
function(f,agg,p).
defined(f,bound) :- value(f,_,bound).

value(f,V,bound) :- function(f,agg,p), agg = "count",
                    V = #count{ X : set(p,X), include(X) }.

value(f,V,bound) :- function(f,agg,p), agg = "sum",
                    V = #sum{ V',X : set(p,X), value(X,V') }.

value(f,V,bound) :- function(f,agg,p), agg = "min",
                    V = #min{ V',X : set(p,X), value(X,V') }.

value(f,V,bound) :- function(f,agg,p), agg = "max",
                    V = #max{ V',X : set(p,X), value(X,V') }.

% program part for updating incremental functions
#program update_incremental_function(f,agg,p,bound).
function(f,agg,p).
defined(f,bound) :- value(f,_,bound).

% compute value step-wise
% only take into account new objects with a corresponding bound/2 fact
value(f,V+V',N+1) :- function(f,agg,p), agg = "count", bound = N+1, value(f,V,N),
                     V' = #count{ X : set(p,X), bound(X,bound), include(X) }.

value(f,V+V',N+1) :- function(f,agg,p), agg = "sum", bound = N+1, value(f,V,N),
                     V' = #sum{ Val,X : set(p,X), bound(X,bound), value(X,Val) }.

value(f,V',N+1)   :- function(f,agg,p), agg = "min", bound = N+1, value(f,V,N), V' < V,
                     V' = #min{ Val,X : set(p,X), bound(X,bound), value(X,Val) }.
value(f,V ,N+1)   :- function(f,agg,p), agg = "min", bound = N+1, value(f,V,N), V' >= V,
                     V' = #min{ Val,X : set(p,X), bound(X,bound), value(X,Val) }.

value(f,V',N+1)   :- function(f,agg,p), agg = "max", bound = N+1, value(f,V,N), V' > V,
                     V' = #max{ Val,X : set(p,X), bound(X,bound), value(X,Val) }.
value(f,V ,N+1)   :- function(f,agg,p), agg = "max", bound = N+1, value(f,V,N), V' <= V,
                     V' = #max{ Val,X : set(p,X), bound(X,bound), value(X,Val) }.
