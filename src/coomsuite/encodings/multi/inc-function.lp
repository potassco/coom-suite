% program part for computing an incremental function from scratch
% the full aggregate is (re)computed at the given bound, independent of any previously grounded bound
% (used the first time a function is grounded, and at every bound in the "full" mode of the jump strategy)
#program incremental_function_full(f,agg,p,cur).
function(f,agg,p).
defined(f,cur) :- value(f,_,cur).

value(f,V,cur) :- function(f,agg,p), agg = "count",
                  V = #count{ X    : set(p,X), include(X)  }.
value(f,V,cur) :- function(f,agg,p), agg = "sum",
                  V = #sum  { V',X : set(p,X), value(X,V') }.
value(f,V,cur) :- function(f,agg,p), agg = "min",
                  V = #min  { V',X : set(p,X), value(X,V') }.
value(f,V,cur) :- function(f,agg,p), agg = "max",
                  V = #max  { V',X : set(p,X), value(X,V') }.

% program part for extending a previously grounded incremental function
% the result for the previous bound (prev) is reused and only the objects added in (prev, cur] are aggregated
% the stepwise strategy uses the gap (bound-1, bound], the jump strategy the gap between two targets
#program incremental_function_extend(f,agg,p,prev,cur).
function(f,agg,p).
defined(f,cur) :- value(f,_,cur).

% only take into account objects added in the gap (prev, cur] (identified by their bound/2 fact)
value(f,V+V',cur) :- function(f,agg,p), agg = "count", value(f,V,prev),
                     V' = #count{ X    : set(p,X), bound(X,B), prev < B, B <= cur, include(X)  }.

value(f,V+V',cur) :- function(f,agg,p), agg = "sum", value(f,V,prev),
                     V' = #sum  { Val,X : set(p,X), bound(X,B), prev < B, B <= cur, value(X,Val) }.

value(f,V',cur) :- function(f,agg,p), agg = "min", value(f,V,prev), V' <  V,
                   V' = #min{ Val,X : set(p,X), bound(X,B), prev < B, B <= cur, value(X,Val) }.
value(f,V ,cur) :- function(f,agg,p), agg = "min", value(f,V,prev), V' >= V,
                   V' = #min{ Val,X : set(p,X), bound(X,B), prev < B, B <= cur, value(X,Val) }.

value(f,V',cur) :- function(f,agg,p), agg = "max", value(f,V,prev), V' >  V,
                   V' = #max{ Val,X : set(p,X), bound(X,B), prev < B, B <= cur, value(X,Val) }.
value(f,V ,cur) :- function(f,agg,p), agg = "max", value(f,V,prev), V' <= V,
                   V' = #max{ Val,X : set(p,X), bound(X,B), prev < B, B <= cur, value(X,Val) }.
