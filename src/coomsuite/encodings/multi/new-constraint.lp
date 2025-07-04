#program new_constraint(c,type,bound).
% TODO: can i have same external statement in different program parts?
#external active(bound).
constraint(c,type).

violated(c) :- constraint(c,type), defined(F), not satisfied(F), c = (C,F), type = "boolean".

violated((c,ID)) :- constraint(c,type), defined(c,ID), not satisfied(c,ID), type = "table".

violated((X',P)) :- c = (P,MIN), constraint((P,Min),type), set(P,X), index(X,Min-1), not include(X), parent(X,X'), include(X'), type ="lowerbound".

:- violated(C), active(bound).
