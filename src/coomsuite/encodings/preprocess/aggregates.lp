% Instantiate aggregates
% aggregate(X,F,T,P) :- coom_aggregate(C,F,T,P), type_aux(X,C).

% No comprehension
% simple case, aggregate just contains a path
aggregate(X,A,T,P) :-
    coom_aggregate(C,A,T),
    coom_aggregate_set(C,A,P),
    type_aux(X,C),
    not coom_aggregate_comprehension(C,A,_,_).

% Auxiliary path
path_to(X,F,@aggregate(T,X,P)) :-
    aggregate(X,F,T,P),
    not coom_aggregate_comprehension(_,F,_,_).

% With comprehension
% create atoms for condition
aggregate(X,A,T,@join_comprehension(S,P)) :-
    coom_aggregate(C,A,T),
    coom_aggregate_set(C,A,S),
    type_aux(X,C),
    coom_aggregate_comprehension(C,A,P,V).
#show aggregate/4.
#show aggregate_condition/4.
#show aggregate_variable/3.
#show aggregate_property/4.
#show coom_aggregate_set/3.

% with condition
aggregate_condition(X,A,F,(@join_comprehension(S,L),Op,R)) :-
    coom_aggregate_set(C,A,S),
    coom_aggregate_condition(C,A,F),
    type_aux(X,C),
    coom_binary(F,L,Op,R). % TODO: only binary?

aggregate_variable(X,A,X') :-
    aggregate(X,A,_,_),
    coom_aggregate_set(_,A,S),
    aggregate_condition(X,A,_,_),
    path_to(X,S,I,X'),
    not path_to(X,S,I+1,_).

% TODO: Make more general
aggregate_property(X,A,(P,X''),(F,G)) :-
    aggregate(X,A,_,P),
    aggregate_variable(X,A,X'),
    coom_path(P,1,N),
    path_to(X',N,X''),
    aggregate_condition(X,A,F,(L,Op,R)),
    binary(X,F,G,LX,_,_),
    coom_path(L,1,LN),
    path_to(X',LN,LX).

aggregate_property(X,A,(P,X'')) :-
    aggregate(X,A,_,P),
    aggregate_variable(X,A,X'),
    % coom_path(P,I,N),
    path_to(X',P,X'').
    % aggregate_condition(X,A,F,(L,Op,R)),
    % binary(X,F,G,LX,_,_),
    % coom_path(L,1,LN),
    % path_to(X',LN,LX).
#show aggregate_property/3.
#show coom_path/3.
#show path_to/3.
#show path_to/4.
% aggregate_property(("semester",((),0)),"sum(s.modules.ectsforsinroot.semesterifs.id<id)",("modules.ects","root.semester[0].modules[0].ects[0]"),("s.id<id","root.semester[0].id[0]<root.semester[0].id[0]")).

% property(("root.semester[0].modules.ects","root.semester[0].modules[0].ects[0]"),("root.semester.id<id","root.semester[0].id[0]<root.semester[0].id[0]")).
% property(("root.semester[0].modules.ects","root.semester[1].modules[0].ects[0]"),("root.semester.id<id","root.semester[1].id[0]<root.semester[0].id[0]")).
% property(("root.semester[0].modules.ects","root.semester[2].modules[0].ects[0]"),("root.semester.id<id","root.semester[2].id[0]<root.semester[0].id[0]")).

% property(("root.semester[1].modules.ects","root.semester[0].modules[0].ects[0]"),("root.semester.id<id","root.semester[0].id[0]<root.semester[1].id[0]")).
% property(("root.semester[1].modules.ects","root.semester[1].modules[0].ects[0]"),("root.semester.id<id","root.semester[1].id[0]<root.semester[1].id[0]")).
% property(("root.semester[1].modules.ects","root.semester[2].modules[0].ects[0]"),("root.semester.id<id","root.semester[2].id[0]<root.semester[1].id[0]")).

% property(("root.semester[2].modules.ects","root.semester[0].modules[0].ects[0]"),("root.semester.id<id","root.semester[0].id[0]<root.semester[2].id[0]")).
% property(("root.semester[2].modules.ects","root.semester[1].modules[0].ects[0]"),("root.semester.id<id","root.semester[1].id[0]<root.semester[2].id[0]")).
% property(("root.semester[2].modules.ects","root.semester[2].modules[0].ects[0]"),("root.semester.id<id","root.semester[2].id[0]<root.semester[2].id[0]")).


% auxiliary coom_path/3 and path_to/3 for aggregate comprehensions
coom_path(@join_comprehension(S,P),I-1,N) :-
    coom_aggregate_set(C,A,S),
    coom_aggregate_comprehension(C,A,P,V),
    coom_path(P,0,V),
    coom_path(P,I,N),
    I > 0,
    coom_path(S,0,S0),
    S0 != "root".

% coom_path(@join_comprehension(S,P),I-1,N) :-
%     coom_aggregate_set(C,A,S),
%     coom_aggregate_comprehension(C,A,P,V),
%     coom_path(P,0,V),
%     coom_path(P,I,N),
%     I > 0,
%     coom_path(S,0,S0),
%     S0 != "root".
% coom_path(@join_comprehension(S,L),I-1,N) :-
%     coom_aggregate_set(C,A,S),
%     coom_aggregate_comprehension(C,A,_,V),
%     coom_aggregate_condition(C,A,F),
%     coom_binary(F,L,_,_),
%     coom_path(L,0,V),
%     coom_path(L,I,N),
%     I > 0.

path_to(X,@join_comprehension(S,P),1,X') :-
    coom_aggregate_set(C,A,S),
    coom_aggregate_comprehension(C,A,P,V),
    type_aux(X,C),
    path_to(X,S,I,X'),
    not path_to(X,S,I+1,_),
    coom_path(P,0,V).

% path_to(X,@join_comprehension(S,L),1,X') :-
%     coom_aggregate_set(C,A,S),
%     coom_aggregate_comprehension(C,A,_,V),
%     coom_aggregate_condition(C,A,F),
%     type_aux(X,C),
%     coom_binary(F,L,_,_),
%     path_to(X,S,I,X'),
%     not path_to(X,S,I+1,_),
    % coom_path(L,0,V).

% auxiliary binary for aggregate conditions
% TODO: only binary?
binary(X,F,@binary(XL,Op,XR),XL,Op,XR) :-
    aggregate_condition(X,A,F,(L,Op,R)),
    coom_binary(F,_,Op,R),
    path_to(X,L,XL),
    path_to(X,R,XR).

% unary(X,F,@unary(X',Op),Op,X') :-
%     aggregate_condition(X,A,F),
%     coom_unary(F,Op,F'),
%     path_to(X,F',X').

% Auxiliary paths
path_to(X,F,@aggregate(T,X,P,Val,Var)) :-
    aggregate(X,F,T,P),
    coom_aggregate_comprehension(_,F,Val,Var),
    not coom_aggregate_condition(_,F,_).

path_to(X,F,@aggregate(T,X,P,Val,Var,C)) :-
    aggregate(X,F,T,P),
    coom_aggregate_comprehension(_,F,Val,Var),
    coom_aggregate_condition(_,F,C).
