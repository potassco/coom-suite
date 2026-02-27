% Generate possible associations in the required range
% Min { associate((X,XT)) : type(XT,T), include(XT) } Max :- association(X,T,Min,Max), include(X).

% Assign index to associations
% associate(A,I) :- associate(A), A = (X,XT), I = #count{ XT': associate((X,XT')), XT' < XT }.

% Cannot associate the same object twice
% :- associate((X1,X)), associate((X2,X)), X1 < X2. % TODO: part of the behavior? TODO: X1 and X2 of the same type?

% Require that bidirectional associations have to be mutual (?)
% :- association(X,T',_,_), association(X',T,_,_), type(X,T), type(X',T'), associate((X,X')), not associate((X',X)).

% Replace association variables with their actual associations
% value(X,V) :- replace((X,X'),(A,I)), associate(A,I), value(X',V).
% include(X) :- replace((X,X'),(A,I)), associate(A,I), include(X').

% -------------------------------------------------

% Generate possible associations in the required range
Min { associate((X,X'),N) : type(X',T), include(X') } Max :- association(X,T,N,Min,Max), include(X).
associate(A,N,I) :- associate(A,N), A = (X,XT), I = #count{ XT': associate((X,XT'),N), XT' < XT }.

% Match bidirectional associations
:- association(X,T,N,_,_), association_match(X,N,N'), associate((X,X'),N,_), not associate((X',X),N',_).

value(X,V) :- replace(((X,X'),ID),_), value(X',V), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
include(X) :- replace(((X,X'),ID),_), include(X'), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).

% -------------------------------------------------

% MIN { assoc(P1X,N1,P2X,N2) : type(P2X,P2), name(P2,P1,N2) } MAX :- associate(P1,P2,N1,MIN,MAX), type(P1X,P1), P1 < P2.
% MIN { assoc(P1X,N1,P2X,N2) : type(P2X,P2), name(P2,P1,N2) } MAX :- associate(P1,P2,N1,MIN,MAX), type(P1X,P1), P2 < P1.

% 1 { assoc(element[0],mdl,,associate(element,module,mdl,1,1), type(element[0],element).
