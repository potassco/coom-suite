% Evaluate functions (aggregates)
value(F,V) :- function(F,"count",P), V = #count{ X    : path(P,X), include(X) }.
value(F,V) :- function(F,"sum",  P), V = #sum  { V',X : path(P,X), value(X,V')   }.
value(F,V) :- function(F,"min",  P), V = #min  { V',X : path(P,X), value(X,V')   }.
value(F,V) :- function(F,"max",  P), V = #max  { V',X : path(P,X), value(X,V')   }.
