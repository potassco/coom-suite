%%% Instantiate conditions
% Collect all "ground" conditions
%*! conditions_aux(C,X,I,T)

Represents a conjunction of conditions for a constraint `C` instantiated relative to object `X`.
The index of the current condition is given by `I`.

Args:
    - C: The constraint indentifier
    - X: The internal object identifier
    - I: The current condition index
    - T: The tuple of conditions (ground formulas)
*%
conditions_aux(C,X,0,(G,()))  :- coom_context(C,Ctx), type_aux(X,Ctx), coom_condition(C,0,F), ground_formula(X,F,G).
conditions_aux(C,X,I+1,(G,T)) :- conditions_aux(C,X,I,T), coom_condition(C,I+1,F), ground_formula(X,F,G).

%*! conditions_aux(C,X,T)

Projection of `conditions_aux/4` of complete conjunctions of conditions.

Args:
    - C: The constraint identifier
    - X: The internal object identifier
    - T: The tuple of conditions (ground formulas)
*%
conditions_aux(C,X,T)         :- conditions_aux(C,X,I,T), not coom_condition(C,I+1,_).

%*! conditions_binary(C,X,F,L,R,T)

Combines the tuple of conditions of `conditions_aux/3` into a conjunction.

Args:
    - C: The constraint identifier
    - X: The internal object identifier
    - F: The conjunction (in output format)
    - L: The left formula of the conjunction (internal format)
    - R: The right formula fo the conjunction (internal format)
    - T: The remaining tuple of conditions to add to the conjunction `F`
*%
% Combine all conditions in one conjunction
% Base case: for conditions_aux/3 pack the first two conditons into a conjunction
conditions_binary(C,X,@binary(L,"&&",R),L,R,T) :- conditions_aux(C,X,(R,(L,T))).
% Extend recursively: add the next conditions to the conjunction
conditions_binary(C,X,@binary(L,"&&",R),L,R,T) :- conditions_binary(C,X,R,_,_,(L,T)).

%*! conditions(C,X,G)

Represents the conjunction of all conditions for a constraint `C` instantiated relative to object `X`.

Args:
    - C: The constraint identifier
    - X: The internal object identifier
    - G: The ground formula identifier for the combined condition
*%
conditions(C,X,G)              :- conditions_aux(C,X,(G,())).
conditions(C,X,@unary(G,"()")) :- conditions_binary(C,X,G,_,_,()).

%*! conditional_requirement(C,G,G')

Represents an instantiated conditional constraint.

Args:
    - C: The constraint identifier
    - G: The ground formula for the condition
    - G': The ground formula for the requirement
*%

conditional_requirement(C,G,G') :- coom_context(C,Ctx), type_aux(X,Ctx), conditions(C,X,G),
                                   coom_require(C,F'),  ground_formula(X,F',G').

%%% Instantiate imply statements
%*! imply(C,X',G)

Represents an instantiated imply statement.

Args:
    - C: The constraint identifier
    - X': The path expression of the implied variable
    - G: The ground formula or aggregate identifier for the implied value
*%
imply(C,X',G)                  :- coom_imply(C,P,F), coom_context(C,Ctx), type_aux(X,Ctx), path_to(X,P,X'), ground_formula(X,F,G).
imply(C,X',@aggregate(T,X,P')) :- coom_imply(C,P,F), coom_context(C,Ctx), type_aux(X,Ctx), path_to(X,P,X'), function(X,F,T,P').

%%% Instantiate attribute constraints
%*! attribute_constraint(C)

Represents an auxiliary table costraint for attribute values.

Args:
    - C: The attribute constraint identifier (a tuple of type name and object path)
*%
attribute_constraint((T,@dotpath(X)))  :- coom_attribute(T,_,_), type_aux(X,T).

%*! attribute_constraint_column(T,Col,A)

Represents a column of an auxiliary table constraint for attribute values.

Args:
    - T: The type of the attribute
    - Col: The column index of the value `A`
    - A: The attribute value
*%
attribute_constraint_column(T,Col+1,A) :- coom_attribute(T,A,_), Col = #count{ A' : coom_attribute(T,A',_), A' < A }.

%%% Instantiate cardinality constraints
%*! cardinality_aux(X,N,Min)

Auxiliary predicate collecting the minimum cardinality of a feature or attribute relative to its parent object.

Args:
    - X: The internal object identifier of the parent
    - N: The feature or attribute name
    - Min: The minimum cardinality (1 for attributes)
*%
cardinality_aux(X,N,Min) :- coom_feature(C,N,_,Min,_), type_aux(X,C).
cardinality_aux(X,A,1)   :- coom_attribute(T,A,_),     type_aux(X,T).

%%% Include boolean enumeration if needed
coom_enumeration("Bool")     :- coom_feature(_,_,"Bool",_,_).
coom_option("Bool", "True")  :- coom_feature(_,_,"Bool",_,_).
coom_option("Bool", "False") :- coom_feature(_,_,"Bool",_,_).
