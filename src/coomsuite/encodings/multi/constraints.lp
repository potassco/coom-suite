#program new_constraint(c,type).
% A lower bound (cardinality) constraint is violated if less than the minimum number of objects are included
% (objects are included in ascending order of indices)
% (maximum does not need to be checked)
violated((X',P)) :- c = (P,MIN), constraint((P,Min),type), set(P,X), index(X,Min-1), not include(X), parent(X,X'), include(X'), type ="lowerbound".

#program new_constraint(c,type).
% TODO: arguments of violated directly as program part parameters?
% (parameter differs depending on type of constraint)
% TODO: add external to deactivate constraint
% active/1 with argument being the bound
% alt active/2 with argument bound and wich set -> needed if different bounds per unbounded cardinality
:- violated(C).
