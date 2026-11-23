#program new_default(x,v).
default(x,v).

% the default value is given by the term v
value(x,V) :- default(x,v), value(v,V), include(x), #false : user_value(x,_), consistent(x,_).
