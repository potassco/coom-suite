value(X,V) :- default(X,V), #false : user_value(X,_), consistent(X,_). % TODO: Check this
