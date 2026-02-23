#program incremental_unary(f,op,x,bound).
unary(f,op,x).

defined(f,bound) :- unary(f,op,x), defined(x,bound).
defined(f,bound) :- unary(f,op,x), value(f,_,bound).

value(f, V,bound) :- unary(f,op,x), value(x,V,bound), op = "()".
value(f, V,bound) :- unary(f,op,x), value(x,V,bound), op = "+".
value(f, V,bound) :- unary(f,op,x), value(x,V,bound), op = "-".

satisfied(f,bound) :- unary(f,op,x), not satisfied(x,bound), op = "!".
satisfied(f,bound) :- unary(f,op,x),     satisfied(x,bound), op = "()".
