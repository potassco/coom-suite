#include "encoding-kids.lp".

% Always generate minimal number of objects
instance((Feature,(Instance,0..Min-1)),Structure) :- feature(Context,Feature,Structure,Min,_), structure(Structure), instance(Instance,Context).

% Optionally generate additional objects
{ instance((Feature,(Instance,Idx)),Structure) : Idx = Min..Max-1 } :- feature(Context,Feature,Structure,Min,Max), structure(Structure), instance(Instance,Context).

% Indices in ascending order
:- instance((Feature,(Instance,Idx)),_), not instance((Feature,(Instance,Idx-1)),_), Idx > 0.

% Assign a value to a numeric feature which is not calculated by an imply statement
not_imply(Context,Feature) :- range(Context,Feature,_,_), not imply((Context,_),Feature,_).

{ val((Feature,(Instance,0)),V) : V = Min..Max }
        :- range(Context,Feature,Min,Max), instance(Instance,Context), not_imply(Context,Feature).
:- { val((Feature,(Instance,0)),V) } != 1, feature(Context,Feature,"num",_,_), instance(Instance,Context).

% Check ranges
:- range(Context,Feature,Min,Max), instance(Instance,Context), val((Feature,(Instance,0)),V), not Min <= V <= Max.

% Create auxiliary instance predicate for paths
instance((Feature,(Instance,0)),Feature) :- feature(Context,Feature,"num",_,_), instance(Instance,Context).


% Paths which point to instances (not attributes)
path_instance(Instance,Path) :- function(Context,_,_,Path), path(Path,0,_), instance(Instance,Context).
path_instance(Instance,Path) :- imply((Context,_),_,Path), path(Path,0,_), instance(Instance,Context).

% Evaluate functions (aggregates)
% Assumes that every function and every term in an arithmetic expression points to a single path
path_value(Instance,Function,V) :- function(Context,Function,"count",Path), instance(Instance,Context),
                                   V = #count{ Instance2: path_instance(Instance,Path,Instance2) }.
path_value(Instance,Function,V) :- function(Context,Function,"sum",Path),   instance(Instance,Context),
                                   V = #sum  { V',Instance2: path_instance(Instance,Path,Instance2), val(Instance2,V') }.
path_value(Instance,Function,V) :- function(Context,Function,"min",Path),   instance(Instance,Context),
                                   V = #min  { V',Instance2: path_instance(Instance,Path,Instance2), val(Instance2,V') }.
path_value(Instance,Function,V) :- function(Context,Function,"max",Path),   instance(Instance,Context),
                                   V = #max  { V',Instance2: path_instance(Instance,Path,Instance2), val(Instance2,V') }.

% Arithmetics
path_value(Instance,Formula,V1+V2) :- binary(Context,Formula,Left,"+",Right), instance(Instance,Context),
                                      path_value(Instance,Left,V1), path_value(Instance,Right,V2).
path_value(Instance,Formula,V1-V2) :- binary(Context,Formula,Left,"-",Right), instance(Instance,Context),
                                      path_value(Instance,Left,V1), path_value(Instance,Right,V2).
path_value(Instance,Formula,V1*V2) :- binary(Context,Formula,Left,"*",Right), instance(Instance,Context),
                                      path_value(Instance,Left,V1), path_value(Instance,Right,V2).
% TODO: Add more arithmetics

% Imply statements
val((Name,(Instance,0)),V) :- imply((Context,_),Name,Formula), instance(Instance,Context), path_value(Instance,Formula,V).

#defined range/4.
#defined function/4.
#defined imply/3.
