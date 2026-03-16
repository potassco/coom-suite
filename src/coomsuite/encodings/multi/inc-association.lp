#program new_incremental_association(x,t,n,l,u,b).
#external max_bound(b).
:- l > #count{ XT : associate((x,XT),n) }, max_bound(b).
:- u < #count{ XT : associate((x,XT),n) }, max_bound(b).

{ associate((x,X'),n) : type(X',t), include(X') } :- include(x), active(b).

associate(A,n,I) :- associate(A,n), A = (x,XT), I = #count{ XT' : associate((x,XT'),n), XT' < XT }.

% pos_assoc((x,X'),n) :- include(x), active(b), type(X',t), include(X').
% #show pos_assoc/2.

#program update_incremental_association(x,t,n,l,u,b).
#external max_bound(b).
% for an increased max bound b' these constraint are replaced (by new versions taking into account new associate options),
% so we only check at max_bound(b)
:- l > #count{ XT : associate((x,XT),n) }, max_bound(b).
:- u < #count{ XT : associate((x,XT),n) }, max_bound(b).

{ associate((x,X'),n) : type(X',t), include(X'), bound(X',b) } :- include(x), active(b).

associate(A,n,I) :- associate(A,n), A = (x,XT), bound(XT,b), I = #count{ XT' : associate((x,XT'),n), XT' < XT }.

% pos_assoc((x,X'),n) :- include(x), active(b), b > 0, type(X',t), include(X'), bound(X',b).
% #show pos_assoc/2.

% TODO: association match
% :- association_match(x,n,N'), associate((x,X'),n,_), not associate((X',x),N',_).

% any possible replacements from earlier bounds are still valid for the association
% therefore any definitions of include/value for x based on earlier replaces need to be extended to this bound
% this only needs to be done when b is active
#external active(b).
% include of X' not needed as condition for include(X,b-1) already
include(X,b) :- replace(((X,_),_),((x,_),n,_)), include(X,b-1), active(b).
value(X,V,b) :- replace(((X,_),_),((x,_),n,_)), value(X,V,b-1), active(b).
defined(X,b) :- replace(((X,_),_),((x,_),n,_)), defined(x,b-1), active(b).

% #show associate((x ,X'),n ,I )       : associate((x,X'),n,I), not association_match(x,n,_).
% #show associate((x ,X'),n ,I ,N',I') : associate((x,X'),n,I), associate((X',x),N',I'), association_match(x,n,N'), x < X'.
% #show associate((X',x ),N',I',n ,I ) : associate((x,X'),n,I), associate((X',x),N',I'), association_match(x,n,N'), X' <= x.
#show associate/3.
