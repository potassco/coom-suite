%%% Instantiate complete instance tree
aux_instance((),":root") :- structure(":root").

aux_instance((Feature,(Instance,Idx)),Type) :- feature(Context,Feature,Type,_,Max), aux_instance(Instance,Context), Idx = 0..Max-1.
aux_instance((Attr,(Instance,0)),Attr) :- aux_instance(Instance,Type), enumeration(Type), attr_value(Type,_,Attr,_).


%%% Instantiate paths
path_aux(Instance,Path) :- binary(Context,_,Path,_,_),      path(Path,0,_), aux_instance(Instance,Context).
path_aux(Instance,Path) :- binary(Context,_,_,_,Path),      path(Path,0,_), aux_instance(Instance,Context).
path_aux(Instance,Path) :- combinations(Constraint,_,Path), path(Path,0,_), aux_instance(Instance,Context),
                                context(Constraint,Context).

path_instance(Instance,Path,0,X)  :- path(Path,0,Name),
                                     path_aux(Instance,Path), aux_instance(X,_), X=(Name,(Instance,_)).
path_instance(Instance,Path,N,X') :- path(Path,N,Name),
                                     path_instance(Instance,Path,N-1,X), aux_instance(X',_), X'=(Name,(X,_)).

path_instance(Instance,Path,X)    :- not path(Path,N+1,_), path_instance(Instance,Path,N,X).

% Constants and numbers
path_instance(Instance,Path,Path) :- binary(Context,_,_,_,Path), aux_instance(Instance,Context), constant(Path).
path_instance(Instance,Path,Path) :- binary(Context,_,_,_,Path), aux_instance(Instance,Context), number(Path,_).


binary_instance(Instance,Formula,X1,Op,X2) :- binary(Context,Formula,Left,Op,Right), aux_instance(Instance,Context),
                                              path_instance(Instance,Left,X1), path_instance(Instance,Right,X2).

% binary(":root","color=Yellow","color","=","Yellow").

% path_instance((),"color",(color,(":root",0))).
% path_instance((),"Yellow","Yellow").

% binary(":root","frontWheel.size>16","frontWheel.size",">","16").
% binary_instance((),"frontWheel.size>16","frontWheel[0].size[0]",">","16").
% path_instance((),"frontWheel.size",(size,((frontWheel,(":root",0)),0))).
% path_instance((),"16","16").

% binary("Bag","capacity=B10","capacity","=","B10").

% combinations(5,1,"capacity").
% context(5,"Bag").
% path_instance((bag,((carrier,((),0)),0)),"capacity",((capacity,((bag,((carrier,((),0)),0)),0)))).
% path_instance((bag,((carrier,((),0)),1)),"capacity",((capacity,((bag,((carrier,((),0)),1)),0)))).
% binary_instance((bag,((carrier,((),0)),0)),"capacity=B10",((capacity,((bag,((carrier,((),0)),0)),0))),"=","B10")
% binary_instance((bag,((carrier,((),0)),1)),"capacity=B10",((capacity,((bag,((carrier,((),0)),1)),0))),"=","B10")





% behavior(0).
% condition(0,"color=Yellow").
% binary_instance("color=Yellow","color[0]","=","Yellow").
% require(0,"frontWheel.size>16").
% binary_instance("frontWheel.size>16","frontWheel[0].size",">","16").


% behavior(2).
% condition(2,"carrier.bag.capacity.volume=100").
% binary_instance("carrier.bag.capacity.volume=100","carrier[0].bag[0].capacity[0].volume","=","100").
% binary_instance("carrier.bag.capacity.volume=100","carrier[0].bag[1].capacity[0].volume","=","100").
% number("100",100).
% require(2,"rearWheel.size>=28").
% binary_instance("rearWheel.size>=28","rearWheel[0].size",">=","28").
% number("28",28).

% behavior(5).
% combination(5,0,"material").
% combination(5,1,"capacity").

% combinations_instance((5,"carrier[0].bag[0]"),0,"carrier[0].bag[0].material[0]").
% combinations_instance((5,"carrier[0].bag[0]"),1,"carrier[0].bag[0].capacity[0]").

% combinations_instance((5,"carrier[0].bag[1]"),0,"carrier[0].bag[1].material[0]").
% combinations_instance((5,"carrier[0].bag[1]"),1,"carrier[0].bag[1].capacity[0]").

% allow(5,(0,0),"Leather").
% allow(5,(1,0),"B10").
% allow(5,(0,1),"Cotton").
% allow(5,(1,1),"B20").
% allow(5,(1,1),"B50").
% allow(5,(0,2),"Polyester").
% allow(5,(1,2),"B20").
% allow(5,(1,2),"B50").
% allow(5,(1,2),"B100").

% Find examples for table constraints path pointing to multiple objects, then cross product


%%% Output atoms
structure_instance(":root",":root",0) :- structure(":root").
structure_instance(@dotpath(Instance),Type,Idx) :- structure(Type), aux_instance(Instance,Type), Instance=((_,(_,Idx))).
enumeration_instance(@dotpath(Instance),Type) :- enumeration(Type), aux_instance(Instance,Type).
attr_instance(@dotpath((Attr,(Instance,0))),@dotpath(Instance)) :- aux_instance((Attr,(Instance,0)),Attr), attr_value(Type,_,Attr,_).

parent(@dotpath(Instance),@dotpath(Parent))   :- aux_instance(Instance,_), Instance=(_,(Parent,_)).
feature(@dotpath(Instance),Feature) :- aux_instance(Instance,_), Instance=(Feature,(_,_)).


% #show feature/5.
% #show structure/1.
% #show enumeration/1.
% #show option/2.
% #show attribute/3.
% #show attr_value/4.

% #show allow/3.
% #show constant/1.
% #show number/2.

% #show structure_instance/3.
% #show enumeration_instance/2.
% #show attr_instance/2.
% #show parent/2.
% #show feature/2.


% #show path_instance/3.
% #show binary_instance/5.

#script (python)
from clingo import String

def dotpath(path):
    if str(path) == "()":
        return String(":root")
    path = unpack(path, [])
    return String(".".join([f"{p[0]}[{p[1]}]" for p in path]))

def unpack(p, l):
    """
    Recursively unpacks a nested path expression into a list of tuples.
    """
    if str(p) != "()":
        t = (p.arguments[0].name, str(p.arguments[1].arguments[1].number))
        l.insert(0, t)
        unpack(p.arguments[1].arguments[0], l)
    return l
#end.
