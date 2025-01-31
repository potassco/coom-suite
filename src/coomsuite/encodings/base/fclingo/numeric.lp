% % Assign system-given maximum range to numeric attributes
&in{-1073741823..1073741823} =: X :- include(X), type(X,T), integer(T).

% Assign a value to an integer attribute if a range is given
&in{Min..Max} =: X :- include(X), type(X,T), integer(T), range(T,Min,Max).

% Auxiliary values for numbers.
&in{N..N} =: Path :- number(Path,N).

% Show statement for numeric values in fclingo
&show { X : type(X,T), integer(T) }.
