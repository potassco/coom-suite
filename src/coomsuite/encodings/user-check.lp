% Check that variables exist
:- user_value(X,_), not type(X,_).
:- user_include(X), not type(X,_).

% Check variable type
:- user_include(X), type(X,T), not part(T).
:- user_value(X,V), type(X,T), #false : discrete(T); #false : integer(T).

% Check valid domain
:- user_value(X,V), type(X,T), not domain(T,V).

% Check max cardinality not exceeded
