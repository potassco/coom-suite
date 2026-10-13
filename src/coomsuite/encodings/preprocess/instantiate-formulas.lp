%%% Determine context of a formula

%*! formula_node(F)

Declares a formula.

Args:
    - F: The formula identifier
*%

formula_node(F) :- coom_binary(F,_,_,_).
formula_node(F) :- coom_unary(F,_,_).

%*! formula_context(F,Ctx)

Defines the context type of a formula.
Derived from the top level constraint options (`coom_require`, `coom_condition`, `coom_imply`)
and propagated through the formula tree.

Args:
    - F: The formula identifier
    - Ctx: The context type (i.e. the type of object this formula is evaluated against)
*%

% Base case: formulas at the top level
formula_context(F,Ctx) :- formula_node(F), coom_require(C,F),     coom_context(C,Ctx).
formula_context(F,Ctx) :- formula_node(F), coom_condition(C,_,F), coom_context(C,Ctx).
formula_context(F,Ctx) :- formula_node(F), coom_imply(C,_,F),     coom_context(C,Ctx).
% Extend recursively to subformula of a formula
formula_context(L,Ctx)  :- coom_binary(F,L,_,_), formula_context(F,Ctx), formula_node(L).
formula_context(R,Ctx)  :- coom_binary(F,_,_,R), formula_context(F,Ctx), formula_node(R).
formula_context(F',Ctx) :- coom_unary(F,_,F'),   formula_context(F,Ctx), formula_node(F').


%%% Instantiate formulas (binaries, unaries and functions)

% Instantiate binaries

%*! binary(X,F,S,XL,Op,XR)

Defines a binary expression (internal representation).

Args:
    - X: The internal object identifier (object against which `F` is instantiated)
    - F: The formula identifier
    - S: The ground formula identifier (string)
    - XL: The resolved left subexpression
    - Op: The binary operation
    - XR: The resolved right subexpression
*%

binary_ctx(X,F,L,Op,R) :- coom_binary(F,L,Op,R), formula_context(F,C), type_aux(X,C).
binary_lhs(X,F,XL)     :- binary_ctx(X,F,L,_,_), path_to(X,L,XL).
binary_rhs(X,F,XR)     :- binary_ctx(X,F,_,_,R), path_to(X,R,XR).

binary(X,F,@fmt_binary(XL,Op,XR),XL,Op,XR) :-
    binary_ctx(X,F,_,Op,_),
    binary_lhs(X,F,XL),
    binary_rhs(X,F,XR).

% Instantiate unaries

%*! unary(X,F,S,Op,X')

Defines a unary expression (internal representation).

Args:
    - X: The internal object identifier (object against which `F` is instantiated)
    - F: The formula identifier
    - S: The ground formula identifier (string)
    - Op: The binary operation
    - X': The resolved subexpression
*%

unary_ctx(X,F,Op,F') :- coom_unary(F,Op,F'), formula_context(F,C), type_aux(X,C).

unary(X,F,@fmt_unary(X',Op),Op,X') :-
    unary_ctx(X,F,Op,F'),
    path_to(X,F',X').

% Instantiate functions

%*! function(X,F,T,P)

Defines a function expression (internal representation).

Args:
    - X: The internal object identifier (object against which `F` is instantiated)
    - F: The formula identifier
    - T: The function type
    - P: The path representing the argument of the function
*%

function(X,F,T,P) :- coom_function(C,F,T,P), type_aux(X,C).

%%% Instantiate "ground" formulas

%*! ground_formula(X,F,G)

States that formula `F` instantiated for object `X` produces ground formula `G`.
The ground formula is represented by a string produced by the respective output function.
Projections of `binary` (arity 6) and `unary` (arity 5).

Args:
    - X: The internal object identifier
    - F: The source formula identifier
    - G: The ground formula identifier (string)
*%

ground_formula(X,F,G) :- binary(X,F,G,_,_,_).
ground_formula(X,F,G) :- unary(X,F,G,_,_).

% Instantiate ground formulas using default arithmetic
% I.e. if one side of an arithmetic expression is undefined it is ignored
% TODO: Does this always give desired behavior?
ground_formula(X,F,XL) :- binary_ctx(X,F,_,"+",_), binary_lhs(X,F,XL), not binary_rhs(X,F,_).

ground_formula(X,F,XR) :- binary_ctx(X,F,_,"+",_), not binary_lhs(X,F,_), binary_rhs(X,F,XR).
% TODO: Extend to -,*,/,...
