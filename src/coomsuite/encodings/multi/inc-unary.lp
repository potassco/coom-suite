#program incremental_unary(f,op,x,bound).
unary(f,op,x).

defined(f,bound) :- unary(f,op,x), defined(x,bound), max_bound(bound).
defined(f,bound) :- unary(f,op,x), value(f,_,bound), max_bound(bound).

value(f, V,bound) :- unary(f,op,x), value(x,V,bound), op = "()", max_bound(bound).
value(f, V,bound) :- unary(f,op,x), value(x,V,bound), op = "+", max_bound(bound).
value(f, V,bound) :- unary(f,op,x), value(x,V,bound), op = "-", max_bound(bound).

satisfied(f,bound) :- unary(f,op,x), not satisfied(x,bound), op = "!", max_bound(bound).
satisfied(f,bound) :- unary(f,op,x),     satisfied(x,bound), op = "()", max_bound(bound).
