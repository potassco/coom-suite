% Assign a value to a (numeric) integer attribute
&in{Min..Max} =: X :- include(X), type(X,T), integer(T), range(T,Min,Max).

% Show statement for numeric values in fclingo
&show { X : type(X,T), integer(T) }.
