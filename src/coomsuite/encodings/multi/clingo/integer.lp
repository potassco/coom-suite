#program new_object(name,type,parent,index,set).

% Generate exactly one value for each (numeric) integer attribute if it is included
{ value(name,V) : V = Min..Max } = 1 :- include(name), type(name,type), integer(type), range(type,Min,Max).
