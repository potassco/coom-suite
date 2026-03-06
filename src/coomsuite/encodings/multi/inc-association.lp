#program incremental_association(x,t,n,l,u,b).
#external max_bound(b).
% for an increased max bound b' these constraint are replaced (by new versions taking into account new associate options),
% so we only check at max_bound(b)
:- l > #count{ XT : associate((x,XT),n) }, max_bound(b).
:- u < #count{ XT : associate((x,XT),n) }, max_bound(b).

% any possible replacements from earlier bounds are still valid for the association
% therefore any definitions of include/value for x based on earlier replaces need to be extended to this bound
% this only needs to be done when b is active
#external active(b).
include(x,b) :- include(x,b-1), active(b).
value(x,V,b) :- value(x,V,b-1), active(b).
defined(x,b) :- defined(x,b-1), active(b).

% TODO: check that evaluation of constraints works with this
