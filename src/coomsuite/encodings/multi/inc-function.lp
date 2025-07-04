% TODO: currently this assumes that bound = index, but actually index = bound -1, i.e. with bound 0 there is no element, with bound 1 there is only element with index 0
#program incremental_function(f,agg,p,bound).
defined(f,bound) :- value(f,_,bound).

% compute value step-wise
value(f,1,  0  ) :- function(f,agg,p), agg = "count", bound = 0  , set(p,X), index(X,0)  , include(X).
value(f,V+1,N+1) :- function(f,agg,p), agg = "count", bound = N+1, set(p,X), index(X,N+1), include(X),     value(f,V,N).

value(f,V,   0  ) :- function(f,agg,p), agg = "sum", bound = 0  , set(p,X), index(X,0),   include(X), value(X,V ).
value(f,V+V',N+1) :- function(f,agg,p), agg = "sum", bound = N+1, set(p,X), index(X,N+1), include(X), value(X,V'), value(f,V,N).

value(f,V ,0  ) :- function(f,agg,p), agg = "min", bound = 0  , set(p,X), index(X,0),   include(X), value(X,V).
value(f,V ,N+1) :- function(f,agg,p), agg = "min", bound = N+1, set(p,X), index(X,N+1), include(X), value(X,V), value(f,V',N), V < V'.
value(f,V',N+1) :- function(f,agg,p), agg = "min", bound = N+1, set(p,X), index(X,N+1), include(X), value(X,V), value(f,V',N), V >= V'.

value(f,V ,0  ) :- function(f,agg,p), agg = "max", bound = 0  , set(p,X), index(X,0),   include(X), value(X,V).
value(f,V ,N+1) :- function(f,agg,p), agg = "max", bound = N+1, set(p,X), index(X,N+1), include(X), value(X,V), value(f,V',N), V > V'.
value(f,V',N+1) :- function(f,agg,p), agg = "max", bound = N+1, set(p,X), index(X,N+1), include(X), value(X,V), value(f,V',N), V <= V'.

% if object with index N+1 is not inlcuded then the value is just the one from index N
value(f,V  ,N+1) :- function(f,_  ,p), bound = N+1, set(p,X), index(X,N+1), not include(X), value(f,V,N).
% TODO: default rule for when index 0 element is not included
%       would be dependend on the aggregate type
