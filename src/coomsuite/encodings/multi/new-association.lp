#program new_association_match(x,n,n').
association_match(x,n,n').

#program new_association(x,t,n,min,max).
association(x,t,n,min,max).

min { associate((x,X'),n) : type(X',t), include(X') } max :- association(x,t,n,min,max), include(x).

associate((x,XT),n,I) :- associate((x,XT),n), I = #count{ XT' : associate((x,XT'),n), XT' < XT }.

:- association(x,t,n,min,max), association_match(x,n,N'), associate((x,X'),n,_), not associate((X',x),N',_).

#show associate/3.
