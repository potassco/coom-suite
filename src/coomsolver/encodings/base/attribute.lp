% For clingo assign all attribute values to val/2 predicate
val(X,V) :- attr_aux(X,V).

#show val(X,V) : val(X,V), attr_enum(X,_).
