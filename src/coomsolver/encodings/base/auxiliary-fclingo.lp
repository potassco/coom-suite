#include "boolean.lp".

% Auxiliary val/2 atoms for constants and numbers.
val(Path,Path)      :- constant(Path).
&in{N..N} =: Path   :- number(Path,N).
