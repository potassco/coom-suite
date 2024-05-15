% Constraints cannot be unsatisfied
:- constraint(C), unsat(C,_).

% Require without condition
% Require must not be false to be satisfied (can be undefined)
unsat(C,B) :- not condition(C,_), require(C,B),
                                  -sat(B).

% Require with condition
% Condition has to be true to become active (must not be undefined)
unsat(C,(BC,BR)) :- condition(C,BC), require(C,BR),
                    sat(BC),         -sat(BR).

% Combinations Table (only for allow)
% Table constraint is satisfied if a row is satisfied
unsat(C,ID) :- combinations(C,ID,_,_), not hit_row(C,ID), def(C,ID).

% Satisfaction of binary relations
def(F) :- binary(F,X1,_,X2), val(X1,_), val(X2,_).

sat(F) :- binary(F,X1,"=", X2), V1 = V2,  val(X1,V1), val(X2,V2).
sat(F) :- binary(F,X1,"!=",X2), V1 != V2, val(X1,V1), val(X2,V2).
sat(F) :- binary(F,X1,">", X2), V1 > V2,  val(X1,V1), val(X2,V2).
sat(F) :- binary(F,X1,">=",X2), V1 >= V2, val(X1,V1), val(X2,V2).
sat(F) :- binary(F,X1,"<", X2), V1 < V2,  val(X1,V1), val(X2,V2).
sat(F) :- binary(F,X1,"<=",X2), V1 <= V2, val(X1,V1), val(X2,V2).

% Strong negation of binary satisfaction if formula is defined and not satisfied
-sat(F) :- binary(F,_,_,_), def(F), not sat(F).

%%% Check combinations
hit_cell(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), combinations(C,ID,Col,X), val(X,V), C=(Idx,_).

hit_row(C,ID) :- allow(Idx,(_,Row),_), combinations(C,ID,_,_), C=(Idx,_),
                 0 = #sum{ 1,Col: allow(Idx,(Col,Row),_);
                          -1,Col': hit_cell(C,ID,(Col',Row)) }.

def(C,ID,Col) :- combinations(C,ID,Col,X), val(X,_).
def(C,ID)     :- combinations(C,ID,_,_), 0 = #sum{ 1, Col: combinations(C,ID,Col,_);
                                                  -1, Col: def(C,ID,Col)}.
