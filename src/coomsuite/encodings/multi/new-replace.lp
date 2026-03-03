#program new_replace(r,a).
replace(r,a).

include(X) :- replace(r,a), r = ((X,X'),ID), include(X'), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
value(X,V) :- replace(r,a), r = ((X,X'),ID), value(X',V), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
defined(X) :- replace(r,a), r = ((X,X'),ID), value(X,_).
