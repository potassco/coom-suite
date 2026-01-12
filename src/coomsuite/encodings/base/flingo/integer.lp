% Assign a value to an integer attribute if a range is given, otherwise use system-given maximum range
% &in{Min..Max} =: X :- include(X), type(X,T), integer(T),     range(T,Min,Max).
&sum{Min} <= X :- include(X), type(X,T), numeric(T,int),     range(T,Min,_), Min != #inf.
&sum{Max} >= X :- include(X), type(X,T), numeric(T,int),     range(T,_,Max), Max != #sup.
&sum{X} = X    :- include(X), type(X,T), numeric(T,int), not range(T,_,_).

% Discrete integers
{ discrete_aux(X,V) : domain(T,V) } = 1  :- include(X), type(X,T), discrete(T,int).
&sum{V} = X :- discrete_aux(X,V).
% TODO: Better way?
%  &sum{ V :: domain(T,V) } = X :- include(X), type(X,T), discrete(T,int).
