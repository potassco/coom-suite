{ value(X,V) : V = Min..Max } = 1 :- include(X), type(X,T), attribute(T,"numeric"), range(T,Min,Max).
