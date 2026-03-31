% Max bound for unbounded cardinalities
#const max_bound = 10.

%%% Instantiate complete instance tree
% Root is always included
type_aux((),"product") :- coom_structure("product").

% Create auxiliary predicate for every feature
type_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,    Min,Max),  type_aux(X,Ctx), I = 0..M-1,             T != "num", M = #max{Max;Min+max_bound}.
type_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,    Min,#sup), type_aux(X,Ctx), I = 0..Min+max_bound-1, T != "num".
type_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",Min,Max),  type_aux(X,Ctx), I = 0..M-1,                         M = #max{Max;Min+max_bound}.
type_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",Min,#sup), type_aux(X,Ctx), I = 0..Min+max_bound-1.


% Create auxiliary prediate for attribute variables
type_aux((A,(X,0)),A) :- type_aux(X,T), coom_enumeration(T), coom_attribute_value(T,_,A,_).
