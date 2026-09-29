%%% Determie object against which paths are evaluated

%*! path_start(X,P)

Identifies objects relative to which a path expression can be evaluated.
Derived from all possible occurrences of a path: formulas, combinations table columns,
imply and optimization statements.

Args:
    - X: The internal object identifier
    - P: The path identifier
*%

path_start(X,P)  :- coom_binary(F,P,_,_),     coom_path(P,0,_), type_aux(X,Ctx), formula_context(F,Ctx).
path_start(X,P)  :- coom_binary(F,_,_,P),     coom_path(P,0,_), type_aux(X,Ctx), formula_context(F,Ctx).
path_start(X,P)  :- coom_unary(F,_,P),        coom_path(P,0,_), type_aux(X,Ctx), formula_context(F,Ctx).
path_start(X,P)  :- coom_combinations(C,_,P), coom_path(P,0,_), type_aux(X,Ctx), coom_context(C,Ctx).
path_start(X,P)  :- coom_function(Ctx,_,_,P), coom_path(P,0,_), type_aux(X,Ctx).
path_start(X,P)  :- coom_imply(C,P,_),        coom_path(P,0,_), type_aux(X,Ctx), coom_context(C,Ctx).
path_start(X,P)  :- coom_minimize(C,_,P),     coom_path(P,0,_), type_aux(X,Ctx), coom_context(C,Ctx).
path_start(X,P)  :- coom_maximize(C,_,P),     coom_path(P,0,_), type_aux(X,Ctx), coom_context(C,Ctx).

%%% Determine all "ground" paths

%*! path_to(X,P,I,Y)

States that the path expression `P` evaluated relative to `X` resolves to `Y` at step `I`.
Helper version of `path_to` (arity 3).

Args:
    - X: The starting internal object identifier
    - P: The path identifier
    - I: The current step of the path
    - Y: The resolved target at the current step (internal format)
*%

% Initialize normal paths
path_to(X,P,0,X') :-
    coom_path(P,0,N),
    path_start(X,P),
    child(X,N,X').

% Initialize paths starting with "root"
path_to(X,P,1,X') :-
    coom_path(P,0,"root"),
    coom_path(P,1,N),
    path_start(X,P),
    child((),N,X').

% Recursively follow path
path_to(X,P,I,X'') :-
    coom_path(P,I,N),
    path_to(X,P,I-1,X'),
    child(X',N,X'').

%%% Determine all complete paths

%*! path_to(X,P,Y)

States that the path expression `P` evaluated relative to `X` resolves to `Y`.
Projection of `path_to` (arity 4) for complete paths of objects.
Special rules for paths of function, constants, numbers and cardinalities.

Args:
    - X: The starting internal object identifier
    - P: The path identifier
    - Y: The resolved target (dotpath string, formula id, constant, or number)
*%

% Get objects to which a path is pointing to when the path ends
path_to(X,P,PX) :-
    path_to(X,P,I,X'),
    not coom_path(P,I+1,_),
    obj_path(X',PX).

% Auxiliary paths for constants and numbers
path_to(X,P,P) :- coom_binary(F,_,_,P), coom_constant(P), formula_context(F,T), type_aux(X,T).
path_to(X,P,P) :- coom_binary(F,P,_,_), coom_constant(P), formula_context(F,T), type_aux(X,T).
path_to(X,P,P) :- coom_binary(F,_,_,P), coom_number(P,_), formula_context(F,T), type_aux(X,T).
path_to(X,P,P) :- coom_binary(F,P,_,_), coom_number(P,_), formula_context(F,T), type_aux(X,T).

% Auxiliary paths for formulas and functions
path_to(X,F,G)                     :- ground_formula(X,F,G).
path_to(X,F,@fmt_aggregate(T,X,P)) :- function(X,F,T,P).

% Auxiliary paths for cardinalities
path_to(X,N,PX) :- coom_feature(Ctx,N,_,_,_), type_aux(X,Ctx), child(X,N,X'), obj_path(X',PX).
path_to(X,A,PX) :- coom_attribute(T,A,_),     type_aux(X,T),   child(X,A,X'), obj_path(X',PX).
