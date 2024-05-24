#include "boolean.lp".

% Auxiliary val/2 atoms for constants and numbers.
val(P,P) :- constant(P).
val(P,N) :- number(P,N).
