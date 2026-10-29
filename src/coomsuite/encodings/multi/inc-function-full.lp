% self-contained incremental function
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
