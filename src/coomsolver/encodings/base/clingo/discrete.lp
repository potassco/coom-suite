% Generate exactly one value for each attribute if it is included
{ value(X,V) : domain(T,V) } = 1 :- include(X), type(X,T), attribute(T,"discrete").

% { value(X,O) : type(X,T), enumeration(T), option(T,O) } 1.
% % No value if variable has not been included
% :- type(X,T), value(X,_),  not include(X).
% % Exactly one value if variable has been included
% :- attribute(T,_), type(X,T), include(X), not { value(X,_) } = 1.

% Show statements
#show .
#show value(X,V) : value(X,V), type(X,T), attribute(T,_).
