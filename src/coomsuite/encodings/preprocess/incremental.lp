% mark which objects have unbounded cardinalities
inc_obj(@dotpath((F,(X,I)))) :- coom_feature(Ctx,F,T,Min,#sup), type_aux(X,Ctx), I = 0..Min+max_bound-1.
% dummy incremental object when 0..* and max_bound = 0
inc_obj(@dotpath((F,(X,-1)))) :- coom_feature(Ctx,F,T,0,#sup),  type_aux(X,Ctx), max_bound = 0.

% map path_to/4 atoms to path_step/2 by using output formatting (step index is discarded)
path_step(@join(X,P),@dotpath(X')) :- path_to(X,P,_,X'), not dummy(X,_).
% map path_to/3 atoms to path_final/2 by using output formatting
path_final(@join(X,P),@dotpath(X')) :- path_to(X,P,X').

% incremental sets: a set is incremental if:
% - there is a path from an unbounded object to the set
% - limit to only sets used in functions
inc_set(P) :- function(_,_,P), path_step(P,X'), inc_obj(X').
% elements of incremental sets
inc_set_element(P,X') :- inc_set(P), path_final(P,X').

#show inc_set/1.

% incremental expressions are defined recursively
% base case: functions over incremental sets are incremental
incremental("function",  X,P,(X,F,P))            :- function(X,F,P),              inc_set(P).
% recursive: if a sub-expression of X is incremental, then X is also incremental
incremental("binary",    X,P,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,L,P,_).
incremental("binary",    X,P,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,R,P,_).
incremental("unary",     X,P,(X,O,X'))           :- unary(X,O,X'),                incremental(_,X',P,_).
incremental("constraint",X,P,((ID,X),"boolean")) :- constraint((ID,X),"boolean"), incremental(_,X,P,_).
% special case: a table constraint is incremental if a column element belongs to an incremental set
incremental("constraint",X,P,((ID,X),"table"))   :- constraint((ID,X),"table"),
                                                    column((ID,X),_,_,E), inc_set_element(P,E), inc_set(P).
#show incremental/4.
