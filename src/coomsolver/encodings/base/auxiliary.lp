% Always include boolean enumeration
enumeration("bool").
option("bool", "True").
option("bool", "False").

% Auxiliary val/2 atoms for constants and numbers.
val(Path,Path)      :- constant(Path).
val(Path,N)         :- number(Path,N).
