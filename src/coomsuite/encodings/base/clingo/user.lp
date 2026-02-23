consistent(X)   :- user_include(X), type(X,_).
consistent(X,V) :- user_value(X,V), type(X,T), discrete(T), domain(T,V).
consistent(X,V) :- user_value(X,V), type(X,T), integer(T),     range(T,Min,Max), Min <= V <= Max.
consistent(X,V) :- user_value(X,V), type(X,T), integer(T), not range(T,_,_).

include(X) :- user_include(X), consistent(X).
include(X) :- user_value(X,V), consistent(X,V).
value(X,V) :- user_value(X,V), consistent(X,V).
