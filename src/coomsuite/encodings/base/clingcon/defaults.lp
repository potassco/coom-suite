&sum{X} =: V :- default(X,V), include(X), #false : user_value(X,_), consistent(X,_).
