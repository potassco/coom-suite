% Instantiate conditional requirements
% Collect all "ground" conditions
conditions_aux(C,X,0,(G,()))  :- coom_context(C,Ctx), type_aux(X,Ctx), coom_condition(C,0,F), ground_formula(X,F,G).
conditions_aux(C,X,I+1,(G,T)) :- conditions_aux(C,X,I,T), coom_condition(C,I+1,F), ground_formula(X,F,G).
conditions_aux(C,X,T)         :- conditions_aux(C,X,I,T), not coom_condition(C,I+1,_).

% Combine all conditions in one conjunction
conditions_binary(C,X,@binary(L,"&&",R),L,R,T) :- conditions_aux(C,X,(R,(L,T))).
conditions_binary(C,X,@binary(L,"&&",R),L,R,T) :- conditions_binary(C,X,R,_,_,(L,T)).

conditions(C,X,G)              :- conditions_aux(C,X,(G,())).
conditions(C,X,@unary(G,"()")) :- conditions_binary(C,X,G,_,_,()).

conditional_requirement(C,G,G') :- coom_context(C,Ctx), type_aux(X,Ctx), conditions(C,X,G),
                                   coom_require(C,F'),  ground_formula(X,F',G').

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
