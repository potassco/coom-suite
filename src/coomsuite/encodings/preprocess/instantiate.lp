% Max bound for unbounded cardinalities
#const max_bound = 100.

%%% Instantiate complete instance tree
% Root is always included
type_aux((),"product") :- coom_structure("product").

% Create auxiliary predicate for every feature
type_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,_,  Max),      type_aux(X,Ctx), I = 0..Max-1, T != "num".
type_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,Min,#sup),     type_aux(X,Ctx), I = 0..Min+max_bound-1, T != "num".
type_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",_,  Max),  type_aux(X,Ctx), I = 0..Max-1.
type_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",Min,#sup), type_aux(X,Ctx), I = 0..Min+max_bound-1.

% Create auxiliary prediate for attribute variables
type_aux((A,(X,0)),A) :- type_aux(X,T), coom_enumeration(T), coom_attribute_value(T,_,A,_).


%%% Constraints
% Get formula context
formula_context(F,Ctx) :- coom_binary(F,_,_,_), coom_require(C,F),   coom_context(C,Ctx).
formula_context(F,Ctx) :- coom_binary(F,_,_,_), coom_condition(C,F), coom_context(C,Ctx).
formula_context(F,Ctx) :- coom_binary(F,_,_,_), coom_imply(C,_,F),   coom_context(C,Ctx).

formula_context(F,Ctx) :- coom_unary(F,_,_),    coom_require(C,F),   coom_context(C,Ctx).
formula_context(F,Ctx) :- coom_unary(F,_,_),    coom_condition(C,F), coom_context(C,Ctx).
formula_context(F,Ctx) :- coom_unary(F,_,_),    coom_imply(C,_,F),   coom_context(C,Ctx).

formula_context(L,Ctx) :- coom_binary(L,_,_,_), coom_binary(F,L,_,_), formula_context(F,Ctx).
formula_context(R,Ctx) :- coom_binary(R,_,_,_), coom_binary(F,_,_,R), formula_context(F,Ctx).

formula_context(L,Ctx) :- coom_unary(L,_,_), coom_binary(F,L,_,_), formula_context(F,Ctx).
formula_context(R,Ctx) :- coom_unary(R,_,_), coom_binary(F,_,_,R), formula_context(F,Ctx).

formula_context(F',Ctx) :- coom_binary(F',_,_,_), coom_unary(F,_,F'), formula_context(F,Ctx).
formula_context(F',Ctx) :- coom_unary(F',_,_),    coom_unary(F,_,F'), formula_context(F,Ctx).

% Instantiate paths
path_start(X,P)  :- coom_binary(F,P,_,_),     coom_path(P,0,_), type_aux(X,Ctx), formula_context(F,Ctx).
path_start(X,P)  :- coom_binary(F,_,_,P),     coom_path(P,0,_), type_aux(X,Ctx), formula_context(F,Ctx).
path_start(X,P)  :- coom_unary(F,_,P),        coom_path(P,0,_), type_aux(X,Ctx), formula_context(F,Ctx).
path_start(X,P)  :- coom_combinations(C,_,P), coom_path(P,0,_), type_aux(X,Ctx), coom_context(C,Ctx).
path_start(X,P)  :- coom_function(Ctx,_,_,P), coom_path(P,0,_), type_aux(X,Ctx).
path_start(X,P)  :- coom_imply(C,P,_),        coom_path(P,0,_), type_aux(X,Ctx), coom_context(C,Ctx).

% Determine all ground paths
path_to(X,P,0,X')  :- coom_path(P,0,N),
                      path_start(X,P),     type_aux(X',_),  X' =(N,(X,_)).
path_to(X,P,1,X')  :- coom_path(P,0,"root"), coom_path(P,1,N),
                      path_start(X,P),     type_aux(X',_),  X' =(N,((),_)).

path_to(X,P,I,X'') :- coom_path(P,I,N),
                      path_to(X,P,I-1,X'), type_aux(X'',_), X''=(N,(X',_)).

path_to(X,P,@dotpath(X')) :- not coom_path(P,I+1,_), path_to(X,P,I,X').

% Constants and numbers
path_to(X,P,P) :- coom_binary(F,_,_,P), coom_constant(P), formula_context(F,T), type_aux(X,T).
path_to(X,P,P) :- coom_binary(F,P,_,_), coom_constant(P), formula_context(F,T), type_aux(X,T).
path_to(X,P,P) :- coom_binary(F,_,_,P), coom_number(P,_), formula_context(F,T), type_aux(X,T).
path_to(X,P,P) :- coom_binary(F,P,_,_), coom_number(P,_), formula_context(F,T), type_aux(X,T).

% Instantiate binaries and unaries
binary(X,F,@binary(XL,Op,XR),XL,Op,XR) :- coom_binary(F,L,Op,R),
                                          formula_context(F,C),
                                          type_aux(X,C), path_to(X,L,XL), path_to(X,R,XR).

unary(X,F,@unary(X',Op),Op,X') :- coom_unary(F,Op,F'),
                                  formula_context(F,C),
                                  type_aux(X,C), path_to(X,F',X').

ground_formula(X,F,G)  :- binary(X,F,G,_,_,_).
ground_formula(X,F,G)  :- unary(X,F,G,_,_).

% Default binaries for arithmetics if one side is undefined
% TODO: Does this always give desired behavior?
ground_formula(X,F,XL) :- coom_binary(F,L,"+",R),
                          formula_context(F,C),
                          type_aux(X,C), path_to(X,L,XL), not path_to(X,R,_).

ground_formula(X,F,XR) :- coom_binary(F,L,"+",R),
                          formula_context(F,C),
                          type_aux(X,C), not path_to(X,L,_), path_to(X,R,XR).


% Instantiate functions
function(X,F,T,P) :- coom_function(C,F,T,P), type_aux(X,C).

% Auxiliary paths for formulas and functions
path_to(X,F,G) :- ground_formula(X,F,G).
path_to(X,F,@aggregate(T,X,P)) :- function(X,F,T,P).

% Auxiliary paths for cardinalities
path_to(X,N,@dotpath(X')) :- coom_feature(Ctx,N,_,_,_), type_aux(X,Ctx), type_aux(X',_), X' =(N,(X,_)).
path_to(X,A,@dotpath(X')) :- coom_attribute(T,A,_),     type_aux(X,T),   type_aux(X',_), X' =(A,(X,_)).

% Instantiate conditional requirements
conditional_requirement(C,G,G') :- coom_context(C,Ctx), coom_condition(C,F), ground_formula(X,F,G),
                                   type_aux(X,Ctx),     coom_require(C,F'),  ground_formula(X,F',G').

% Instantiate combination tables
table(C,X) :- coom_combinations(C,_,_), coom_context(C,Ctx), type_aux(X,Ctx).

combinations_tuple((C,Ctx),Col,(X,())) :- table(C,Ctx),
                                          coom_combinations(C,Col,P), not coom_combinations(C,Col+1,_),
                                          path_to(Ctx,P,X).
combinations_tuple((C,Ctx),Col,(X',X)) :- combinations_tuple((C,Ctx),Col+1,X),
                                          coom_combinations(C,Col,P), Col >= 0,
                                          path_to(Ctx,P,X').
combinations_tuple(C,CT) :- combinations_tuple(C,0,CT).

tuple_order(C,CT,ID) :-  combinations_tuple(C,CT), ID = #count{ CT': combinations_tuple(C,CT'), CT'<CT }.

in_tuple((X,CT'),CT',X) :- combinations_tuple(_,CT), CT=(X,CT').
in_tuple(CT,CT',X)      :- in_tuple(CT,(X,CT'),_).
in_tuple(CT,X)          :- in_tuple(CT,_,X).

% Instantiate imply statements
imply(C,X',G)                  :- coom_imply(C,P,F), coom_context(C,Ctx), type_aux(X,Ctx), path_to(X,P,X'), ground_formula(X,F,G).
imply(C,X',@aggregate(T,X,P')) :- coom_imply(C,P,F), coom_context(C,Ctx), type_aux(X,Ctx), path_to(X,P,X'), function(X,F,T,P').

% Instantiate attribute constraints
attribute_constraint((T,@dotpath(X)))  :- coom_attribute(T,_,_), type_aux(X,T).
attribute_constraint_column(T,Col+1,A) :- coom_attribute(T,A,_), Col = #count{ A' : coom_attribute(T,A',_), A' < A }.

% Instantiate cardinality constraints
cardinality_aux(X,N,Min) :- coom_feature(C,N,_,Min,_), type_aux(X,C).
cardinality_aux(X,A,1)   :- coom_attribute(T,A,_),     type_aux(X,T).

% Include boolean enumeration if needed
coom_enumeration("Bool")     :- coom_feature(_,_,"Bool",_,_).
coom_option("Bool", "True")  :- coom_feature(_,_,"Bool",_,_).
coom_option("Bool", "False") :- coom_feature(_,_,"Bool",_,_).
