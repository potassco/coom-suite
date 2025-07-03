#program new_constraint(c,type).
% A lower bound (cardinality) constraint is violated if less than the minimum number of objects are included
% (objects are included in ascending order of indices)
% (maximum does not need to be checked)
violated((X',P)) :- c = (P,MIN), constraint((P,Min),type), set(P,X), index(X,Min-1), not include(X), parent(X,X'), include(X'), type ="lowerbound".

% TODO: change arguments of this program part
#program new_constraint(c,type).
#external active(index). % needs to be part of parameters
% can the arguments to violated de infered directly from program part parameters?
:- violated(C), active(index).
