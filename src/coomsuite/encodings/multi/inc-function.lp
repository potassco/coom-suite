% TODO: currently this assumes that bound = index, but actually index = bound -1, i.e. with bound 0 there is no element, with bound 1 there is only element with index 0
#program incremental_function(f,agg,p,bound).
function(f,agg,p).

defined(f,bound) :- value(f,_,bound).

% compute value step-wise
value(f,1,  1  ) :- function(f,agg,p), agg = "count", bound = 1  , set(p,X), bound(X,bound), include(X).
value(f,V+1,N+1) :- function(f,agg,p), agg = "count", bound = N+1, set(p,X), bound(X,bound), include(X),     value(f,V,N).

value(f,V,   1  ) :- function(f,agg,p), agg = "sum", bound = 1  , set(p,X), bound(X,bound), include(X), value(X,V ).
value(f,V+V',N+1) :- function(f,agg,p), agg = "sum", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V'), value(f,V,N), bound > 1.

value(f,V ,1  ) :- function(f,agg,p), agg = "min", bound = 1  , set(p,X), bound(X,bound), include(X), value(X,V).
value(f,V ,N+1) :- function(f,agg,p), agg = "min", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V < V'.
value(f,V',N+1) :- function(f,agg,p), agg = "min", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V >= V'.

value(f,V ,1  ) :- function(f,agg,p), agg = "max", bound = 1  , set(p,X), bound(X,bound), include(X), value(X,V).
value(f,V ,N+1) :- function(f,agg,p), agg = "max", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V > V'.
value(f,V',N+1) :- function(f,agg,p), agg = "max", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V <= V'.

% if object with index N is not inlcuded then the value is just the one from the previous max bound
value(f,0,0)   :- function(f,agg,p), agg = "count", bound = 0.
value(f,0,0)   :- function(f,agg,p), agg = "sum",   bound = 0.
% TODO: values of max/min aggregate for max bound 0.
value(f,V,N+1) :- function(f,_  ,p), bound = N+1, set(p,X), bound(X,bound), not include(X), value(f,V,N).

#show value/3.
% #show bound/2.
