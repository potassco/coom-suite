% Resolve the iterable in the behavior context, then bind its variable per member.
path_start(X,P) :- coom_function(C,F,_,_), coom_function_binding(F,_,P), type_aux(X,C).
comprehension_member(X,F,M) :- coom_function(C,F,_,_), type_aux(X,C),
    coom_function_binding(F,_,P), path_to(X,P,I,M), not coom_path(P,I+1,_).

path_origin(member(X,F,M),X) :- comprehension_member(X,F,M).
path_binding(member(X,F,M),V,M) :- comprehension_member(X,F,M), coom_function_binding(F,V,_).

% Projections and filters use the ordinary path and formula instantiation rules.
formula_instance(member(X,F,M),A) :- comprehension_member(X,F,M), coom_function(_,F,_,A).
formula_instance(member(X,F,M),C) :- comprehension_member(X,F,M), coom_function_condition(F,C).
path_to(E,P,P) :- E=member(X,F,M), formula_instance(E,P), coom_number(P,_).
path_to(E,P,P) :- E=member(X,F,M), formula_instance(E,P), coom_constant(P), not path_binding(E,P,_).

function(@scoped(X,F),T,@scoped(X,F)) :-
    coom_function(C,F,T,_), coom_function_binding(F,_,_), type_aux(X,C).
path_to(X,F,@scoped(X,F)) :-
    coom_function(C,F,_,_), coom_function_binding(F,_,_), type_aux(X,C).
ground_formula(X,F,@scoped(X,F)) :-
    coom_function(C,F,_,_), coom_function_binding(F,_,_), type_aux(X,C).

% Proxies retain member identity, even when projected values are equal.
set(@scoped(X,F),@scoped(member(X,F,M),F)) :- comprehension_member(X,F,M).
aggregate_member(@scoped(member(X,F,M),F),@dotpath(M),A) :-
    comprehension_member(X,F,M), coom_function(_,F,_,P), path_to(member(X,F,M),P,A).
aggregate_condition(@scoped(member(X,F,M),F),C) :-
    comprehension_member(X,F,M), coom_function_condition(F,P), path_to(member(X,F,M),P,C).
aggregate_filtered(@scoped(member(X,F,M),F)) :-
    comprehension_member(X,F,M), coom_function_condition(F,_).

#show aggregate_member/3.
#show aggregate_condition/2.
#show aggregate_filtered/1.
