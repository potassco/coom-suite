%%% Output atoms
% Attributes of the model (enumerations and numeric features in COOM)
discrete(T) :- coom_enumeration(T).
domain(T,V) :- coom_option(T,V).

% Enumeration attributes
discrete(@fmt_join(T,A)) :- coom_attribute(T,A,"str").
domain(@fmt_join(T,A),V) :- coom_attribute_value(T,_,A,V), coom_attribute(T,A,"str").

integer(@fmt_join(T,A))       :- coom_attribute(T,A,"num"), not discrete.
range(@fmt_join(T,A),Min,Max) :- coom_attribute(T,A,"num"), not discrete,
                                 Min = #min { V: coom_attribute_value(T,_,A,V) },
                                 Max = #max { V: coom_attribute_value(T,_,A,V) }.

% Temporary fix: For clingo, huge ranges might make grounding to large, translate numeric attributes to discrete attributes
discrete(@fmt_join(T,A)) :- coom_attribute(T,A,"num"), discrete.
domain(@fmt_join(T,A),V) :- coom_attribute_value(T,_,A,V), coom_attribute(T,A,"num"), discrete.

% Numeric features
integer(@fmt_join(Ctx,N))       :- coom_feature(Ctx,N,"num",_,_).
range(@fmt_join(Ctx,N),Min,Max) :- coom_feature(Ctx,N,"num",_,_), coom_range(Ctx,N,Min,Max).

#show discrete/1.
#show domain/2.

#show integer/1.
#show range/3.

% Instances (of structures, enumerations and attributes in COOM)
type("root","product") :- coom_structure("product").

type(PX,T)              :- obj_path(X,PX), type_aux(X,T), not coom_attribute(_,T,_).
type(PX,@fmt_join(T,A)) :- obj_path(X,PX), type_aux(X,A), coom_attribute(T,A,_), type_aux(P,T), X=(_,(P,_)).

index(PX,Idx)           :- obj_path(X,PX), type_aux(X,T), X=((_,(_,Idx))).
parent(PX,PP)           :- obj_path(X,PX), type_aux(X,_), X=(_,(P,_)), obj_path(P,PP).

#show type/2.
#show index/2.
#show parent/2.

%%% Constraints
% Formulas
% Constraints at root and without conditions can be instantiated "as is"
constraint((C,G),"boolean") :- coom_require(C,F), ground_formula((),F,G), not coom_condition(C,_,_).

% Local constraints without conditions get converted into conditional requirement
% to add an "definedness" condition on their context variable
local_constraint(C,PX,G) :- coom_require(C,F), ground_formula(X,F,G), not coom_condition(C,_,_), X != (), obj_path(X,PX).
function(@fmt_unary(X,"count"),"count",X)    :- local_constraint(C,X,G).
set(X,X)                                     :- local_constraint(_,X,_).
binary(@fmt_binary(Fun,"=","1"),Fun,"=","1") :- local_constraint(_,X,_), function(Fun,"count",X).
number("1",1)                                :- local_constraint(_,_,_).
conditional_requirement(C,Con,G)             :- local_constraint(C,X,G), function(Fun,"count",X), binary(Con,Fun,"=","1").


% Conditional requirements get converted into a disjuction
constraint((C,@fmt_implication(Con,Req)),"boolean")            :- conditional_requirement(C,Con,Req).
binary(@fmt_implication(Con,Req),@fmt_unary(Con,"!"),"||",Req) :- conditional_requirement(_,Con,Req).
unary(@fmt_unary(Con,"!"),"!",Con)                             :- conditional_requirement(_,Con,_).
unary(@fmt_unary(G,"()"),"()",G)                               :- conditions_binary(_,_,G,_,_,()).
binary(G,L,"&&",R)                                             :- conditions_binary(_,_,G,L,R,_).

binary(G,L,Op,R) :- binary(_,_,G,L,Op,R).
unary(G,Op,F')   :- unary(_,_,G,Op,F').

#show constraint/2.
#show binary/4.
#show unary/3.

% Table constraints
constraint((C,PX),"table") :- table(C,X), obj_path(X,PX).
column((C,PX),CT,Col,X') :- coom_combinations(C,Col,P), obj_path(X,PX),
                            path_to(X,P,X'), in_tuple(CT,X').
allow(C,XY,V) :- coom_allow(C,XY,V).

#show column/4.
#show allow/3.

% Attribute constraints
% table constraint guarantees that correct values are assigned to enumeration attributes
constraint(C,"table") :- attribute_constraint(C).
column((T,X),0,0,X)   :- attribute_constraint((T,X)).
column((T,P),0,Col,X) :- attribute_constraint((T,P)), parent(X,P), type(X,@fmt_join(T,A)), attribute_constraint_column(T,Col,A).

allow(T,(0,I),O)     :- attribute_constraint((T,_)), coom_option(T,O), I = #count{ O' : coom_option(T,O'), O' < O}.
allow(T,(Col,Row),V) :- attribute_constraint((T,_)), allow(T,(0,Row),O), coom_attribute_value(T,O,A,V), attribute_constraint_column(T,Col,A).

% Imply statements
constraint((C,@fmt_binary(X',"=",G)),"boolean") :- imply(C,X',G).
binary(@fmt_binary(X',"=",G),X',"=",G)          :- imply(C,X',G).

% Functions
function(@fmt_aggregate(T,X,P),T,@fmt_join(X,P)) :- function(X,_,T,P).
set(@fmt_join(X,P),X')                           :- function(X,_,_,P), path_to(X,P,X').

#show function/3.
#show set/2.

% Partonomy and cardinality constraints
part(T) :- coom_structure(T).

constraint((@fmt_join(X,N),Min),"lowerbound") :- cardinality_aux(X,N,Min).
set(@fmt_join(X,N),X')                        :- cardinality_aux(X,N,_), path_to(X,N,X').

#show part/1.

% Constants and numbers
constant(C) :- coom_constant(C).
number(C,N) :- coom_number(C,N).

#show constant/1.
#show number/2.

% Defaults
default(X',V) :- coom_default(ID,P,V), coom_context(ID,T), type_aux(X,T), path_to(X,P,X').

#show default/2.

% Optimization
minimize(X',V) :- coom_minimize(C,V,P), coom_context(C,Ctx), type_aux(X,Ctx), path_to(X,P,X').
maximize(X',V) :- coom_maximize(C,V,P), coom_context(C,Ctx), type_aux(X,Ctx), path_to(X,P,X').

#show minimize/2.
#show maximize/2.

% Explanations
explanation(C,E) :- coom_explanation(C,E).
#show explanation/2.

% User input
user_include(X) :- coom_user_include(X).
user_value(X,V) :- coom_user_value(X,V).

#show user_include/1.
#show user_value/2.
