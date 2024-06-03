% Assign a value to a numeric feature
&in{Min..Max} =: X :- include(X), type(X,T), attribute(T,"numeric"), range(T,Min,Max).

% Show statement for numeric values
&show { X : type(X,T), attribute(T,"numeric") }.
