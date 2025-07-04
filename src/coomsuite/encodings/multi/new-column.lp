#program new_column(c,id,col,x).
column(c,id,col,x).

undefined(c,id) :- column(c,id,_,x), not include(x).
defined(c,id)   :- column(c,id,_,_), not undefined(c,id).

not_hit(c,id,Row) :- allow(Idx,(col,Row),_), column(c,id,col,x), c=(Idx,_), not value(x,V) : allow(Idx,(col,Row),V).

satisfied(c,id) :- allow(Idx,(_,Row),_), column(c,id,_,_), c=(Idx,_), not not_hit(c,id,Row).
