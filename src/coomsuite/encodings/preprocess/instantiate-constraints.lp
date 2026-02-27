% Get formula context
formula_context(F,Ctx) :- coom_binary(F,_,_,_), coom_require(C,F),      coom_context(C,Ctx).
formula_context(F,Ctx) :- coom_binary(F,_,_,_), coom_condition(C,_,F),  coom_context(C,Ctx).
formula_context(F,Ctx) :- coom_binary(F,_,_,_), coom_imply(C,_,F),      coom_context(C,Ctx).

formula_context(F,Ctx) :- coom_unary(F,_,_),    coom_require(C,F),      coom_context(C,Ctx).
formula_context(F,Ctx) :- coom_unary(F,_,_),    coom_condition(C,_,F),  coom_context(C,Ctx).
formula_context(F,Ctx) :- coom_unary(F,_,_),    coom_imply(C,_,F),      coom_context(C,Ctx).

formula_context(L,Ctx)  :- coom_binary(L,_,_,_),  coom_binary(F,L,_,_), formula_context(F,Ctx).
formula_context(R,Ctx)  :- coom_binary(R,_,_,_),  coom_binary(F,_,_,R), formula_context(F,Ctx).

formula_context(L,Ctx)  :- coom_unary(L,_,_),     coom_binary(F,L,_,_), formula_context(F,Ctx).
formula_context(R,Ctx)  :- coom_unary(R,_,_),     coom_binary(F,_,_,R), formula_context(F,Ctx).

formula_context(F',Ctx) :- coom_binary(F',_,_,_), coom_unary(F,_,F'),   formula_context(F,Ctx).
formula_context(F',Ctx) :- coom_unary(F',_,_),    coom_unary(F,_,F'),   formula_context(F,Ctx).

% Instantiate binaries and unaries
binary(X,F,XL,Op,XR) :-
    coom_binary(F,L,Op,R),
    formula_context(F,C),
    type_aux(X,C),
    path_to(X,L,XL),
    path_to(X,R,XR).

unary(X,F,Op,X') :-
    coom_unary(F,Op,F'),
    formula_context(F,C),
    type_aux(X,C),
    path_to(X,F',X').
#show binary/5.
% Generate "ground" formulas
ground_formula(X,F,@binary(XL,Op,XR)) :- binary(X,F,XL,Op,XR).
ground_formula(X,F,@unary(X',Op))     :- unary(X,F,Op,X').

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

% Instantiate conditional requirements
conditions_aux(C,X,0,(G,()))  :- coom_context(C,Ctx), type_aux(X,Ctx), coom_condition(C,0,F), ground_formula(X,F,G).
conditions_aux(C,X,I+1,(G,T)) :- conditions_aux(C,X,I,T), coom_condition(C,I+1,F), ground_formula(X,F,G).
conditions_aux(C,X,T)         :- conditions_aux(C,X,I,T), not coom_condition(C,I+1,_).

conditions_binary(C,X,@binary(L,"&&",R),L,R,T) :- conditions_aux(C,X,(R,(L,T))).
conditions_binary(C,X,@binary(L,"&&",R),L,R,T) :- conditions_binary(C,X,R,_,_,(L,T)).

conditions(C,X,G)              :- conditions_aux(C,X,(G,())).
conditions(C,X,@unary(G,"()")) :- conditions_binary(C,X,G,_,_,()).

conditional_requirement(C,G,G') :- coom_context(C,Ctx), type_aux(X,Ctx), conditions(C,X,G),
                                   coom_require(C,F'),  ground_formula(X,F',G').

% Instantiate combination tables
table(C,X) :- coom_combinations(C,_,_), coom_context(C,Ctx), type_aux(X,Ctx).

combinations_tuple((C,Ctx),Col,(X,())) :- table(C,Ctx),
                                          coom_combinations(C,Col,P), not coom_combinations(C,Col+1,_),
                                          path_to(Ctx,P,X).
combinations_tuple((C,Ctx),Col,(X',X)) :- combinations_tuple((C,Ctx),Col+1,X),
                                          coom_combinations(C,Col,P), Col >= 0,
                                          path_to(Ctx,P,X').
combinations_tuple(C,CT) :- combinations_tuple(C,0,CT).

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
