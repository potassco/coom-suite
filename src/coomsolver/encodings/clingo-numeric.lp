% #include "clingo-part.lp".

{ val((Feature,(Instance,0)),V) : V = Min..Max }
        :-  feature(Context,Feature,"num",_,_), range(Context,Feature,Min,Max), instance(Instance,Context), not imply((Context,_),Feature,_).
:- { val((Feature,(Instance,0)),V) } != 1, feature(Context,Feature,"num",_,_), range(Context,Feature,Min,Max), instance(Instance,Context).

% Check ranges
:- range(Context,Feature,Min,Max), instance(Instance,Context), val((Feature,(Instance,0)),V), not Min <= V <= Max.

% Create auxiliary instance predicate for paths
instance((Feature,(Instance,0)),Feature) :- feature(Context,Feature,"num",_,_), instance(Instance,Context).


% Paths which point to instances (not attributes)
path_instance(Instance,Path) :- function(Context,_,_,Path), path(Path,0,_), instance(Instance,Context).
path_instance(Instance,Path) :- imply((Context,_),_,Path), path(Path,0,_), instance(Instance,Context).

% Auxiliary path instances for aggregates and arithmetics
path_instance(Instance,Function,(Instance,Function)) :- function(Context,Function,_,_), instance(Instance,Context).

arithmetic_op(("+";"-";"*";"/")).
path_instance(Instance,Formula,(Instance,Formula))   :- binary(Context,Formula,_,Op,_), instance(Instance,Context), arithmetic_op(Op).

% Evaluate functions (aggregates)
% Assumes that every function and every term in an arithmetic expression points to a single path
val((Instance,Function),V) :- function(Context,Function,"count",Path), instance(Instance,Context),
                                   V = #count{ Instance2: path_instance(Instance,Path,Instance2) }.
val((Instance,Function),V) :- function(Context,Function,"sum",Path),   instance(Instance,Context),
                                   V = #sum  { V',Instance2: path_instance(Instance,Path,Instance2), val(Instance2,V') }.
val((Instance,Function),V) :- function(Context,Function,"min",Path),   instance(Instance,Context),
                                   V = #min  { V',Instance2: path_instance(Instance,Path,Instance2), val(Instance2,V') }.
val((Instance,Function),V) :- function(Context,Function,"max",Path),   instance(Instance,Context),
                                   V = #max  { V',Instance2: path_instance(Instance,Path,Instance2), val(Instance2,V') }.

% Arithmetics
val((Instance,Formula),V1+V2) :- binary(Context,Formula,Left,"+",Right), instance(Instance,Context),
                                 path_instance(Instance,Left,X1), path_instance(Instance,Right,X2),
                                 val(X1,V1), val(X2,V2).
val((Instance,Formula),V1-V2) :- binary(Context,Formula,Left,"-",Right), instance(Instance,Context),
                                 path_instance(Instance,Left,X1), path_instance(Instance,Right,X2),
                                 val(X1,V1), val(X2,V2).
val((Instance,Formula),V1*V2) :- binary(Context,Formula,Left,"*",Right), instance(Instance,Context),
                                 path_instance(Instance,Left,X1), path_instance(Instance,Right,X2),
                                 val(X1,V1), val(X2,V2).
% TODO: Add more arithmetics (division and power)

% Imply statements
val((Name,(Instance,0)),V) :- imply((Context,_),Name,Formula), instance(Instance,Context), val((Instance,Formula),V).

% Show statement for numeric values
#show val(X,V) : val(X,V), instance(X,Feature), feature(_,Feature,"num",_,_).

#defined range/4.
#defined function/4.
#defined imply/3.
