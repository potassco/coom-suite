% Assign a value to an integer attribute if a range is given, otherwise use system-given maximum range
% &in{Min..Max} =: X :- include(X), type(X,T), integer(T),     range(T,Min,Max).
% &sum{Min} <= X :- include(X), type(X,T), integer(T),     range(T,Min,_), Min != #inf.
% &sum{Max} >= X :- include(X), type(X,T), integer(T),     range(T,_,Max), Max != #sup.
% &sum{X} = X    :- include(X), type(X,T), integer(T), not range(T,_,_).

&dom{Min..Max} = X :- include(X), type(X,T), numeric(T,"int"), range(T,Min,Max), Min != #inf, Max != #sup.
&sum{Min} <= X     :- include(X), type(X,T), numeric(T,"int"), range(T,Min,#sup), Min != #inf.
&sum{Max} >= X     :- include(X), type(X,T), numeric(T,"int"), range(T,#inf,Max), Max != #sup.

&dom{Min..Max} = X :- include(X), type(X,T), discrete(T,"int"),
                     Min = #min { V: domain(T,V) },
                     Max = #max { V: domain(T,V) }.

&sum{0} = X :- not include(X), type(X,T), numeric(T,"int").
&sum{0} = X :- not include(X), type(X,T), discrete(T,"int").



% Auxiliary values for numbers.
&sum{N} = P :- constant(P,"int"), integer_constant(P,N).
