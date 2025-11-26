% define incremental objects, i.e. instantiated objects of a component with unbounded cardinality
inc_obj(@dotpath((F,(X,I)))) :- coom_feature(Ctx,F,T,Min,#sup), type_aux(X,Ctx), I = 0..Min+max_bound-1.
% for the special case that:
% - the cardinality of the component is 0..*, and
% - the current max bound is 0,
% instantiate a dummy incremental object
inc_obj(@dotpath((F,(X,-1)))) :- coom_feature(Ctx,F,T,0,#sup),  type_aux(X,Ctx), max_bound = 0.

% helper rules to instantiate the subtree starting from a dummy incremental object
% - base case: checking for 0..* and max bound 0
help_aux((F,(X,-1)),T)            :- coom_feature(Ctx,F,T,Min,#sup),     type_aux(X,Ctx), Min = 0, max_bound = 0, T != "num".
help_aux((F,(X,-1)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",Min,#sup), type_aux(X,Ctx), Min = 0, max_bound = 0.
% - recursive definition for subtree starting from the help_aux elements
help_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,_,  Max),      help_aux(X,Ctx), I = 0..Max-1, T != "num".
help_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,Min,#sup),     help_aux(X,Ctx), I = 0..Min+max_bound-1, T != "num".
help_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",_,  Max),  help_aux(X,Ctx), I = 0..Max-1.
help_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",Min,#sup), help_aux(X,Ctx), I = 0..Min+max_bound-1.

% rules to instantiate a helper version of path_to/4 atoms based on help_aux/2
% - start by projecting out the original path_to/4 atoms
% - path index is not needed here
help_path_to(X,P,X')  :- path_to(X,P,_,X').
% - then define the paths for any new help_aux atoms
help_path_to(X,P,X')  :- coom_path(P,0,N), path_start(X,P),
                         help_aux(X',_), X' =(N,(X,_)).
help_path_to(X,P,X')  :- coom_path(P,0,"root"), coom_path(P,1,N), path_start(X,P),
                         help_aux(X',_), X' =(N,((),_)).
help_path_to(X,P,X'') :- coom_path(P,I,N), help_path_to(X,P,X'),
                         help_aux(X'',_), X''=(N,(X',_)).

% map path_to/4 atoms to path_step/2 by using output formatting
% - needs to be filtered by help_aux to remove sets belonging to the helper objects
path_step(@join(X,P),@dotpath(X')) :- help_path_to(X,P,X'), not help_aux(X,_).

% compute sets used in the column of a table
table_column((C,@dotpath(X)),@join(X,P)) :- table(C,X), coom_combinations(C,_,P).

% incremental sets: a set is incremental if:
% - there is a path from an unbounded object to the set
% - limit to only sets used in functions or as part of a table
inc_set(P) :- function(_,_,P),   path_step(P,X'), inc_obj(X').
inc_set(P) :- table_column(_,P), path_step(P,X'), inc_obj(X').

#show inc_set/1.

% incremental expressions are defined recursively
% - base case: functions over incremental sets are incremental
incremental("function",  X,P,(X,F,P))            :- function(X,F,P),              inc_set(P).
% - base case: table constraints over incremental sets are incremental
incremental("constraint",X,P,((ID,X),"table"))   :- table_column((ID,X),P),       inc_set(P).
% - recursive: if a sub-expression of X is incremental, then X is also incremental
% incremental("function",  X,P,(X,F,Y))            :- function(X,F,Y),              incremental(_,Y ,P,_).
incremental("binary",    X,P,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,L ,P,_).
incremental("binary",    X,P,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,R ,P,_).
incremental("unary",     X,P,(X,O,X'))           :- unary(X,O,X'),                incremental(_,X',P,_).
incremental("constraint",X,P,((ID,X),"boolean")) :- constraint((ID,X),"boolean"), incremental(_,X ,P,_).

#show incremental/4.
