% Check that variables exist
warning("not exists",X) :- user_value(X,_),       not type(X,_).
warning("not exists",X) :- user_include(X),       not type(X,_).
warning("not exists",X) :- user_associate((X,_)), not type(X,_).
warning("not exists",X) :- user_associate((_,X)), not type(X,_).

% Check variable type
% warning("not part",X) :- user_include(X), type(X,T), not part(T).
warning("not attribute",X) :- user_value(X,V), type(X,T), #false : discrete(T); #false : integer(T).

% Check valid domain
warning("outside domain",(X,V)) :- user_value(X,V), type(X,T), discrete(T), not domain(T,V).
warning("outside domain",(X,V)) :- user_value(X,V), type(X,T), integer(T), range(T,Min,Max), V < Min.
warning("outside domain",(X,V)) :- user_value(X,V), type(X,T), integer(T), range(T,Min,Max), V > Max.
% Check max cardinality not exceeded
% For now this is covered by line 3 (only max amount of objects is grounded)

% Check valid association
warning("invalid association",(X,X'))      :- user_associate((X,X')), type(X,_), type(X',T), not association(X,T,_,_,_).
warning("too many associations",(X,T,Max)) :- association(X,T,_,Max), type(X,_), #count{ X' : user_associate((X,X')), type(X',T) } > Max.

#show warning/2.
