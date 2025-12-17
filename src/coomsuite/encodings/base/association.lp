% Generate possible associations in the required range
Min { associate((X,XT)) : type(XT,T), include(XT) } Max :- association(X,T,Min,Max), include(X).

% Cannot associate the same object twice
:- associate((X1,X)), associate((X2,X)), X1 < X2.

% Constraints cannot be violated if their sub-objects are actually associated
:- violated(C), #false : association(C,A), not associate(A).
