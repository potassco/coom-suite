#program new_unary(f,op,f').
unary(f,op,f').

% boolean unaries
defined(f) :- unary(f,op,f'), defined(f').

satisfied(f) :- unary(f,op,f'), not satisfied(f'), op = "!".
satisfied(f) :- unary(f,op,f'),     satisfied(f'), op = "()".

% numeric unaries
defined(f) :- unary(f,op,f'), value(f,_).

value(f, V) :- unary(f,op,f'), value(f',V), op = "()".
value(f, V) :- unary(f,op,f'), value(f',V), op = "+".
value(f,-V) :- unary(f,op,f'), value(f',V), op = "-".
