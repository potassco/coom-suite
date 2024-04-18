#include "clingo-core-processed.lp".

% Always generate minimal number of objects
instance(Instance,Type) :- feature(Context,_,Type,Min,_), structure_instance(Instance,Type,Idx), Idx < Min,
                           parent(Instance,Parent), instance(Parent,Context).

% Optionally generate additional objects
{ instance(Instance,Type) : feature(Context,_,Type,Min,_), structure_instance(Instance,Type,_) }.

% No instances without their parent instantiated
:- instance(Instance,_), structure_instance(Instance,_,_), parent(Instance,Parent), not instance(Parent,_).

% Indices in ascending order for a feature
:- feature(_,Feature,Type,_,_), instance(Instance,Type),      structure_instance(Instance,Type,Idx),    feature(Instance,Feature),
                                not instance(Instance2,Type), structure_instance(Instance2,Type,Idx-1), feature(Instance2,Feature), Idx > 0.

% Check cardinalities
:- feature(Context,Feature,Type,Min,Max), instance(Parent,Context), not Min<=X<=Max, X = #count { I : instance(I,Type), parent(I,Parent), feature(I,Feature) }.
