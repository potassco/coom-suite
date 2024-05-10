% For fclingo distinguish between numeric and non-numeric attributes
val(X,V)       :- attr_aux(X,V), not isnumeric(X).
&in{V..V} =: X :- attr_aux(X,V), isnumeric(X).

#show val(X,V) : val(X,V), attr_enum(X,_).

&show { X : attr_enum(X,_), isnumeric(X) }.
