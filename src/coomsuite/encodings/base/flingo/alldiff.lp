% All-different constraints
violated((S,(X1,X2))) :- constraint(S,"alldiff"), set(S,X1), set(S,X2), X1 != X2, &sum{X1} = X2.
