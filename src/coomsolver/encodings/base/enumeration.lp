% Always include root instance
included("").

% Generate enumeration values
{ val(X,Option) : enum_type(X,Type), option(Type,Option) }.

% Enumeration variables are always included when its parents are included
included(X) :- enum_type(X,_), parent(X,Parent), included(Parent).

% No value if variable has not been included
:- enum_type(X,_), val(X,_),  not included(X).

% Exactly one value if variable has been included
:- enum_type(X,_), included(X), not { val(X,_) } = 1.

% Attribute variables are included when their enumeration variables are included.
included(X) :- attr_enum(X,X'), included(X').

% Derive associated attribute values
attr_aux(X,V) :- attr_value(Type,Option,Name,V),
                 attr_enum(X,X'), enum_type(X',Type), attr_name(X,Name),
                 val(X',Option).



% Show statements
#show .

#show val(X,V) : val(X,V), enum_type(X,_).
