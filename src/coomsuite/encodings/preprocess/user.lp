% Create auxiliary atoms for user input of unbounded variables
user_path(@reverse(X)) :- coom_user_include(X).
user_path_aux(P,P) :- user_path(P).
user_path_aux(P,X') :- user_path_aux(P,X), X = (_,(X',_)).
user_path_unbounded(P) :- user_path_aux(P,X'), X' = (F,(X,_)), coom_feature(Ctx,F,T,_, #sup), type_aux(X,Ctx), T != "num".

% Add auxiliary atoms for user includes that have unbounded features (and thus possibly would not get instantiated)
type_aux(X',T) :- user_path_unbounded(P), user_path_aux(P,X'), X' = (F,(X,_)), coom_feature(Ctx,F,T,_,_), type_aux(X,Ctx), T != "num".
