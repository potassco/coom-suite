%%% Determine context of a formula

formula_node(F) :- coom_binary(F,_,_,_).
formula_node(F) :- coom_unary(F,_,_).

% Formulas at the top level of a behavior
% (these can be any term: a binary, unary, function, path, number or constant)
top_formula(C,F) :- coom_require(C,F).
top_formula(C,F) :- coom_condition(C,_,F).
top_formula(C,F) :- coom_imply(C,_,F).
top_formula(C,F) :- coom_default(C,_,F).

% Base case: terms at the top level
term_context(F,Ctx)  :- top_formula(C,F), coom_context(C,Ctx).
% Extend recursively to the subterms of a formula
term_context(L,Ctx)  :- coom_binary(F,L,_,_), term_context(F,Ctx).
term_context(R,Ctx)  :- coom_binary(F,_,_,R), term_context(F,Ctx).
term_context(F',Ctx) :- coom_unary(F,_,F'),   term_context(F,Ctx).

formula_context(F,Ctx) :- formula_node(F), term_context(F,Ctx).


%%% Instantiate formulas (binaries, unaries and functions)

% Instantiate binaries

binary_ctx(X,F,L,Op,R) :- coom_binary(F,L,Op,R), formula_context(F,C), type_aux(X,C).
binary_lhs(X,F,XL)     :- binary_ctx(X,F,L,_,_), path_to(X,L,XL).
binary_rhs(X,F,XR)     :- binary_ctx(X,F,_,_,R), path_to(X,R,XR).

binary(X,F,@fmt_binary(XL,Op,XR),XL,Op,XR) :-
    binary_ctx(X,F,_,Op,_),
    binary_lhs(X,F,XL),
    binary_rhs(X,F,XR).

% Instantiate unaries

unary_ctx(X,F,Op,F') :- coom_unary(F,Op,F'), formula_context(F,C), type_aux(X,C).

unary(X,F,@fmt_unary(X',Op),Op,X') :-
    unary_ctx(X,F,Op,F'),
    path_to(X,F',X').

% Instantiate functions

function(X,F,T,P) :- coom_function(C,F,T,P), type_aux(X,C).

%%% Instantiate "ground" formulas

ground_formula(X,F,G) :- binary(X,F,G,_,_,_).
ground_formula(X,F,G) :- unary(X,F,G,_,_).

% Instantiate ground formulas using default arithmetic
% I.e. if one side of an arithmetic expression is undefined it is ignored
% TODO: Does this always give desired behavior?
ground_formula(X,F,XL) :- binary_ctx(X,F,_,"+",_), binary_lhs(X,F,XL), not binary_rhs(X,F,_).

ground_formula(X,F,XR) :- binary_ctx(X,F,_,"+",_), not binary_lhs(X,F,_), binary_rhs(X,F,XR).
% TODO: Extend to -,*,/,...
