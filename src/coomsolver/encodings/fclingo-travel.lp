#include "fclingo-city.lp".

% Assign a value to a numeric feature
&in{Min..Max} =: (Feature,(Instance,0)) :- feature(Context,Feature,"num",_,_), range(Context,Feature,Min,Max), instance(Instance,Context).

% Create auxiliary instance predicate for paths
instance((Feature,(Instance,0)),Feature) :- feature(Context,Feature,"num",_,_), instance(Instance,Context).

% Paths which point to instances (not attributes)
path_instance(Instance,Path) :- function(Context,_,_,Path), path(Path,0,_), instance(Instance,Context).

% Auxiliary path instances for aggregates and arithmetics
path_instance(Instance,Function,(Instance,Function)) :- function(Context,Function,_,_), instance(Instance,Context).

arithmetic_op(("+";"-";"*";"/")).
path_instance(Instance,Formula,(Instance,Formula))   :- binary(Context,Formula,_,Op,_), instance(Instance,Context), arithmetic_op(Op).

% Evaluate functions (aggregates)
% Assumes that every function and every term in an arithmetic expression points to a single path
&sus{ 1,X : path_instance(Instance,Path,X) } =: (Instance,Function) :- function(Context,Function,"count",Path), instance(Instance,Context).
&sus{   X : path_instance(Instance,Path,X) } =: (Instance,Function) :- function(Context,Function,"sum",Path),   instance(Instance,Context).
&min{   X : path_instance(Instance,Path,X) } =: (Instance,Function) :- function(Context,Function,"min",Path),   instance(Instance,Context).
&max{   X : path_instance(Instance,Path,X) } =: (Instance,Function) :- function(Context,Function,"max",Path),   instance(Instance,Context).

% Arithmetics
&sus{ X1;  X2 } =: (Instance,Formula) :- binary(Context,Formula,Left,"+",Right), instance(Instance,Context),
                                         path_instance(Instance,Left,X1), path_instance(Instance,Right,X2).
&sus{ X1; -X2 } =: (Instance,Formula) :- binary(Context,Formula,Left,"-",Right), instance(Instance,Context),
                                         path_instance(Instance,Left,X1), path_instance(Instance,Right,X2).

% Only linear constraints are supported
&sus{ X*N } =: (Instance,Formula) :- binary(Context,Formula,Left,"*",Right), number(Right,N), instance(Instance,Context), path_instance(Instance,Left,X).
&sus{ X*N } =: (Instance,Formula) :- binary(Context,Formula,Left,"*",Right), number(Left, N), instance(Instance,Context), path_instance(Instance,Right,X).
% TODO: Is division possible in fclingo?

% Imply statements
&sus{ (Instance,Formula) } =: (Name,(Instance,0)) :- imply((Context,_),Name,Formula), instance(Instance,Context).

% Show statement for numeric values
#show val(X,V) : val(X,V), instance(X,Feature), feature(_,Feature,"num",_,_).
% &show { (Feature,(Instance,0)) : feature(Context,Feature,"num",_,_), instance(Instance,Context) }.

#defined range/4.
#defined function/4.
#defined imply/3.
