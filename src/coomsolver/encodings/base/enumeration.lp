% Always include root instance
included("root").

% Generate enumeration values
{ val(X,O) : enumeration_type(X,T), option(T,O) }.

% Enumeration variables are always included when its parents are included
included(X) :- enumeration_type(X,_), parent(X,P), included(P).

% No value if variable has not been included
:- enumeration_type(X,_), val(X,_),  not included(X).

% Exactly one value if variable has been included
:- enumeration_type(X,_), included(X), not { val(X,_) } = 1.

% Attribute variables are included when their enumeration variables are included.
included(X) :- attribute_enumeration(X,X'), included(X').

% Derive associated attribute values
attribute_aux(X,V) :- attribute_value(T,O,N,V),
                      attribute_enumeration(X,X'), enumeration_type(X',T), attribute_name(X,N),
                      val(X',O).

% Show statements
#show .
#show val(X,V) : val(X,V), enumeration_type(X,_).
