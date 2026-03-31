#program new_incremental_association(x,t,n,l,u,b).
#external active(b).

association(x,t,n,l,u).

% add possible associations to any objects of matching type
{ associate((x,X'),n) : type(X',t), include(X') } :- include(x), active(b).

% assign indices
associate(A,n,I) :- associate(A,n), A = (x,X'), I = #count{ XT : associate((x,XT),n), XT < X' }.
% ensure matching of associations
:- association_match(x,n,N'), associate((x,X'),n), not associate((X',x),N').

#external max_bound(b).
% enforce lower and upper bound, this is done separately from the choice above as
% the choice has to remain active for the next bounds but the bound checking
% needs to be replaced by a new constraint taking into account new possible
% associate atoms
:- l > #count{ XT : associate((x,XT),n) }, max_bound(b).
% note that upper bound could remain active
:- u < #count{ XT : associate((x,XT),n) }, max_bound(b).

#show associate((x ,X'),n ,I )       : associate((x,X'),n,I), not association_match(x,n,_).
#show associate((x ,X'),n ,I ,N',I') : associate((x,X'),n,I), associate((X',x),N',I'), association_match(x,n,N'), x < X'.
#show associate((X',x ),N',I',n ,I ) : associate((x,X'),n,I), associate((X',x),N',I'), association_match(x,n,N'), X' <= x.

#program update_incremental_association(x,t,n,l,u,b).
#external active(b).

% same generating rule, index assignment, and matching constraint as above
% only difference is restriction to elements X' of the current bound b
{ associate((x,X'),n) : type(X',t), include(X'), bound(X',b) } :- include(x), active(b).

associate(A,n,I) :- associate(A,n), A = (x,X'), bound(X',b), I = #count{ XT : associate((x,XT),n), XT < X' }.

:- association_match(x,n,N'), associate((x,X'),n), bound(X',b), not associate((X',x),N').

% any possible replacements from earlier bounds are still valid for the association
% therefore any definitions of include/value for x based on earlier replaces need
% to be extended to this bound, this only needs to be done when b is active
% include of X' not needed as condition for include(X,b-1) already
include(X,b) :- replace(((X,_),_),((x,_),n,_)), include(X,b-1), active(b).
value(X,V,b) :- replace(((X,_),_),((x,_),n,_)), value(X,V,b-1), active(b).
defined(X,b) :- replace(((X,_),_),((x,_),n,_)), defined(x,b-1), active(b).

#external max_bound(b).
% new bound constraints
:- l > #count{ XT : associate((x,XT),n) }, max_bound(b).
:- u < #count{ XT : associate((x,XT),n) }, max_bound(b).

#show associate((x ,X'),n ,I )       : associate((x,X'),n,I), not association_match(x,n,_).
#show associate((x ,X'),n ,I ,N',I') : associate((x,X'),n,I), associate((X',x),N',I'), association_match(x,n,N'), x < X'.
#show associate((X',x ),N',I',n ,I ) : associate((x,X'),n,I), associate((X',x),N',I'), association_match(x,n,N'), X' <= x.
