#include "clingo/boolean.lp".

% Auxiliary values for constants and numbers.
value(P,P) :- constant(P).
value(P,N) :- number(P,N).
