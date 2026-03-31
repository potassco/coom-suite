#program new_replace(r,a).
replace(r,a).

include(X) :- replace(r,a), r = ((X,X'),ID), include(X'), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
value(X,V) :- replace(r,a), r = ((X,X'),ID), value(X',V), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
defined(X) :- replace(r,a), r = ((X,X'),ID), value(X,_).

% in some cases replace needs to take the bound into account
#program new_replace(r,a,b).
#external active(b).
replace(r,a).

include(X,b) :- replace(r,a), r = ((X,X'),ID), include(X'), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
value(X,V,b) :- replace(r,a), r = ((X,X'),ID), value(X',V), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
defined(X,b) :- replace(r,a), r = ((X,X'),ID), value(X,_,b).
