% Generate exactly one value for each discrete attribute if it is included
{ value(X,V) : domain(T,V) } = 1 :- include(X), type(X,T), discrete(T).

% { value(X,O) : type(X,T), enumeration(T), option(T,O) } 1.
% % No value if variable has not been included
% :- type(X,T), value(X,_),  not include(X).
% % Exactly one value if variable has been included
% :- attribute(T,_), type(X,T), include(X), not { value(X,_) } = 1.

% Auxiliary values for (non-numeric) constants
value(P,P) :- constant(P).
