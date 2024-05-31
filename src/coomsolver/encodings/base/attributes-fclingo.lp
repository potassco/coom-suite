% Always include root instance
include("root").

% Attribute variables are always included when its parents are included
include(X) :- type(X,T), parent(X,P), include(P), attribute(T,_).

range(X,Min,Max) :- type(X,T), attribute(T,"numeric"), Min = #min{ V : domain(T,V) },
                                                       Max = #max{ V : domain(T,V) }.

% Generate exactly one value for each attribute if it is included
{ value(X,V) : domain(T,V) } = 1 :- include(X), type(X,T), attribute(T,"discrete").
&in{Min..Max} =: X               :- include(X), type(X,T), attribute(T,"numeric"), range(X,Min,Max).



% Show statements
#show .
#show value(X,V) : value(X,V), type(X,T), attribute(T,_).

&show { X : type(X,T), attribute(T,"numeric") }.
