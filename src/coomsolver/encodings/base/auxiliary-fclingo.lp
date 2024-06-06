#include "clingo/boolean.lp".

% Auxiliary values for constants and numbers.
value(Path,Path)  :- constant(Path).
&in{N..N} =: Path :- number(Path,N).
