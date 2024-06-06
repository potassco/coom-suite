instance((),"") :- structure("").

% Generate enumeration and attribute values
instance((Feature,(Instance,0)),Type) :- feature(Context,Feature,Type,_,_), enumeration(Type), instance(Instance,Context).
{ val((Instance),Option) : option(Type,Option) } :- instance(Instance,Type).
:-  { val(Instance,Option) : option(Type,Option) } != 1, enumeration(Type), instance(Instance,Type).

% Derive associated attribute values (the index 0 is needed for the sake of uniformity)
val((Attr,(Instance,0)),V)       :- attribute(Type,Attr,"str"), attr_value(Type,Option,Attr,V),
                                    instance(Instance,Type), val(Instance,Option).
&in{V..V} =: (Attr,(Instance,0)) :- attribute(Type,Attr,"num"), attr_value(Type,Option,Attr,V),
                                    instance(Instance,Type), val(Instance,Option).


% Create auxiliary instance predicate for attribute values (for following path expressions)
instance((Attr,(Instance,0)),Attr) :- attr_value(Type,_,Attr,_), instance(Instance,Type).

%%% Constraints
% Instantiate constraint for each instance
constraint(Instance,Constraint) :- behavior(Constraint), context(Constraint,Context), instance(Instance,Context).
:- constraint(Instance,Constraint), unsat(Instance,Constraint,_).

% Require without condition
% require must not be false to be satisfied (can be undefined)
unsat(Instance,Constraint,(CX,RX)) :-   condition(Constraint,CBinary),      require(Constraint,RBinary),
                                        binary_sat(Instance,CBinary,CX),    binary_unsat(Instance,RBinary,RX),
                                        constraint(Instance,Constraint).
% Require with condition
% condition has to be true to become active (must not be undefined)
unsat(Instance,Constraint,X) :- not condition(Constraint,_),     require(Constraint,Binary),
                                constraint(Instance,Constraint), binary_unsat(Instance,Binary,X).
% Combinations Table (only for allow)
% check for every possible combination of values
unsat(Instance,Constraint,CI) :- combinations(Constraint,_,_), constraint(Instance,Constraint),
                                 combinations_instances(Instance,Constraint,CI), not hit_row(Instance,Constraint,CI).

% Satisfaction of binary relations
binary_instances(Instance,Formula,X1,Operator,X2) :- binary(Context,Formula,Path1,Operator,Path2), instance(Instance,Context),
                                                     path_instance(Instance,Path1,X1),
                                                     path_instance(Instance,Path2,X2).

binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,"=", X2), V1 = V2,  val(X1,V1), val(X2,V2).
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,"!=",X2), V1 != V2, val(X1,V1), val(X2,V2).
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,">", X2), V1 > V2,  val(X1,V1), val(X2,V2).
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,">=",X2), V1 >= V2, val(X1,V1), val(X2,V2).
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,"<", X2), V1 < V2,  val(X1,V1), val(X2,V2).
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,"<=",X2), V1 <= V2, val(X1,V1), val(X2,V2).

binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,"=",X2),  &sum{X1} =  X2.
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,"!=",X2), &sum{X1} != X2.
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,">",X2),  &sum{X1} >  X2.
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,">=",X2), &sum{X1} >= X2.
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,"<",X2),  &sum{X1} <  X2.
binary_sat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,"<=",X2), &sum{X1} <= X2.

binary_unsat(Instance,Formula,(X1,X2)) :- binary_instances(Instance,Formula,X1,_,X2), not binary_sat(Instance,Formula,(X1,X2)).

%%% Get values of path expressions
path_instance(Instance,Path) :- binary(Context,_,Path,_,_),       path(Path,0,_), instance(Instance,Context).
path_instance(Instance,Path) :- binary(Context,_,_,_,Path),       path(Path,0,_), instance(Instance,Context).
path_instance(Instance,Path) :- combinations(Constraint,_,Path),  path(Path,0,_), instance(Instance,Context),
                                context(Constraint,Context).

path_instance(Instance,Path,0,X)  :- path(Path,0,Name),
                                     path_instance(Instance,Path), instance(X,_), X=(Name,(Instance,_)).
path_instance(Instance,Path,N,X') :- path(Path,N,Name),
                                     path_instance(Instance,Path,N-1,X), instance(X',_), X'=(Name,(X,_)).

path_instance(Instance,Path,X)    :- not path(Path,N+1,_), path_instance(Instance,Path,N,X).

% Constants and numbers
% TODO: Also needed for first argument?
path_instance(Instance,Path,Path) :- binary(Context,_,_,_,Path), instance(Instance,Context), constant(Path).
path_instance(Instance,Path,Path) :- binary(Context,_,_,_,Path), instance(Instance,Context), number(Path,_).

val(Path,Path)      :- constant(Path).
&in{N..N} =: Path   :- number(Path,N).

%%% Check combinations
% Generate all possible values of combinations first
combinations_instances(Instance,Constraint,Col,(X,())) :- constraint(Instance,Constraint),
                                                          combinations(Constraint,Col,Path), not combinations(Constraint,Col+1,_),
                                                          path_instance(Instance,Path,X).
combinations_instances(Instance,Constraint,Col,(X',X)) :- combinations_instances(Instance,Constraint,Col+1,X),
                                                          combinations(Constraint,Col,Path), Col >= 0,
                                                          path_instance(Instance,Path,X').
combinations_instances(Instance,Constraint,CI)         :- combinations_instances(Instance,Constraint,0,CI).

in_path((V,CI'),CI',V)    :- combinations_instances(_,_,(V,CI')).
in_path(CI,CI',V)         :- in_path(CI,(V,CI'),_).
in_path(CI,V)             :- in_path(CI,_,V).

hit_cell(Instance,Constraint,CI,(Col,Row)) :- allow(Constraint,(Col,Row),V), combinations(Constraint,Col,Path), constraint(Instance,Constraint),
                                              combinations_instances(Instance,Constraint,CI), in_path(CI,X), val(X,V).
hit_cell(Instance,Constraint,CI,(Col,Row)) :- allow(Constraint,(Col,Row),V), combinations(Constraint,Col,Path), constraint(Instance,Constraint),
                                              combinations_instances(Instance,Constraint,CI), in_path(CI,X), &sum{X} = V.
hit_row(Instance,Constraint,CI) :- allow(Constraint,(_,Row),_), constraint(Instance,Constraint),
                                   combinations_instances(Instance,Constraint,CI),
                                   0 = #sum{ 1,Col: allow(Constraint,(Col,Row),_);
                                             -1,Col': hit_cell(Instance,Constraint,CI,(Col',Row)) }.

% Always include boolean enumeration
enumeration("bool").
option("bool", "True").
option("bool", "False").

% Show statements
#show .
#show instance(I,S) : instance(I,S), structure(S).

#show val(X,V) : val(X,V), instance(X,Type), option(Type,_).
#show val(X,V) : val(X,V), instance(X,Attr), attr_value(_,_,Attr,_).

% &show { X : instance(X,Attr), attribute(_,Attr,"num") }.

#defined structure/1.
#defined feature/5.
#defined enumeration/1.
#defined option/2.
#defined attribute/3.
#defined attr_value/4.
#defined behavior/1.
#defined context/2.
#defined require/2.
#defined condition/2.
#defined combinations/3.
#defined allow/3.
#defined binary/5.
#defined function/4.
#defined path/3.
#defined constant/1.
#defined number/2.
#defined imply/3.
