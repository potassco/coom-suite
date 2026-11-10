#program new_default(x,v).
default(x,v).

value(x,v) :- default(x,v), include(x), #false : user_value(x,_), consistent(x,_).
