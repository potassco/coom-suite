% Satisfaction of combinations tables for numeric values in fclingo
% hit_cell(C,ID,(Col,Row)) :- allow(I,(Col,Row),V), column(C,ID,Col,X), &sum{X} = V, C=(I,_).

% defined(C,ID,Col) :- column(C,ID,Col,X), &df{X}.

nhit_cell(C,ID,Row) :- allow(Idx,(Col,Row),_), column(C,ID,Col,X), C=(Idx,_), not &sum{X} = V : allow(Idx,(Col,Row),V).

undefined(C,ID) :- column(C,ID,Col,X), not &df{X}.
