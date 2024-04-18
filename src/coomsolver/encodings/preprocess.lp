structure_instance(":root",":root",0) :- structure(":root").
aux_instance(":root",":root") :- structure(":root").

aux_instance((Feature,(Instance,Idx)),Type) :- feature(Context,Feature,Type,_,Max), aux_instance(Instance,Context), Idx = 0..Max-1.

structure_instance(Instance,Type,Idx) :- structure(Type), aux_instance(Instance,Type), Instance=((_,(_,Idx))).
enumeration_instance(Instance,Type) :- enumeration(Type), aux_instance(Instance,Type).
parent(Instance,Parent)   :- aux_instance(Instance,_), Instance=(_,(Parent,_)).
feature(Instance,Feature) :- aux_instance(Instance,_), Instance=(Feature,(_,_)).

attr_instance((Attr,(Instance,0)),Instance) :- aux_instance(Instance,Type), enumeration(Type), attr_value(Type,_,Attr,_).


constraint(0).
condition(0,"color=Yellow").
binary_instance("color=Yellow","color[0]","=","Yellow").
require(0,"frontWheel.size>16").
binary_instance("frontWheel.size>16","frontWheel[0].size",">","16").


constraint(2).
condition(2,"carrier.bag.capacity.volume=100").
binary_instance("carrier.bag.capacity.volume=100","carrier[0].bag[0].capacity[0].volume","=","100").
binary_instance("carrier.bag.capacity.volume=100","carrier[0].bag[1].capacity[0].volume","=","100").
number("100",100).
require(2,"rearWheel.size>=28").
binary_instance("rearWheel.size>=28","rearWheel[0].size",">=","28").
number("28",28).

constraint(5).
combinations_instance(5,0,"carrier[0].bag[0].material[0]").
combinations_instance(5,1,"carrier[0].bag[0].capacity[0]").

combinations_instance(5,0,"carrier[0].bag[1].material[0]").
combinations_instance(5,1,"carrier[0].bag[1].capacity[0]").

allow(5,(0,0),"Leather").
allow(5,(1,0),"B10").
allow(5,(0,1),"Cotton").
allow(5,(1,1),"B20").
allow(5,(1,1),"B50").
allow(5,(0,2),"Polyester").
allow(5,(1,2),"B20").
allow(5,(1,2),"B50").
allow(5,(1,2),"B100").

% Find examples for table constraints path pointing to multiple objects, then cross product






% #show feature/5.
% #show structure/1.
% #show enumeration/1.
% #show option/2.
% #show attribute/3.
% #show attr_value/4.

% #show allow/3.
% #show constant/1.
% #show number/2.

#show structure_instance/3.
#show enumeration_instance/2.

#show parent/2.
#show feature/2.
#show attr_instance/2.

% #script (python)
% #end.
