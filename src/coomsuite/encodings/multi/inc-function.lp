% program part for initializing new incremental functions
#program new_incremental_function(f,agg,p,bound).
function(f,agg,p).
defined(f,bound) :- value(f,_,bound).

% the use of objects with include/2 is necessary as certain association variables only have an include/2 fact
% and no corresponding inlcude/1 fact
value(f,V,bound) :- function(f,agg,p), agg = "count",
                    V = #count{ X : set(p,X), include(X) ;
                                X : set(p,X), include(X,bound) }.

value(f,V,bound) :- function(f,agg,p), agg = "sum",
                    V = #sum{ V',X : set(p,X), value(X,V') ;
                              V',X : set(p,X), value(X,V',bound) }.

value(f,V,bound) :- function(f,agg,p), agg = "min",
                    V = #min{ V',X : set(p,X), value(X,V') ;
                              V',X : set(p,X), value(X,V',bound) }.

value(f,V,bound) :- function(f,agg,p), agg = "max",
                    V = #max{ V',X : set(p,X), value(X,V') ;
                              V',X : set(p,X), value(X,V',bound) }.

% program part for updating incremental functions
#program update_incremental_function(f,agg,p,bound).
function(f,agg,p).
defined(f,bound) :- value(f,_,bound).

% compute value step-wise
% only take into account new objects:
% - either object with a corresponding bound/2 fact
% - or association variables with a include/2 fact (as this inlcude/2 persists for increasing bounds the condition
%   not include(X,bound-1) is neccessary to avoid duplication)
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
