% Generate possible associations in the required range
Min { associate((X,XT)) : type(XT,T), include(XT) } Max :- association(X,T,Min,Max), include(X).

% Assign index to associations
associate(A,I) :- associate(A), A = (X,XT), I = #count{ XT': associate((X,XT')), XT' < XT }.

% Cannot associate the same object twice
% :- associate((X1,X)), associate((X2,X)), X1 < X2. % TODO: part of the behavior? TODO: X1 and X2 of the same type?

% Replace association variables with their actual associations
value(X,V) :- replace((X,X'),(A,I)), associate(A,I), value(X',V).
include(X) :- replace((X,X'),(A,I)), associate(A,I), include(X').
