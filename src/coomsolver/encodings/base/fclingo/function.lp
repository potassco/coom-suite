% Evaluate functions in fclingo (aggregates)
&sus{ 1,X : path(X,P), include(X) } =: F :- function(F,"count",P).
&sus{   X : path(X,P), include(X) } =: F :- function(F,"sum",  P).
&min{   X : path(X,P), include(X) } =: F :- function(F,"min",  P).
&max{   X : path(X,P), include(X) } =: F :- function(F,"max",  P).
