instance(Instance,":root") :- structure_instance(Instance,":root",0).

% Generate enumeration and attribute values
instance(Instance,Type) :- feature(Context,_,Type,_,_), enumeration_instance(Instance,Type), parent(Instance,Parent), instance(Parent,Context).
{ val(Instance,Option) : option(Type,Option) } :-        enumeration(Type), instance(Instance,Type).
:-  { val(Instance,Option) : option(Type,Option) } != 1, enumeration(Type), instance(Instance,Type).

% Derive associated attribute values
val(AtInstance,V) :- attr_instance(AtInstance,Instance), attr_value(Type,Option,_,V), instance(Instance,Type), val(Instance,Option).

%%% Constraints
:- constraint(Constraint), unsat(Constraint).

% Require without condition
% Require must not be false to be satisfied (can be undefined)
unsat(Constraint) :- condition(Constraint,CBinary), require(Constraint,RBinary),
                     binary_sat(CBinary),           binary_unsat(RBinary).

% Require with condition
% Condition has to be true to become active (must not be undefined)
unsat(Constraint) :- not condition(Constraint,_), require(Constraint,Binary), binary_unsat(Binary).

% Combinations Table (only for allow)
% Table constraint is satisfied if a row is satisfied
unsat(Constraint) :- combinations(Constraint,_,_), not hit_row(Constraint), not combinations_undef(Constraint).

% Satisfaction of binary relations
binary_def(Formula) :- binary(Formula,X1,_,X2), val(X1,_), val(X2,_).

binary_sat(Formula) :- binary(Formula,X1,"=", X2), V1 = V2,  val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,"!=",X2), V1 != V2, val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,">", X2), V1 > V2,  val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,">=",X2), V1 >= V2, val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,"<", X2), V1 < V2,  val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,"<=",X2), V1 <= V2, val(X1,V1), val(X2,V2).

binary_unsat(Formula) :- binary(Formula,_,_,_), binary_def(Formula), not binary_sat(Formula).

%%% Check combinations
hit_cell(Constraint,(Col,Row)) :- allow(Idx,(Col,Row),V), combinations(Constraint,Col,X), val(X,V), Constraint=(Idx,_).

hit_row(Constraint) :- allow(Idx,(_,Row),_), combinations(Constraint,_,_), Constraint=(Idx,_),
                       0 = #sum{ 1,Col: allow(Idx,(Col,Row),_);
                                -1,Col': hit_cell(Constraint,(Col',Row)) }.

combinations_undef(Constraint) :- combinations(Constraint,_,X), not val(X,_).

% Always include boolean enumeration
enumeration("bool").
option("bool", "True").
option("bool", "False").

% Auxiliary val/2 atoms for constants and numbers.
val(Path,Path) :- constant(Path).
val(Path,N)    :- number(Path,N).


% Show statements
#show .
#show instance(I,S) : structure_instance(I,S,_).

#show val(X,V) : val(X,V), enumeration_instance(X,_).
#show val(X,V) : val(X,V), attr_instance(X,_).

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
