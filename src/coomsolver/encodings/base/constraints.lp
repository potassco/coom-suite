% Constraints cannot be unsatisfied
:- constraint(C), unsatisfied(C,_).

% Require without condition
% Require must not be false to be satisfied (can be undefined)
unsatisfied(C,B) :- not condition(I), require(C,B), C = (I,_),
                    -satisfied(B).

% Require with condition
% Condition has to be true to become active (must not be undefined)
unsatisfied(C,(BC,BR)) :- condition(C,BC), require(C,BR),
                          satisfied(BC),   -satisfied(BR).

% Combinations Table (only for allow)
% Table constraint is satisfied if a row is satisfied
unsatisfied(C,ID) :- column(C,ID,_,_), not hit_row(C,ID), defined(C,ID).

% Satisfaction of binary relations
defined(F) :- binary(F,X1,_,X2), value(X1,_), value(X2,_).

satisfied(F) :- binary(F,X1,"=", X2), V1 = V2,  value(X1,V1), value(X2,V2).
satisfied(F) :- binary(F,X1,"!=",X2), V1 != V2, value(X1,V1), value(X2,V2).
satisfied(F) :- binary(F,X1,">", X2), V1 > V2,  value(X1,V1), value(X2,V2).
satisfied(F) :- binary(F,X1,">=",X2), V1 >= V2, value(X1,V1), value(X2,V2).
satisfied(F) :- binary(F,X1,"<", X2), V1 < V2,  value(X1,V1), value(X2,V2).
satisfied(F) :- binary(F,X1,"<=",X2), V1 <= V2, value(X1,V1), value(X2,V2).

% Strong negation of binary satisfaction if formula is defined and not satisfied
-satisfied(F) :- binary(F,_,_,_), defined(F), not satisfied(F).

%%% Check combinations
hit_cell(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), column(C,ID,Col,X), value(X,V), C=(Idx,_).

hit_row(C,ID) :- allow(Idx,(_,Row),_), column(C,ID,_,_), C=(Idx,_),
                 0 = #sum{ 1,Col : allow(Idx,(Col,Row),_);
                          -1,Col': hit_cell(C,ID,(Col',Row)) }.

defined(C,ID,Col) :- column(C,ID,Col,X), value(X,_).
defined(C,ID)     :- column(C,ID,_,_), 0 = #sum{ 1, Col: column(C,ID,Col,_);
                                                -1, Col: defined(C,ID,Col)}.
