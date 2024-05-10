% Constraints cannot be unsatisfied
:- constraint(Constraint), unsat(Constraint,_).

% Require without condition
% Require must not be false to be satisfied (can be undefined)
unsat(Constraint,B) :- not condition_instance(Constraint,_), require_instance(Constraint,B), -binary_sat(B).

% Require with condition
% Condition has to be true to become active (must not be undefined)
unsat(Constraint,(CB,RB)) :- condition_instance(Constraint,CB), require_instance(Constraint,RB),
                             binary_sat(CB),                    -binary_sat(RB).

% Combinations Table (only for allow)
% Table constraint is satisfied if a row is satisfied
unsat(Constraint,ID) :- combinations_instance(Constraint,ID,_,_), not hit_row(Constraint,ID), combinations_def(Constraint,ID).

% Satisfaction of binary relations
binary_def(Formula) :- binary(Formula,X1,_,X2), val(X1,_), val(X2,_).

binary_sat(Formula) :- binary(Formula,X1,"=", X2), V1 = V2,  val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,"!=",X2), V1 != V2, val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,">", X2), V1 > V2,  val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,">=",X2), V1 >= V2, val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,"<", X2), V1 < V2,  val(X1,V1), val(X2,V2).
binary_sat(Formula) :- binary(Formula,X1,"<=",X2), V1 <= V2, val(X1,V1), val(X2,V2).

% Strong negation of binary satisfaction if formula is defined and not satisfied
-binary_sat(Formula) :- binary(Formula,_,_,_), binary_def(Formula), not binary_sat(Formula).

%%% Check combinations
hit_cell(Constraint,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), combinations_instance(Constraint,ID,Col,X), val(X,V), Constraint=(Idx,_).

hit_row(Constraint,ID) :- allow(Idx,(_,Row),_), combinations_instance(Constraint,ID,_,_), Constraint=(Idx,_),
                       0 = #sum{ 1,Col: allow(Idx,(Col,Row),_);
                                -1,Col': hit_cell(Constraint,ID,(Col',Row)) }.

combinations_def(Constraint,ID,Col) :- combinations_instance(Constraint,ID,Col,X), val(X,_).
combinations_def(Constraint,ID) :- combinations_instance(Constraint,ID,_,_),
                                   0 = #sum{ 1, Col: combinations_instance(Constraint,ID,Col,_);
                                            -1, Col: combinations_def(Constraint,ID,Col)}.
