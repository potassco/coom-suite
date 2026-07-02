% incremental function for the jump grounding strategy that extends a previously grounded result
% the result for the previous bound (prev) is reused and only the objects added in (prev, cur] are aggregated
% this generalizes the stepwise update_incremental_function from a single step to an arbitrary gap (prev, cur]
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
