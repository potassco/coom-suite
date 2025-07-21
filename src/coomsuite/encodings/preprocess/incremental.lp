% incremental auxiliary predicate
inc_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,Min,#sup),     type_aux(X,Ctx), I = 0..Min+max_bound-1, T != "num".
inc_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",Min,#sup), type_aux(X,Ctx), I = 0..Min+max_bound-1.

inc_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,_,  Max),      inc_aux(X,Ctx), I = 0..Max-1, T != "num".
inc_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",_,  Max),  inc_aux(X,Ctx), I = 0..Max-1.

inc_aux((A,(X,0)),A) :- inc_aux(X,T), coom_enumeration(T), coom_attribute_value(T,_,A,_).

% incremental objects
inc_obj(@dotpath(X)) :- inc_aux(X,_).

% incremental sets
% TODO: verify that this only includes sets like root.bags and not root.bags[0].color
inc_set(@join(X,P)) :- function(X,_,_,P), path_to(X,P,X'), inc_obj(X').

#show inc_set/1.

% incremental expressions
% TODO: what about sum(count(...))
incremental("function",  X,P,(X,F,P))            :- function(X,F,P),              inc_set(P).
incremental("binary",    X,P,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,L,P,_).
incremental("binary",    X,P,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,R,P,_).
incremental("unary",     X,P,(X,O,X'))           :- unary(X,O,X'),                incremental(_,X',P,_).
incremental("constraint",X,P,((ID,X),"boolean")) :- constraint((ID,X),"boolean"), incremental(_,X,P,_).
incremental("constraint",X,P,((ID,X),"table"))   :- constraint((ID,X),"table"),
                                                    column((ID,X),_,_,E), set(P,E), inc_set(P).
#show incremental/4.
