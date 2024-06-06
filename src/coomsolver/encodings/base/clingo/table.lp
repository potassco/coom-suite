% Table constraints (only for allow)

% Check combinations
hit_cell(C,ID,(Col,Row)) :- allow(Idx,(Col,Row),V), column(C,ID,Col,X), value(X,V), C=(Idx,_).

hit_row(C,ID) :- allow(Idx,(_,Row),_), column(C,ID,_,_), C=(Idx,_),
                 0 = #sum{ 1,Col : allow(Idx,(Col,Row),_);
                          -1,Col': hit_cell(C,ID,(Col',Row)) }.

defined(C,ID,Col) :- column(C,ID,Col,X), value(X,_).
defined(C,ID)     :- column(C,ID,_,_), 0 = #sum{ 1, Col: column(C,ID,Col,_);
                                                -1, Col: defined(C,ID,Col)}.
