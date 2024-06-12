% Table constraints (only for allow)

% A table constraint is satisfied if none of its rows is not satisfied
% Note that a cell can consist of a tuple of values
nhit_row(C,ID,Row) :- allow(Idx,(Col,Row),_), column(C,ID,Col,X), C=(Idx,_), not value(X,V) : allow(Idx,(Col,Row),V).
satisfied(C,ID)    :- allow(Idx,(_,Row),_),   column(C,ID,_,_),   C=(Idx,_), not nhit_row(C,ID,Row).

% A table constraint is defined if none of its columns are undefined
undefined(C,ID) :- column(C,ID,_,X), not include(X).
defined(C,ID)   :- column(C,ID,_,_), not undefined(C,ID).
