% Evaluate functions (aggregates)
&sus{ 1,X : path(P,X), include(X) } =: F :- function(F,"count",P).
&sus{   X : path(P,X), include(X) } =: F :- function(F,"sum",  P).
&min{   X : path(P,X), include(X) } =: F :- function(F,"min",  P).
&max{   X : path(P,X), include(X) } =: F :- function(F,"max",  P).
