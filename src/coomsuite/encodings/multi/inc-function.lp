#program incremental_function(f,agg,p,bound).
function(f,agg,p).

defined(f,bound) :- value(f,_,bound).

% compute value step-wise
value(f,0  ,0  ) :- function(f,agg,p), agg = "count", bound = 0.
value(f,0  ,1  ) :- function(f,agg,p), agg = "count", bound = 1  , set(p,X), bound(X,bound), not include(X).
value(f,1  ,1  ) :- function(f,agg,p), agg = "count", bound = 1  , set(p,X), bound(X,bound), include(X).
value(f,V+1,N+1) :- function(f,agg,p), agg = "count", bound = N+1, set(p,X), bound(X,bound), include(X), value(f,V,N), bound > 1.

value(f,0   ,0  ) :- function(f,agg,p), agg = "sum", bound = 0.
value(f,0   ,1  ) :- function(f,agg,p), agg = "sum", bound = 1  , set(p,X), bound(X,bound), not include(X).
value(f,V   ,1  ) :- function(f,agg,p), agg = "sum", bound = 1  , set(p,X), bound(X,bound), include(X), value(X,V ).
value(f,V+V',N+1) :- function(f,agg,p), agg = "sum", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V'), value(f,V,N), bound > 1.

value(f,#sup,0  ) :- function(f,agg,p), agg = "min", bound = 0.
value(f,#sup,1  ) :- function(f,agg,p), agg = "min", bound = 1  , set(p,X), bound(X,bound), not include(X).
value(f,V   ,1  ) :- function(f,agg,p), agg = "min", bound = 1  , set(p,X), bound(X,bound), include(X), value(X,V).
value(f,V   ,N+1) :- function(f,agg,p), agg = "min", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V < V' , bound > 1.
value(f,V'  ,N+1) :- function(f,agg,p), agg = "min", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V >= V', bound > 1.

value(f,#inf,0  ) :- function(f,agg,p), agg = "max", bound = 0.
value(f,#inf,0  ) :- function(f,agg,p), agg = "max", bound = 1  , set(p,X), bound(X,bound), not include(X).
value(f,V   ,1  ) :- function(f,agg,p), agg = "max", bound = 1  , set(p,X), bound(X,bound), include(X), value(X,V).
value(f,V   ,N+1) :- function(f,agg,p), agg = "max", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V > V' , bound > 1.
value(f,V'  ,N+1) :- function(f,agg,p), agg = "max", bound = N+1, set(p,X), bound(X,bound), include(X), value(X,V), value(f,V',N), V <= V', bound > 1.

% if object with bound N+1 is not included then the value is just the one from bound N
value(f,V,N+1) :- function(f,_  ,p), bound = N+1, set(p,X), bound(X,bound), not include(X), value(f,V,N).

#show value(f,V,bound) : function(f,_,_), value(f,V,bound).
