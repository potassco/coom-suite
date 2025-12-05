&minimize{ X : minimize(X,_) }.

% it seems there are only minimization statements in clingcon/flingo available
&sum{X} = -neg(X) :- maximize(X,P).
minimize(neg(X),P) :- maximize(X,P).
% &minimize{ neg(X) : maximize(X,_) }.
