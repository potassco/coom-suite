% Assign a value to a (numeric) integer attribute
&in{Min..Max} =: X :- include(X), type(X,T), integer(T), range(T,Min,Max).

% Auxiliary values for numbers.
&in{N..N} =: Path :- number(Path,N).

% Show statement for numeric values in fclingo
&show { X : type(X,T), integer(T) }.
