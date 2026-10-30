% compute the bound at which an object becomes available

% obj_inc(O,M) : object O exists for some max_bound >= M
% - an object O instantiated by an unbounded feature with index I only exists for max_bound >= I-Min+1
% - the actual max_bound may be higher as some parent object of O may only exist for max_bound > M (see below)
obj_inc((F,(X,I)),M) :- type_aux((F,(X,I)),_), type_aux(X,Ctx),
                        coom_feature(Ctx,F,_,Min,#sup), M = I-Min+1, M > 0.

% obj_level(O,B) : object O exists at bound B
% - the bound of an object is the maximum over the bounds of the objects on its path to the root
% level of root
obj_level((),0).
% non-incremental object get level of their parent
obj_level(X,L) :- type_aux(X,_), X=(_,(P,_)), obj_level(P,L), not obj_inc(X,_).
% incremental objects get maximum of level of its parent and its own obj_inc
obj_level(X,L) :- type_aux(X,_), X=(_,(P,_)), obj_level(P,L), obj_inc(X,M), M <= L.
obj_level(X,M) :- type_aux(X,_), X=(_,(P,_)), obj_level(P,L), obj_inc(X,M), M >  L.

% output the bound for every object path
obj_bound(@fmt_dotpath(X),L) :- type_aux(X,_), obj_level(X,L).

#show obj_bound/2.

#include "doc-object-bounds.lp".
