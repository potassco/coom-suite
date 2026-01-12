% Generate exactly one value for each discrete attribute if it is included
{ value(X,V) : domain(T,V) } = 1 :- include(X), type(X,T), discrete(T,(str;bool)).
