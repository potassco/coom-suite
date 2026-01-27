%%% Output atoms
% Attributes of the model (enumerations and numeric features in COOM)
discrete(T,str)  :- coom_enumeration(T), T != "Bool".
discrete(T,bool) :- coom_enumeration(T), T = "Bool".
domain(T,V)      :- coom_option(T,V).

% Enumeration attributes
discrete(@join(T,A),str) :- coom_attribute(T,A,"str").
domain(@join(T,A),V)     :- coom_attribute_value(T,_,A,V), coom_attribute(T,A,"str").


discrete(@join(T,A),int) :- coom_attribute(T,A,"num"). % TODO: Add case for floats
domain(@join(T,A),V)     :- coom_attribute_value(T,_,A,V), coom_attribute(T,A,"num").

% Numeric features
numeric(@join(Ctx,N),int)   :- coom_feature(Ctx,N,"num",_,_). % TODO: Add case for floats
range(@join(Ctx,N),Min,Max) :- coom_feature(Ctx,N,"num",_,_), coom_range(Ctx,N,Min,Max).

#show discrete/2.
#show domain/2.

#show numeric/2.
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
% Constraints at root and without conditions can be instantiated "as is"
constraint((C,G),"boolean") :- coom_require(C,F), ground_formula((),F,G), not coom_condition(C,_,_).

% Local constraints without conditions get converted into conditional requirement
% to add an "definedness" condition on their context variable
local_constraint(C,@dotpath(X),G) :- coom_require(C,F), ground_formula(X,F,G), not coom_condition(C,_,_), X != ().
aggregate(@unary(X,"count"),"count",X)     :- local_constraint(C,X,G).
set(X,X)                                  :- local_constraint(_,X,_).
binary(@binary(Fun,"=","1"),Fun,"=","1")  :- local_constraint(_,X,_), aggregate(Fun,"count",X).
constant(("1",1),int)                     :- local_constraint(_,_,_).
conditional_requirement(C,Con,G)          :- local_constraint(C,X,G), aggregate(Fun,"count",X), binary(Con,Fun,"=","1").


% Conditional requirements get converted into a disjuction
constraint((C,@implication(Con,Req)),"boolean")        :- conditional_requirement(C,Con,Req).
binary(@implication(Con,Req),@unary(Con,"!"),"||",Req) :- conditional_requirement(_,Con,Req).
unary(@unary(Con,"!"),"!",Con)                         :- conditional_requirement(_,Con,_).
unary(@unary(G,"()"),"()",G)                           :- conditional_requirement(C,_,_), conditions_binary(C,_,G,_,_,()).
binary(G,L,"&&",R)                                     :- conditional_requirement(C,_,_), conditions_binary(C,_,G,L,R,_).

binary(G,L,Op,R) :- binary(_,_,G,L,Op,R).
unary(G,Op,F)    :- unary(_,_,G,Op,F).

#show constraint/2.
#show binary/4.
#show unary/3.

% Table constraints
constraint((C,@dotpath(X)),"table") :- table(C,X).
column((C,@dotpath(X)),CT,Col,X') :- coom_combinations(C,Col,P),
                                               path_to(X,P,X'), in_tuple(CT,X').
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
imply((C,X'),G)       :- imply((C,_),X',G), not coom_condition(C,_,_).

imply((C,X'),G)       :- imply((C,X),X',G), ground_condition(C,X,_,_).
condition((C,X'),Con) :- imply((C,X),X',_), conditions(C,X,Con).
unary(@unary(G,"()"),"()",G)    :- conditions(C,_,_), conditions_binary(C,_,G,_,_,()).
binary(G,L,"&&",R)              :- conditions(C,_,_), conditions_binary(C,_,G,L,R,_).

#show imply/2.
#show condition/2.

% Alldiff constraints
constraint(@join(X,P),"alldiff") :- alldiff(X,P).
set(@join(X,P),X')               :- alldiff(X,P), path_to(X,P,X').

% Aggregates
% aggregate(@aggregate(T,X,P),T,@join(X,P)) :- aggregate(X,_,T,P).
% set(@join(X,P),X')                       :- aggregate(X,_,_,P), path_to(X,P,X').
% #show aggregate/3.
% #show set/2.

% no comprehension
aggregate(@aggregate(T,X,P),T,@join(X,P)) :-
    aggregate(X,A,T,P),
    not coom_aggregate_comprehension(_,A,_,_).

set(@join(X,P),X') :- aggregate(X,_,_,P), path_to(X,P,X').

% with comprehension
aggregate(@aggregate(T,X,P,Val,Var,C),T,@join(X,P)) :-
    aggregate(X,A,T,P),
    coom_aggregate_comprehension(_,A,Val,Var),
    coom_aggregate_condition(_,A,C).

condition(@aggregate(T,X,P,Val,Var,C),@binary(@join(X,L),Op,R)) :- % TODO: Always binary?
    aggregate(X,A,T,P),
    aggregate_condition(X,A,_,(L,Op,R)),
    coom_aggregate_comprehension(_,A,Val,Var),
    coom_aggregate_condition(_,A,C).

property((@join(X,P),X'),(@binary(@join(X,L),Op,R),G)) :-
    aggregate(X,A,_,P),
    aggregate_condition(X,A,F,(L,Op,R)),
    aggregate_property(X,A,(P,X'),(F,G)).

#show aggregate/3.
#show condition/2.
#show property/2.
#show set/2.

% Partonomy and cardinality constraints
part(T) :- coom_structure(T).

constraint((@join(X,N),Min),"lowerbound") :- cardinality_aux(X,N,Min).
set(@join(X,N),X')                        :- cardinality_aux(X,N,_), path_to(X,N,X').

#show part/1.

% Constants and numbers
constant(C,CT)               :- coom_constant(C,CT), CT = (str;bool;float).
constant((C,@number(C)),int) :- coom_constant(C,int).

#show constant/2.

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
