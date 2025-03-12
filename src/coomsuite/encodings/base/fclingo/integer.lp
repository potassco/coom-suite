% Assign a value to an integer attribute if a range is given, otherwise use system-given maximum range
% &in{Min..Max} =: X :- include(X), type(X,T), integer(T),     range(T,Min,Max).
&sum{Min} <= X :- include(X), type(X,T), integer(T),     range(T,Min,_), Min != #inf.
&sum{Max} >= X :- include(X), type(X,T), integer(T),     range(T,_,Max), Max != #sup.
&sum{X} = X    :- include(X), type(X,T), integer(T), not range(T,_,_).

% Auxiliary values for numbers.
&sum{N} = Path :- number(Path,N).
