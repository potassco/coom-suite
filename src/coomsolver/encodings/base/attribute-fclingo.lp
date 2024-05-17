% For fclingo distinguish between numeric and non-numeric attributes
val(X,V)       :- attribute_aux(X,V), not isnumeric(X).
&in{V..V} =: X :- attribute_aux(X,V), isnumeric(X).

#show val(X,V) : val(X,V), attribute_aux(X,V).

&show { X : isnumeric(X) }. % complicated but seems like fclingo does not accept show statements with derived atoms in the body
