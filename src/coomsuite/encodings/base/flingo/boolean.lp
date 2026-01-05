% Satisfaction of binary comparison relations for numeric values in flingo
satisfied(F) :- binary(F,X1,"=", X2), &sum{X1} =  X2.
satisfied(F) :- binary(F,X1,"!=",X2), &sum{X1} != X2.
satisfied(F) :- binary(F,X1,">", X2), &sum{X1} >  X2.
satisfied(F) :- binary(F,X1,">=",X2), &sum{X1} >= X2.
satisfied(F) :- binary(F,X1,"<", X2), &sum{X1} <  X2.
satisfied(F) :- binary(F,X1,"<=",X2), &sum{X1} <= X2.

defined(F) :- binary(F,X1,_,X2), &df{X1}, &df{X2}.


% % % require count(carrier.bag) + count(frame.bag) <= 4

% constraint((0,"count(root.carrier.bag)+count(root.frame.bag)<=4"),"boolean").
% binary("count(root.carrier.bag)+count(root.frame.bag)<=4","count(root.carrier.bag)+count(root.frame.bag)","<=","4").
% binary("count(root.carrier.bag)+count(root.frame.bag)","count(root.carrier.bag)","+","count(root.frame.bag)").
% function("count(root.carrier.bag)","count","root.carrier.bag").
% set("root.carrier.bag","root.carrier[0].bag[0]").
% set("root.carrier.bag","root.carrier[0].bag[1]").
% set("root.carrier.bag","root.carrier[0].bag[2]").
% function("count(root.frame.bag)","count","root.frame.bag").
% set("root.frame.bag","root.frame[0].bag[0]").
% set("root.frame.bag","root.frame[0].bag[1]").
% number("4",4).

% &sum{ 1,X : set("root.carrier.bag",X), include(X); 1,X : set("root.frame.bag",X), include(X) } <= 4.


% require totalWeight = frontWheel.weight + rearWheel.weight
% 					+ sum(carrier.bag.capacity.weight)
% 					+ sum(frame.bag.capacity.weight)

% &sum { X' : term((C,X),X') } = X :- imply((C,X),F), not condition((C,X),_).

% constraint((C,F),"boolean").
% term((C,F), )
