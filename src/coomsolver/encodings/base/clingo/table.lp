% Table constraints (only for allow)

% hit_cell(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), column(C,ID,Col,X), value(X,V), C=(Idx,_).

% hit_row(C,ID) :- allow(Idx,(_,Row),_), column(C,ID,_,_), C=(Idx,_),
%                  0 = #sum{ 1,Col : allow(Idx,(Col,Row),_);
%                           -1,Col': hit_cell(C,ID,(Col',Row)) }.

% A row is satisfied if none of its cells are not satisfied
% Note that a cell can be a tuple of values
% hit_cell(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), column(C,ID,Col,X),     value(X,V),               C=(Idx,_).
% nhit_cell(C,ID,Row)      :- allow(Idx,(Col,Row),V), column(C,ID,Col,X), not hit_cell(C,ID,(Col,Row)), C=(Idx,_).

nhit_cell(C,ID,Row) :- allow(Idx,(Col,Row),_), column(C,ID,Col,X), C=(Idx,_), not value(X,V) : allow(Idx,(Col,Row),V).

hit_row(C,ID)       :- allow(Idx,(_,Row),_),   column(C,ID,_,_),   not nhit_cell(C,ID,Row),      C=(Idx,_).


undefined(C,ID) :- column(C,ID,_,X), not include(X).
defined(C,ID)   :- column(C,ID,_,_), not undefined(C,ID).
% defined(C,ID)   :- column(C,ID,_,X), include(X).
% defined(C,ID)     :- column(C,ID,_,_), 0 = #sum{ 1, Col: column(C,ID,Col,_);
%                                                 -1, Col: defined(C,ID,Col)}.
