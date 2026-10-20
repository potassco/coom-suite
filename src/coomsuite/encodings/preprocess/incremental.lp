% define incremental objects, i.e. instantiated objects of a component with unbounded cardinality
inc_obj(@fmt_dotpath((F,(X,I)))) :- coom_feature(Ctx,F,T,Min,#sup), type_aux(X,Ctx), I = 0..Min+max_bound-1.
% for the special case that:
% - the cardinality of the component is 0..*, and
% - the current max bound is 0,
% instantiate a dummy incremental object
inc_obj(@fmt_dotpath((F,(X,-1)))) :- coom_feature(Ctx,F,T,0,#sup),  type_aux(X,Ctx), max_bound = 0.

% helper rules to instantiate the subtree starting from a dummy incremental object
% - base case: checking for 0..* and max bound 0
help_aux((F,(X,-1)),T)                :- coom_feature(Ctx,F,T,Min,#sup),     type_aux(X,Ctx), Min = 0, max_bound = 0, T != "num".
help_aux((F,(X,-1)),@fmt_join(Ctx,F)) :- coom_feature(Ctx,F,"num",Min,#sup), type_aux(X,Ctx), Min = 0, max_bound = 0.
% - recursive definition for subtree starting from the help_aux elements
help_aux((F,(X,I)),T)                 :- coom_feature(Ctx,F,T,_,  Max),      help_aux(X,Ctx), I = 0..Max-1, T != "num".
help_aux((F,(X,I)),T)                 :- coom_feature(Ctx,F,T,Min,#sup),     help_aux(X,Ctx), I = 0..Min+max_bound-1, T != "num".
help_aux((F,(X,I)),@fmt_join(Ctx,F))  :- coom_feature(Ctx,F,"num",_,  Max),  help_aux(X,Ctx), I = 0..Max-1.
help_aux((F,(X,I)),@fmt_join(Ctx,F))  :- coom_feature(Ctx,F,"num",Min,#sup), help_aux(X,Ctx), I = 0..Min+max_bound-1.

% index the helper objects by parent and name, mirroring child/3 for type_aux/2
help_child(X,N,X') :- help_aux(X',_), X' = (N,(X,_)).

% rules to instantiate a helper version of path_to/4 atoms based on help_aux/2
% - start by projecting out the original path_to/4 atoms
% - drop any arguments that are not needed here
help_path_to(X,P,X')  :- path_to(X,P,_,X').
% - then define the paths for any new help_aux atoms
help_path_to(X,P,X')  :- coom_path(P,0,N), path_start(X,P),
                         help_child(X,N,X').
help_path_to(X,P,X')  :- coom_path(P,0,"root"), coom_path(P,1,N), path_start(X,P),
                         help_child((),N,X').
help_path_to(X,P,X'') :- coom_path(P,I,N), help_path_to(X,P,X'),
                         help_child(X',N,X'').

% map help_path_to/3 atoms to path_step/2 by using output formatting
% - needs to be filtered by help_aux to remove sets belonging to the helper objects
path_step(@fmt_join(X,P),@fmt_dotpath(X')) :- help_path_to(X,P,X'), not help_aux(X,_).

% incremental sets: a set is incremental if there is a path from an incremental object to the set
possible_inc_set(P) :- path_step(P,X), inc_obj(X).
% but we only consider those that are used in ...
% a function
inc_set(P) :- function(_,_,P), possible_inc_set(P).
% - the column of a table
%   here we first have to compute the sets of table columns
table_column((C,PX),@fmt_join(X,P)) :- table(C,X), coom_combinations(C,_,P), obj_path(X,PX).
inc_set(P) :- table_column(_,P), possible_inc_set(P).

% incremental(T,N,Arg) : expression of type T with name N and arguments Args is incremental
% incremental expressions are defined recursively
% - base case: functions over incremental sets are incremental
incremental("function",  X,(X,F,P))            :- function(X,F,P),              inc_set(P).
% - base case: table constraints over incremental sets are incremental
incremental("constraint",X,((ID,X),"table"))   :- table_column((ID,X),P),       inc_set(P).
% - recursive: if a sub-expression of X is incremental, then X is also incremental
incremental("binary",    X,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,L ,_).
incremental("binary",    X,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,R ,_).
incremental("unary",     X,(X,O,X'))           :- unary(X,O,X'),                incremental(_,X',_).
incremental("constraint",X,((ID,X),"boolean")) :- constraint((ID,X),"boolean"), incremental(_,X ,_).
incremental("minimize",  X,(X,V))              :- minimize(X,V),                incremental(_,X ,_).
incremental("maximize",  X,(X,V))              :- maximize(X,V),                incremental(_,X ,_).

#show inc_set/1.
#show incremental/3.

#include "doc-incremental.lp".
