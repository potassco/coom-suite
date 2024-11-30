% Check that variables exist
unsat("not exists",X) :- user_value(X,_), not type(X,_).
unsat("not exists",X) :- user_include(X), not type(X,_).

% Check variable type
unsat("not part",X) :- user_include(X), type(X,T), not part(T).
unsat("not attribute",X) :- user_value(X,V), type(X,T), #false : discrete(T); #false : integer(T).

% Check valid domain
unsat("outside domain",(X,V)) :- user_value(X,V), type(X,T), discrete(T), not domain(T,V).
unsat("outside domain",(X,V)) :- user_value(X,V), type(X,T), integer(T), range(T,Min,Max), V < Min.
unsat("outside domain",(X,V)) :- user_value(X,V), type(X,T), integer(T), range(T,Min,Max), V > Max.
% Check max cardinality not exceeded
% For now this is covered by line 3 (only max amount of objects is grounded)

#show unsat/2.
