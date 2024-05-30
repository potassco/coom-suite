#include "boolean.lp".

% Auxiliary value/2 atoms for constants and numbers.
value(P,P) :- constant(P).
value(P,N) :- number(P,N).
