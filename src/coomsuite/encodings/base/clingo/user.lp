value(X,V) :- user_value(X,V), type(X,T), discrete(T), domain(T,V).
value(X,V) :- user_value(X,V), type(X,T), integer(T), range(T,Min,Max), Min <= V <= Max.
include(X) :- user_include(X), type(X,T), part(T).
