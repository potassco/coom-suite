% Satisfaction of binary comparison relations for numeric values in flingo
satisfied(F) :- binary(F,X1,"=", X2), &sum{X1} =  X2.
satisfied(F) :- binary(F,X1,"!=",X2), &sum{X1} != X2.
satisfied(F) :- binary(F,X1,">", X2), &sum{X1} >  X2.
satisfied(F) :- binary(F,X1,">=",X2), &sum{X1} >= X2.
satisfied(F) :- binary(F,X1,"<", X2), &sum{X1} <  X2.
satisfied(F) :- binary(F,X1,"<=",X2), &sum{X1} <= X2.

defined(F) :- binary(F,X1,_,X2), &df{X1}, &df{X2}.


% % Constraint 0
% &sum{ 1,X : set("root.carrier.bag",X), include(X); 1,X : set("root.frame.bag",X), include(X) } <= 4.

% % Constraint 1
% &sum { X' : term((C,X),X'), include(X') ; X' : sum_term((C,X),S), set(S,X'), include(X') ; 1,X' : count_term((C,X),S), set(S,X'), include(X') } = X :- imply((C,X),F), not condition((C,X),_).

% constraint((1,"root.totalWeight[0]=root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)"),"boolean").
% term((1,"root.totalWeight[0]=root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)"),"root.frontWheel[0].weight[0]").
% term((1,"root.totalWeight[0]=root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)"),"root.rearWheel[0].weight[0]").
% sum_term((1,"root.totalWeight[0]=root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)"),"root.carrier.bag.capacity.weight").
% sum_term((1,"root.totalWeight[0]=root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)"),"root.frame.bag.capacity.weight").

% &sum { X' : term((C,X),X'), include(X') } = X :- constraint((C,F),"boolean").



appears((C,F),F') :- constraint((C,F),"boolean"), binary(F,F',_,_).
appears((C,F),F') :- constraint((C,F),"boolean"), binary(F,_,_,F').
appears((C,F),F') :- constraint((C,F),"boolean"), unary(F,_,F').

appears(C,F') :- appears(C,F), binary(F,F',_,_).
appears(C,F') :- appears(C,F), binary(F,_,_,F').
appears(C,F') :- appears(C,F), unary(F,_,F').

term(C,X,"+") :- appears(C,X), binary(_,_,"+",X), type(X,_).
term(C,X,"-") :- appears(C,X), binary(_,_,"-",X), type(X,_).
term(C,X,"+") :- appears(C,X), binary(_,X,"+",_), type(X,_).
term(C,X,"+") :- appears(C,X), binary(_,X,"-",_), type(X,_).

% &sum { X' : term((C,F),X',"+"), include(X') } = X :- constraint((C,F),"boolean"), binary(F,_,"=",_).
#show term/3.
