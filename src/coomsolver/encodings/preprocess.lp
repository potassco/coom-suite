structure_instance(":root",":root",0) :- structure(":root").

enumeration_instance((Feature,(Instance,0)),Type) :- feature(Context,Feature,Type,_,_), enumeration(Type), structure_instance(Instance,Context,_).
parent(Instance,Parent)   :- enumeration_instance(Instance,_), Instance=(_,(Parent,_)).
feature(Instance,Feature) :- enumeration_instance(Instance,_), Instance=(Feature,(_,_)).

attr_instance((Attr,(Instance,0)),Instance) :- enumeration_instance(Instance,Type), attr_value(Type,_,Attr,_).

structure_instance((Feature,(Instance,Idx)),Structure,Idx) :- feature(Context,Feature,Structure,_,Max), structure(Structure),
                                                               structure_instance(Instance,Context,_), Idx = 0..Max-1.





% #show feature/5.
% #show structure/1.
% #show enumeration/1.
% #show option/2.
% #show attribute/3.
% #show attr_value/4.

% #show allow/3.

#show structure_instance/3.
#show enumeration_instance/2.

#show parent/2.
#show feature/2.
#show attr_instance/2.
