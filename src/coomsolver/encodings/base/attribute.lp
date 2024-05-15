% For clingo assign all attribute values to val/2 predicate
val(X,V) :- attribute_aux(X,V).

#show val(X,V) : val(X,V), attribute_enumeration(X,_).
