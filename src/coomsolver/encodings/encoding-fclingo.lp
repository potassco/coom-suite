#include "encoding-fclingo-kids.lp".

% Always generate minimal number of objects
instance((Feature,(Instance,0..Min-1)),Structure) :- feature(Context,Feature,Structure,Min,_), structure(Structure), instance(Instance,Context).

% Optionally generate additional objects
{ instance((Feature,(Instance,Idx)),Structure) : Idx = Min..Max-1 } :- feature(Context,Feature,Structure,Min,Max), structure(Structure), instance(Instance,Context).

% Indices in ascending order
:- instance((Feature,(Instance,Idx)),_), not instance((Feature,(Instance,Idx-1)),_), Idx > 0.

% Assign a value to a numeric feature
&in{Min..Max} =: (Feature,(Instance,0)) :- feature(Context,Feature,"num",_,_), range(Context,Feature,Min,Max), instance(Instance,Context).

% Create auxiliary instance predicate for paths
instance((Feature,(Instance,0)),Feature) :- feature(Context,Feature,"num",_,_), instance(Instance,Context).

% Paths which point to instances (not attributes)
path_instance(Instance,Path) :- function(Context,_,_,Path), path(Path,0,_), instance(Instance,Context).

% Evaluate functions (aggregates)
% Assumes that every function and every term in an arithmetic expression points to a single path
&sus{ 1,Instance2 : path_instance(Instance,Path,Instance2) } =: path_value(Instance,Function)
                        :- function(Context,Function,"count",Path), instance(Instance,Context).

&sus{ Instance2 : path_instance(Instance,Path,Instance2) } =: path_value(Instance,Function)
                        :- function(Context,Function,"sum",Path), instance(Instance,Context).

&min{ Instance2 : path_instance(Instance,Path,Instance2) } =: path_value(Instance,Function)
                        :- function(Context,Function,"min",Path), instance(Instance,Context).

&max{ Instance2 : path_instance(Instance,Path,Instance2) } =: path_value(Instance,Function)
                        :- function(Context,Function,"max",Path), instance(Instance,Context).

% Arithmetics
&sus{ path_value(Instance,Left);  path_value(Instance,Right) } =: path_value(Instance,Formula) :- binary(Context,Formula,Left,"+",Right), instance(Instance,Context).
&sus{ path_value(Instance,Left); -path_value(Instance,Right) } =: path_value(Instance,Formula) :- binary(Context,Formula,Left,"-",Right), instance(Instance,Context).

% Only linear constraints are supported
&sus{ path_value(Instance,Left) *N } =: path_value(Instance,Formula) :- binary(Context,Formula,Left,"*",Right), number(Right,N), instance(Instance,Context).
&sus{ path_value(Instance,Right)*N } =: path_value(Instance,Formula) :- binary(Context,Formula,Left,"*",Right), number(Left, N), instance(Instance,Context).
% TODO: Is division possible in fclingo?

% Imply statements
&sus{ path_value(Instance,Formula) } =: (Name,(Instance,0)) :- imply((Context,_),Name,Formula), instance(Instance,Context).

% &show { (Feature,(Instance,0)) : feature(Context,Feature,"num",_,_), instance(Instance,Context) }.

#defined range/4.
#defined function/4.
#defined imply/3.
