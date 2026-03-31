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
help_aux((F,(X,I)),T)             :- coom_feature(Ctx,F,T,_,  Max),      help_aux(X,Ctx), I = 0..Max-1, T != "num".
help_aux((F,(X,I)),T)             :- coom_feature(Ctx,F,T,Min,#sup),     help_aux(X,Ctx), I = 0..Min+max_bound-1, T != "num".
help_aux((F,(X,I)),@join(Ctx,F))  :- coom_feature(Ctx,F,"num",_,  Max),  help_aux(X,Ctx), I = 0..Max-1.
help_aux((F,(X,I)),@join(Ctx,F))  :- coom_feature(Ctx,F,"num",Min,#sup), help_aux(X,Ctx), I = 0..Min+max_bound-1.

% rules to instantiate a helper version of path_to/6 atoms based on help_aux/2
% - start by projecting out the original path_to/6 atoms
% - drop any arguments that are not needed here
help_path_to(X,P,X')  :- path_to(X,P,_,X',_,_).
% - then define the paths for any new help_aux atoms
help_path_to(X,P,X')  :- coom_path(P,0,N), path_start(X,P),
                         help_aux(X',_), X' = (N,(X,_)).
help_path_to(X,P,X')  :- coom_path(P,0,"root"), coom_path(P,1,N), path_start(X,P),
                         help_aux(X',_), X' = (N,((),_)).
help_path_to(X,P,X'') :- coom_path(P,I,N), help_path_to(X,P,X'),
                         help_aux(X'',_), X'' = (N,(X',_)).

% map help_path_to/4 atoms to path_step/2 by using output formatting
% - needs to be filtered by help_aux to remove sets belonging to the helper objects
path_step(@join(X,P),@dotpath(X')) :- help_path_to(X,P,X'), not help_aux(X,_).

% compute sets used in the column of a table

% incremental sets: a set is incremental if there is a path from an incremental object to the set
possible_inc_set(P) :- path_step(P,X), inc_obj(X).
% but we only consider those that are used in ...
% a function
inc_set(P) :- function(_,_,P), possible_inc_set(P).
% - the column of a table
%   here we first have to compute the sets of table columns
table_column((C,@dotpath(X)),@join(X,P)) :- table(C,X), coom_combinations(C,_,P).
inc_set(P) :- table_column(_,P), possible_inc_set(P).
% - an association, here we have two cases
%   first any set whose objects are used to replace association variables
inc_set(P) :- replace(_,((_,X),_,_)), set(P,X), inc_obj(X).
%   second also the set of the association variables themselves
set_association(P,P') :- replace(((X,Y),_),_), set(P,X), set(P',Y).
inc_set(P) :- inc_set(P'), set_association(P,P').

% mark types with unbounded cardinality as incremental
inc_type(T) :- coom_feature(Ctx,F,T,Min,#sup).

% incremental(T,N,Arg) : expression of type T with name N and arguments Args is incremental
% incremental expressions are defined recursively
% - base case: functions over incremental sets are incremental
incremental("function",  X,(X,F,P))            :- function(X,F,P),              inc_set(P).
% - base case: table constraints over incremental sets are incremental
incremental("constraint",X,((ID,X),"table"))   :- table_column((ID,X),P),       inc_set(P).
% - base case: association to an incremental type
incremental("association",N,(X,T,N,L,U))       :- association(X,T,N,L,U),       inc_type(T).
% - recursive: any path expression that is a variable of an incremental association
incremental("path",      X,())                 :- replace(((X,_),_),(_,N,_)),   incremental("association",N,_).
% - recursive: if a sub-expression of X is incremental, then X is also incremental
incremental("binary",    X,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,L ,_).
incremental("binary",    X,(X,L,O,R))          :- binary(X,L,O,R),              incremental(_,R ,_).
incremental("unary",     X,(X,O,X'))           :- unary(X,O,X'),                incremental(_,X',_).
incremental("constraint",X,((ID,X),"boolean")) :- constraint((ID,X),"boolean"), incremental(_,X ,_).
incremental("minimize",  X,(X,V))              :- minimize(X,V),                incremental(_,X ,_).
incremental("maximize",  X,(X,V))              :- maximize(X,V),                incremental(_,X ,_).

#show inc_set/1.
#show incremental/3.
