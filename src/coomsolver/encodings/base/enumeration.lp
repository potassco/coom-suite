% Always include root instance
included("root").
% Enumeration variables are always included when its parents are included
included(X) :- enumeration(T), type(X,T), parent(X,P), included(P).
% Attribute variables are included when their enumeration variables are included (can only have enumeration as parent)
included(X) :- enumeration(T), type(X',T), included(X'), parent(X,X').

% % Generate enumeration values
% { val(X,O) : type(X,T), enumeration(T), option(T,O) } 1.

% % No value if variable has not been included
% % Can be made general as structures do not have val/2
% :- type(X,T), val(X,_),  not included(X).

% % Exactly one value if variable has been included
% :- enumeration(T), type(X,T), included(X), not { val(X,_) } = 1.

% More readable
1 { val(X,O) : type(X,T), enumeration(T), option(T,O) } 1 :- included(X).


% Derive associated attribute values
attribute_aux(X,V) :- attribute_value(T,O,N,V),
                      type(X,N), parent(X,X'), type(X',T),
                      val(X',O).

% Show statements
#show .
#show val(X,V) : val(X,V), type(X,T), enumeration(T).
