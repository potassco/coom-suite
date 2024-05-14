% Constraints cannot be unsatisfied
:- constraint(C), unsat(C,_).

% Require without condition
% Require must not be false to be satisfied (can be undefined)
unsat(C,B) :- not condition_instance(C,_), require_instance(C,B),
                                           -binary_sat(B).

% Require with condition
% Condition has to be true to become active (must not be undefined)
unsat(C,(BC,BR)) :- condition_instance(C,BC), require_instance(C,BR),
                    binary_sat(BC),           -binary_sat(BR).

% Combinations Table (only for allow)
% Table constraint is satisfied if a row is satisfied
unsat(C,ID) :- combinations_instance(C,ID,_,_), not hit_row(C,ID), combinations_def(C,ID).

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
hit_cell(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), combinations_instance(C,ID,Col,X), val(X,V), C=(Idx,_).

hit_row(C,ID) :- allow(Idx,(_,Row),_), combinations_instance(C,ID,_,_), C=(Idx,_),
                 0 = #sum{ 1,Col: allow(Idx,(Col,Row),_);
                          -1,Col': hit_cell(C,ID,(Col',Row)) }.

combinations_def(C,ID,Col) :- combinations_instance(C,ID,Col,X), val(X,_).
combinations_def(C,ID)     :- combinations_instance(C,ID,_,_),
                              0 = #sum{ 1, Col: combinations_instance(C,ID,Col,_);
                                       -1, Col: combinations_def(C,ID,Col)}.
