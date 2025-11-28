#program incremental_minimize(x,p,bound).
#external max_bound(bound).
minimize(x,p).
#minimize { V@p : value(x,V,bound), minimize(x,p), max_bound(bound) }.

#program incremental_maximize(x,p,bound).
#external max_bound(bound).
maximize(x,p).
#maximize { V@p : value(x,V,bound), maximize(x,p), max_bound(bound) }.
