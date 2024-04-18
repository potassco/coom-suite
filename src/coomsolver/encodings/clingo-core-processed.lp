% Generate enumeration and attribute values
{ val(Instance,Option) : option(Type,Option) } :-        enumeration(Type), instance(Instance,Type).
:-  { val(Instance,Option) : option(Type,Option) } != 1, enumeration(Type), instance(Instance,Type).

% Derive associated attribute values
val(AtInstance,V) :- attr_instance(AtInstance,Instance), attr_value(Type,Option,Attr,V), instance(Instance,Type), val(Instance,Option).

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
unsat(Constraint) :- combinations(Constraint,_,_), not hit_row(Constraint).

% Satisfaction of binary relations
binary_sat(Formula) :- binary(Formula,X1,"=", X2), V1 = V2,  val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,"!=",X2), V1 != V2, val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,">", X2), V1 > V2,  val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,">=",X2), V1 >= V2, val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,"<", X2), V1 < V2,  val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,"<=",X2), V1 <= V2, val(X1,V1), val(X2,V2).

binary_unsat(Formula) :- binary(Formula,_,_,_), not binary_sat(Formula).

%%% Check combinations
hit_cell(Constraint,(Col,Row)) :- allow(Constraint,(Col,Row),V), combinations(Constraint,Col,X), val(X,V).

hit_row(Constraint) :- allow(Constraint,(_,Row),_),
                       0 = #sum{ 1,Col: allow(Constraint,(Col,Row),_);
                                -1,Col': hit_cell(Constraint,(Col',Row)) }.

% Always include boolean enumeration
enumeration("bool").
option("bool", "True").
option("bool", "False").

% Auxiliary val/2 atoms for constants and numbers.
val(Path,Path) :- constant(Path).
val(Path,N)    :- number(Path,N).


% Show statements
#show .
#show instance(I,S) : instance(I,S), structure(S).

#show val/2.
% #show val(X,V) : val(X,V), instance(X,Type), option(Type,_).
% #show val(X,V) : val(X,V), instance(X,Attr), attr_value(_,_,Attr,_).

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
