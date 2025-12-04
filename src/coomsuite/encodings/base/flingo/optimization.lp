&minimize{  X : minimize(X,_) }.

% it seems there are only minimization statements in clingcon/flingo available, however, there is a bug with negative values  https://github.com/potassco/clingcon/issues/120
&sum{X} = -neg(X) :- maximize(X,P).
minimize(neg(X),P) :- maximize(X,P).
% &minimize{ neg(X) : maximize(X,_) }.
