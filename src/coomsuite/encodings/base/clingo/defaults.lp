% default value is given by a term
value(X,V) :- default(X,G), value(G,V), include(X), #false : user_value(X,_), consistent(X,_). % TODO: Check this
