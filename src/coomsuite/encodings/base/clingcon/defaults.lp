&sum{X} = V :- default(X,V), integer(X), include(X), #false : user_value(X,_), consistent(X,_).
