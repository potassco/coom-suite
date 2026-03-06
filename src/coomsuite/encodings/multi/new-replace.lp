#program new_replace(r,a).
replace(r,a).

include(X) :- replace(r,a), r = ((X,X'),ID), include(X'), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
value(X,V) :- replace(r,a), r = ((X,X'),ID), value(X',V), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
defined(X) :- replace(r,a), r = ((X,X'),ID), value(X,_).

% in some cases replace needs to take the bound into account
#program new_replace(r,a,b).
#external active(b).
replace(r,a).
{ associate((X,XT),N) } :- replace(r,a), a = ((X,XT),N,I), include(X), active(b).

associate((X,XT),N,I) :- replace(r,a), a = ((X,XT),N,_), associate(A,N), I = #count{ XT' : associate((X,XT'),N), XT' < XT }.

:- replace(r,a), a = ((X,X'),N,I), association_match(X,N,N'), associate((X,X'),N,_), not associate((X',X),N',_).

include(X,b) :- replace(r,a), r = ((X,X'),ID), a = (A,N,I), associate(A,N,I), include(X').
include(X,b) :- replace(r,a), r = ((X,X'),ID), include(X'), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
value(X,V,b) :- replace(r,a), r = ((X,X'),ID), value(X',V), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
defined(X,b) :- replace(r,a), r = ((X,X'),ID), value(X,_).

#show associate/3.
