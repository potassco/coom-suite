%%% Output atoms
% Attributes of the model (enumerations and numeric features in COOM)
discrete(T) :- coom_enumeration(T).
domain(T,V) :- coom_option(T,V).

% Enumeration attributes
discrete(@join(T,A)) :- coom_attribute(T,A,"str").
domain(@join(T,A),V) :- coom_attribute_value(T,_,A,V), coom_attribute(T,A,"str").

integer(@join(T,A))       :- coom_attribute(T,A,"num"), not discrete.
range(@join(T,A),Min,Max) :- coom_attribute(T,A,"num"), not discrete,
                             Min = #min { V: coom_attribute_value(T,_,A,V) },
                             Max = #max { V: coom_attribute_value(T,_,A,V) }.

% Temporary fix: For clingo, huge ranges might make grounding to large, translate numeric attributes to discrete attributes
discrete(@join(T,A)) :- coom_attribute(T,A,"num"), discrete.
domain(@join(T,A),V) :- coom_attribute_value(T,_,A,V), coom_attribute(T,A,"num"), discrete.

% Numeric features
integer(@join(Ctx,N))       :- coom_feature(Ctx,N,"num",_,_).
range(@join(Ctx,N),Min,Max) :- coom_feature(Ctx,N,"num",_,_), coom_range(Ctx,N,Min,Max).

#show discrete/1.
#show domain/2.

#show integer/1.
#show range/3.

% Instances (of structures, enumerations and attributes in COOM)
type("root","product") :- coom_structure("product").

type(@dotpath(X),T)             :- type_aux(X,T), not coom_attribute(_,T,_).
type(@dotpath(X),@join(T,A))    :- type_aux(X,A),     coom_attribute(T,A,_), type_aux(P,T), X=(_,(P,_)).

index(@dotpath(X),Idx)          :- type_aux(X,T), X=((_,(_,Idx))).
parent(@dotpath(X),@dotpath(P)) :- type_aux(X,_), X=(_,(P,_)).

#show type/2.
#show index/2.
#show parent/2.

%%% Constraints
% Formulas
constraint((C,G),"boolean") :- coom_require(C,F), ground_formula(_,F,G), not coom_condition(C,_).

constraint((C,@implication(Con,Req)),"boolean")  :- conditional_requirement(C,Con,Req).
binary(@implication(Con,Req),@neg(Con),"||",Req) :- conditional_requirement(_,Con,Req).
unary(@neg(Con),"!",Con)                         :- conditional_requirement(_,Con,Req).

binary(G,L,Op,R) :- binary(_,_,G,L,Op,R).
unary(G,Op,F)    :- unary(_,_,G,Op,F).
% #show unary/5.
#show constraint/2.
#show binary/4.
#show unary/3.

% Table constraints
constraint((C,@dotpath(X)),"table") :- table(C,X).
column((C,@dotpath(X)),ID,Col,@dotpath(X')) :- coom_combinations(C,Col,P),
                                               path_to(X,P,X'), in_tuple(CT,X'), tuple_order((C,X),CT,ID).
allow(C,XY,V) :- coom_allow(C,XY,V).

#show column/4.
#show allow/3.

% Attribute constraints
% table constraint guarantees that correct values are assigned to enumeration attributes
constraint(C,"table") :- attribute_constraint(C).
column((T,X),0,0,X)   :- attribute_constraint((T,X)).
column((T,P),0,Col,X) :- attribute_constraint((T,P)), parent(X,P), type(X,@join(T,A)), attribute_constraint_column(T,Col,A).

allow(T,(0,I),O)     :- attribute_constraint((T,_)), coom_option(T,O), I = #count{ O' : coom_option(T,O'), O' < O}.
allow(T,(Col,Row),V) :- attribute_constraint((T,_)), allow(T,(0,Row),O), coom_attribute_value(T,O,A,V), attribute_constraint_column(T,Col,A).

% Imply statements
constraint((C,@binary(X',"=",G)),"boolean") :- imply(C,X',G).
binary(@binary(X',"=",G),X',"=",G)          :- imply(C,X',G).

% Functions
function(@aggregate(T,X,P),T,@join(X,P)) :- function(X,_,T,P).
set(@join(X,P),X')                       :- function(X,_,_,P), path_to(X,P,X').

#show function/3.
#show set/2.

% Partonomy and cardinality constraints
part(T) :- coom_structure(T).

constraint((@join(X,N),Min),"lowerbound") :- cardinality_aux(X,N,Min).
set(@join(X,N),X')                       :- cardinality_aux(X,N,_), path_to(X,N,X').

#show part/1.

% Constants and numbers
constant(C) :- coom_constant(C).
number(C,N) :- coom_number(C,N).

#show constant/1.
#show number/2.

% Explanations
explanation(C,E) :- coom_explanation(C,E).
#show explanation/2.

% User input
user_include(X) :- coom_user_include(X).
user_value(X,V) :- coom_user_value(X,V).

#show user_include/1.
#show user_value/2.
