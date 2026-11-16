&sum{X} = V :- default(X,V), numeric(X), include(X), #false : user_value(X,_), consistent(X,_).
