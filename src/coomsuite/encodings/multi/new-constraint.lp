#program new_constraint(c,type,bound).
#external active(bound).
constraint(c,type).

% boolean constraints
violated(c) :- constraint(c,type), defined(F), not satisfied(F), c = (C,F), type = "boolean".

% table constraints
violated((c,ID)) :- constraint(c,type), defined(c,ID), not satisfied(c,ID), type = "table".

% lower bound constraints
violated((X',P)) :- c = (P,MIN), constraint((P,Min),type), set(P,X), index(X,Min-1), not include(X), parent(X,X'), include(X'), type ="lowerbound".

% constraint violations are only checked if the bound is active
:- violated(C), active(bound).
