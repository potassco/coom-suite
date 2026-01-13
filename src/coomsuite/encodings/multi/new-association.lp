#program new_association(x,t,min,max).
association(x,t,min,max).

min { associate((x,XT)) : type(XT,t), include(XT) } max :- association(x,t,min,max), include(x).

associate((x,XT),I) :- associate((x,XT)), I = #count{ XT' : associate((x,XT')), XT' < XT }.

:- associate((x,XT)), associate((X',XT)), x != X'.
