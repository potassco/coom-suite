% Always include root instance
include("root").

% Attribute variables are always included when its parents are included
include(X) :- type(X,T), parent(X,P), include(P), attribute(T,_).


% % Generate enumeration values
% { value(X,O) : type(X,T), enumeration(T), option(T,O) } 1.

% % No value if variable has not been included
% % Can be made general as structures do not have value/2
% :- type(X,T), value(X,_),  not include(X).

% % Exactly one value if variable has been included
% :- enumeration(T), type(X,T), include(X), not { value(X,_) } = 1.

% More readable
{ value(X,O) : domain(T,O) } = 1 :- include(X), type(X,T), attribute(T,"discrete").

{ value(X,O) : domain(T,O) } = 1 :- include(X), type(X,T), attribute(T,"numeric"). % TODO: Separate for fclingo or how?

% Show statements
#show .
#show value(X,V) : value(X,V), type(X,T), attribute(T,_).
