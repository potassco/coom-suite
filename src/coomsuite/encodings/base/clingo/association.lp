% Generate possible associations in the required range
Min { associate((X,XT)) : type(XT,T), include(XT) } Max :- association(X,T,Min,Max), include(X).

% Cannot associate the same object twice
:- associate((X1,X)), associate((X2,X)), X1 < X2. % part of the behavior? X1 and X2 of the same type?

% Replace association variables with their actual associations
value(X,V) :- replace((X,X'),A), associate(A), value(X',V).
