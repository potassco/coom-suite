#program new_object(name,type,parent,index,set).

% Generate exactly one value for each discrete attribute if it is included
{ value(name,V) : domain(type,V) } = 1 :- include(name), type(name,type), discrete(type).
