#program new_association_match(x,n,n').
association_match(x,n,n').

#program new_association(x,t,n,min,max).
association(x,t,n,min,max).

min { associate((x,X'),n) : type(X',t), include(X') } max :- association(x,t,n,min,max), include(x).

associate((x,XT),n,I) :- associate((x,XT),n), I = #count{ XT' : associate((x,XT'),n), XT' < XT }.

:- association(x,t,n,min,max), association_match(x,n,N'), associate((x,X'),n,_), not associate((X',x),N',_).

#show associate((x ,X'),n ,I )       : associate((x,X'),n,I), not association_match(x,n,_).
#show associate((x ,X'),n ,I ,N',I') : associate((x,X'),n,I), associate((X',x),N',I'), association_match(x,n,N'), x < X'.
#show associate((X',x ),N',I',n ,I ) : associate((x,X'),n,I), associate((X',x),N',I'), association_match(x,n,N'), X' <= x.
