% program part for initializing new incremental functions
#program new_incremental_function(f,agg,p,bound).
function(f,agg,p).

defined(f,bound) :- value(f,_,bound).

% when an incremental function is initialized the corresponding set may have several elements
% thus it is necessary to actually use the corresponding aggregates
% at bound 0 possible objects are not introduced with a bound parameter
value(f,V,bound) :- function(f,agg,p), agg = "count", V = #count{ X  : set(p,X),                 include(X)  }, bound = 0.
value(f,V,bound) :- function(f,agg,p), agg = "count", V = #count{ X  : set(p,X), bound(X,bound), include(X)  }, bound > 0.

value(f,V,bound) :- function(f,agg,p), agg = "sum",   V = #sum{ V',X : set(p,X),                 value(X,V') }, bound = 0.
value(f,V,bound) :- function(f,agg,p), agg = "sum",   V = #sum{ V',X : set(p,X), bound(X,bound), value(X,V') }, bound > 0.

value(f,V,bound) :- function(f,agg,p), agg = "min",   V = #min{ V',X : set(p,X),                 value(X,V') }, bound = 0.
value(f,V,bound) :- function(f,agg,p), agg = "min",   V = #min{ V',X : set(p,X), bound(X,bound), value(X,V') }, bound > 0.

value(f,V,bound) :- function(f,agg,p), agg = "max",   V = #max{ V',X : set(p,X),                 value(X,V') }, bound = 0.
value(f,V,bound) :- function(f,agg,p), agg = "max",   V = #max{ V',X : set(p,X), bound(X,bound), value(X,V') }, bound > 0.

% program part for updating incremental functions
#program update_incremental_function(f,agg,p,bound).
function(f,agg,p).

defined(f,bound) :- value(f,_,bound).

% compute value step-wise
value(f,V+V',N+1) :- function(f,agg,p), agg = "count", bound = N+1, value(f,V,N), V' = #count{ X   : set(p,X), bound(X,bound), include(X)   }.

value(f,V+V',N+1) :- function(f,agg,p), agg = "sum",   bound = N+1, value(f,V,N), V' = #sum{ Val,X : set(p,X), bound(X,bound), value(X,Val) }.

value(f,V',N+1)   :- function(f,agg,p), agg = "min",   bound = N+1, value(f,V,N), V' = #min{ Val,X : set(p,X), bound(X,bound), value(X,Val) }, V' < V.
value(f,V ,N+1)   :- function(f,agg,p), agg = "min",   bound = N+1, value(f,V,N), V' = #min{ Val,X : set(p,X), bound(X,bound), value(X,Val) }, V' >= V.

value(f,V',N+1)   :- function(f,agg,p), agg = "max",   bound = N+1, value(f,V,N), V' = #max{ Val,X : set(p,X), bound(X,bound), value(X,Val) }, V' > V.
value(f,V ,N+1)   :- function(f,agg,p), agg = "max",   bound = N+1, value(f,V,N), V' = #max{ Val,X : set(p,X), bound(X,bound), value(X,Val) }, V' <= V.
