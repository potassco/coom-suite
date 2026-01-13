#program new_replace(r,a).
replace(r,a).

include(X) :- replace(r,a), r = (X,X'), a = (A,I), associate(A,I), include(X').

value(X,V) :- replace(r,a), r = (X,X'), a = (A,I), associate(A,I), value(X',V).
defined(X) :- replace(r,_), r = (X,X'), value(X,_).
