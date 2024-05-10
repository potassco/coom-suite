#include "clingo-core-processed.lp".

% Generate structure objects
{ included(X) : struct_type(X,Type) }.

% Always include minimal number of objects
included(X) :- feature(Context,_,Type,Min,_), struct_type(X,Type), index(X,Idx), Idx < Min,
               parent(X,Parent), included(Parent), struct_type(Parent,Context).

% No structure object without feature (really needed?)
:- included(X), struct_type(X,Type), not feature(_,_,Type,_,_), X != "".

% No instances without their parent instantiated
:- included(X), struct_type(X,_), parent(X,Parent), not included(Parent).

% Indices in ascending order for a feature
:- feature(_,Feature,Type,_,_), included(X),      struct_type(X,Type),  feature(X,Feature),  index(X, Idx), Idx > 0,
                                not included(X'), struct_type(X',Type), feature(X',Feature), index(X',Idx-1).

% Check cardinalities
:- feature(Context,Feature,Type,Min,Max), included(Parent), struct_type(Parent,Context),
   not Min<=N<=Max, N = #count { X : included(X), parent(X,Parent), feature(X,Feature) }.

#show included(X) : included(X), struct_type(X,_), X != "".
