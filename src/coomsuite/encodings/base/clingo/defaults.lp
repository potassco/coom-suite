value(X,V) :- default(X,V), include(X), #false : user_value(X,_), consistent(X,_). % TODO: Check this
