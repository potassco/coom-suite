#program new_minimize(x,p).
minimize(x,p).
#minimize { V@p : value(x,V), minimize(x,p) }.

#program new_maximize(x).
maximize(x,p).
#maximize { V@p : value(x,V), maximize(x,p) }.
