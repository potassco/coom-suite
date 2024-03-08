instance((),":root") :- structure(":root").

% Generate enumeration and attribute values
instance((Feature,(Instance,0)),Type) :- feature(Context,Feature,Type,Min,_), enumeration(Type), instance(Instance,Context).
{ val((Instance),Option) : option(Type,Option) } :- instance(Instance,Type).
:-  { val(Instance,Option) : option(Type,Option) } != 1, enumeration(Type), instance(Instance,Type).

% Derive associated attribute values (the index 0 is needed for the sake of uniformity)
val((Attr,(Instance,0)),V)       :- attribute(Type,Attr,"str"), attr_value(Type,Option,Attr,V),
                                    instance(Instance,Type), val(Instance,Option).
&in{V..V} =: (Attr,(Instance,0)) :- attribute(Type,Attr,"num"), attr_value(Type,Option,Attr,V),
                                    instance(Instance,Type), val(Instance,Option).


% Create auxiliary instance predicate for paths
instance((Attr,(Instance,0)),Attr) :- attr_value(Type,_,Attr,_), instance(Instance,Type).

%%% Constraints
% Instantiate constraint for each instance
constraint(Instance,(Context,Idx)) :- behavior((Context,Idx)), instance(Instance,Context).
:- constraint(Instance,Constraint), unsat(Instance,Constraint).

% Require without condition
unsat(Instance,Constraint) :- condition(Constraint,CBinary),     require(Constraint,RBinary),
                              binary_sat(Instance,CBinary),  not binary_sat(Instance,RBinary),
                              constraint(Instance,Constraint).
% Require with condition
unsat(Instance,Constraint) :- not condition(Constraint,_),     require(Constraint,Binary),
                              constraint(Instance,Constraint), not binary_sat(Instance,Binary).
% Combinations Table (only for allow)
unsat(Instance,Constraint) :- combinations(Constraint,_,_),
                              constraint(Instance,Constraint), not hit_row(Instance,Constraint).


% Satisfaction of binary relations
binary_instance(Instance,Formula,Path1,Operator,Path2) :- binary(Context,Formula,Path1,Operator,Path2), instance(Instance,Context).
binary_values(Instance,Formula,V1,Operator,V2) :- binary_instance(Instance,Formula,Path1,Operator,Path2),
                                                path_value(Instance,Path1,V1),
                                                path_value(Instance,Path2,V2).

binary_sat(Instance,Formula) :- binary_values(Instance,Formula,V1,"=",V2),  V1 = V2.
binary_sat(Instance,Formula) :- binary_values(Instance,Formula,V1,"!=",V2), V1 != V2.
binary_sat(Instance,Formula) :- binary_values(Instance,Formula,V1,">",V2),  V1 > V2.
binary_sat(Instance,Formula) :- binary_values(Instance,Formula,V1,">=",V2), V1 >= V2.
binary_sat(Instance,Formula) :- binary_values(Instance,Formula,V1,"<",V2),  V1 < V2.
binary_sat(Instance,Formula) :- binary_values(Instance,Formula,V1,"<=",V2), V1 <= V2.

binary_sat(Instance,Formula) :- binary_instance(Instance,Formula,Path1,"=",Path2),  &sum{path_value(Instance,Path1)} =  path_value(Instance,Path2).
binary_sat(Instance,Formula) :- binary_instance(Instance,Formula,Path1,"!=",Path2), &sum{path_value(Instance,Path1)} != path_value(Instance,Path2).
binary_sat(Instance,Formula) :- binary_instance(Instance,Formula,Path1,">",Path2),  &sum{path_value(Instance,Path1)} >  path_value(Instance,Path2).
binary_sat(Instance,Formula) :- binary_instance(Instance,Formula,Path1,">=",Path2), &sum{path_value(Instance,Path1)} >= path_value(Instance,Path2).
binary_sat(Instance,Formula) :- binary_instance(Instance,Formula,Path1,"<",Path2),  &sum{path_value(Instance,Path1)} <  path_value(Instance,Path2).
binary_sat(Instance,Formula) :- binary_instance(Instance,Formula,Path1,"<=",Path2), &sum{path_value(Instance,Path1)} <= path_value(Instance,Path2).

%%% Get values of path expressions
path_instance(Instance,Path) :- binary(Context,_,Path,_,_),       path(Path,0,_), instance(Instance,Context).
path_instance(Instance,Path) :- binary(Context,_,_,_,Path),       path(Path,0,_), instance(Instance,Context).
path_instance(Instance,Path) :- combinations((Context,_),_,Path), path(Path,0,_), instance(Instance,Context).

path_instance(Instance,Path,0,Instance2) :- path(Path,0,Name),
                                            path_instance(Instance,Path), instance(Instance2,_), Instance2=(Name,(Instance,_)).
path_instance(Instance,Path,N,Instance3) :- path(Path,N,Name),
                                            path_instance(Instance,Path,N-1,Instance2), instance(Instance3,_), Instance3=(Name,(Instance2,_)).

path_instance(Instance,Path,Instance2) :- not path(Path,N+1,_), path_instance(Instance,Path,N,Instance2).

path_value(Instance,Path,V)                     :- path_instance(Instance,Path,Instance2), val(Instance2,V).
&sus{ Instance2 } =: path_value(Instance,Path)  :- path_instance(Instance,Path,Instance2).

% Constants and numbers
% TODO: Also needed for first argument?
path_value(Instance,Path,Path) :- binary(Context,_,_,_,Path), instance(Instance,Context), constant(Path).
&in{N..N} =: path_value(Instance,Path) :- binary(Context,_,_,_,Path), instance(Instance,Context), number(Path,N).

%%% Check combinations
hit_cell(Instance,Constraint,(Col,Row)) :- allow(Constraint,(Col,Row),V), combinations(Constraint,Col,Path),
                                            constraint(Instance,Constraint), path_value(Instance,Path,V).
hit_cell(Instance,Constraint,(Col,Row)) :- allow(Constraint,(Col,Row),V), combinations(Constraint,Col,Path),
                                            constraint(Instance,Constraint), &sum{path_value(Instance,Path)} = V.
hit_row(Instance,Constraint) :- allow(Constraint,(_,Row),_), constraint(Instance,Constraint),
                                    0 = #sum{ 1,Col: allow(Constraint,(Col,Row),_); -1,Col': hit_cell(Instance,Constraint,(Col',Row)) }.

% Always include boolean enumeration
enumeration("bool").
option("bool", "True").
option("bool", "False").

% Show statements
#show instance(I,S) : instance(I,S), structure(S).
#show val/2.
% &show { (Attr,(Instance,0))    : attribute(Context,Attr,"num"), instance(Instance,Context) }.

#defined structure/1.
#defined feature/5.
#defined enumeration/1.
#defined option/2.
#defined attribute/3.
#defined attr_value/4.
#defined behavior/1.
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
