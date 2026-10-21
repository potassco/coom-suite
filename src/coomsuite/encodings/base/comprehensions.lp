include(X) :- aggregate_member(X,M,_), include(M), not aggregate_filtered(X).
include(X) :- aggregate_member(X,M,_), include(M), aggregate_condition(X,C), satisfied(C).

% Theory aggregates can provide support for their condition atoms. Enforce
% membership in both directions rather than relying on minimality alone.
:- include(X), aggregate_member(X,M,_), not include(M).
:- include(X), aggregate_filtered(X), not 1 { satisfied(C) : aggregate_condition(X,C) }.
