value(X,V)     :- user_value(X,V), type(X,T), discrete(T).
&in{V..V} =: X :- user_value(X,V), type(X,T), integer(T).
include(X)     :- user_include(X).
