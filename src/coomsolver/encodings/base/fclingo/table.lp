#include "../clingo/table.lp".

% Satisfaction of combinations tables for numeric values in fclingo
hit_cell(C,ID,(Col,Row)) :- allow(I,(Col,Row),V), column(C,ID,Col,X), &sum{X} = V, C=(I,_).

defined(C,ID,Col) :- column(C,ID,Col,X), &df{X}.
