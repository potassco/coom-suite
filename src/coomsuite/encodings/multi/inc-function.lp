% program part for initializing new incremental functions
#program new_incremental_function(f,agg,p,bound).
function(f,agg,p).

defined(f,bound) :- value(f,_,bound).

% when an incremental function is initialized the corresponding set may have several elements
% thus it is necessary to actually use the corresponding aggregates
% at bound 0 possible objects are not introduced with a bound parameter
value(f,V,bound) :- function(f,agg,p), agg = "count", bound = 0,
                    V = #count{ X : set(p,X), include(X) ;
                                X : set(p,X), include(X,bound), not include(X,bound-1) }.
value(f,V,bound) :- function(f,agg,p), agg = "count", bound > 0,
                    V = #count{ X : set(p,X), bound(X,bound), include(X) ;
                                X : set(p,X), include(X,bound), not include(X,bound-1) }.

value(f,V,bound) :- function(f,agg,p), agg = "sum", bound = 0,
                    V = #sum{ V',X : set(p,X), value(X,V') ;
                              V',X : set(p,X), value(X,V',bound), not value(X,V',bound-1) }.
value(f,V,bound) :- function(f,agg,p), agg = "sum", bound > 0,
                    V = #sum{ V',X : set(p,X), bound(X,bound), value(X,V') ;
                              V',X : set(p,X), value(X,V',bound), not value(X,V',bound-1) }.

value(f,V,bound) :- function(f,agg,p), agg = "min", bound = 0,
                    V = #min{ V',X : set(p,X), value(X,V') ;
                              V',X : set(p,X), value(X,V',bound), not value(X,V',bound-1) }.
value(f,V,bound) :- function(f,agg,p), agg = "min", bound > 0,
                    V = #min{ V',X : set(p,X), bound(X,bound), value(X,V') ;
                              V',X : set(p,X), value(X,V',bound), not value(X,V',bound-1) }.

value(f,V,bound) :- function(f,agg,p), agg = "max", bound = 0,
                    V = #max{ V',X : set(p,X), value(X,V') ;
                              V',X : set(p,X), value(X,V',bound), not value(X,V',bound-1) }.
value(f,V,bound) :- function(f,agg,p), agg = "max", bound > 0,
                    V = #max{ V',X : set(p,X), bound(X,bound), value(X,V') ;
                              V',X : set(p,X), value(X,V',bound), not value(X,V',bound-1) }.

% program part for updating incremental functions
#program update_incremental_function(f,agg,p,bound).
function(f,agg,p).

defined(f,bound) :- value(f,_,bound).

% compute value step-wise
value(f,V+V',N+1) :- function(f,agg,p), agg = "count", bound = N+1, value(f,V,N),
                     V' = #count{ X : set(p,X), bound(X,bound), include(X) ;
                                  X : set(p,X), include(X,bound), not include(X,bound-1) }.

value(f,V+V',N+1) :- function(f,agg,p), agg = "sum", bound = N+1, value(f,V,N),
                     V' = #sum{ Val,X : set(p,X), bound(X,bound), value(X,Val) ;
                                Val,X : set(p,X), value(X,Val,bound), not value(X,Val,bound-1) }.

value(f,V',N+1)   :- function(f,agg,p), agg = "min", bound = N+1, value(f,V,N), V' < V,
                     V' = #min{ Val,X : set(p,X), bound(X,bound), value(X,Val) ;
                                Val,X : set(p,X), value(X,Val,bound), not value(X,Val,bound-1) }.
value(f,V ,N+1)   :- function(f,agg,p), agg = "min", bound = N+1, value(f,V,N), V' >= V,
                     V' = #min{ Val,X : set(p,X), bound(X,bound), value(X,Val) ;
                                Val,X : set(p,X), value(X,Val,bound), not value(X,Val,bound-1) }.

value(f,V',N+1)   :- function(f,agg,p), agg = "max", bound = N+1, value(f,V,N), V' > V,
                     V' = #max{ Val,X : set(p,X), bound(X,bound), value(X,Val) ;
                                Val,X : set(p,X), value(X,Val,bound), not value(X,Val,bound-1) }.
value(f,V ,N+1)   :- function(f,agg,p), agg = "max", bound = N+1, value(f,V,N), V' <= V,
                     V' = #max{ Val,X : set(p,X), bound(X,bound), value(X,Val) ;
                                Val,X : set(p,X), value(X,Val,bound), not value(X,Val,bound-1) }.
