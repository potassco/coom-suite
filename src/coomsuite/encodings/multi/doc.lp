%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Multi-shot predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Externals

%*! active(N)

External stating that the bound `N` is active.
Objects introduced at bound `N` can only be included if `active(N)` holds,
and the simple constraints and table rows introduced at bound `N` are only checked if `active(N)` holds.
Bound 0 is part of the base program and therefore always active.

Args:
    - N: The bound
*%

%*! max_bound(B)

External selecting the bound `B` at which incremental expressions are evaluated.
Only the copy of an incremental expression for bound `B` is enforced
(incremental boolean constraints and optimization statements).
At most one `max_bound` external is true at any time.

Args:
    - B: The bound
*%

%%% Bounds of objects and table rows

%*! bound(X,B)

States that the object `X` was introduced at bound `B`.
Used to extend the value of an incremental function by the objects added since a previous bound.

Args:
    - X: The object
    - B: The bound at which the object was introduced
*%

%*! table_bound(C,ID,B)

States that the row `ID` of the table constraint instance `C` was introduced at bound `B`.
Used to check the rows of an incremental table constraint under the `active` external of their bound.

Args:
    - C: The table constraint instance
    - ID: The identifier of the row (the second argument of `column`)
    - B: The bound at which the row was introduced
*%

%%% Bound-indexed predicates of incremental expressions

%*! value(X,V,B)

The value of the incremental expression `X` evaluated at bound `B`.
Bound-indexed version of `value` (arity 2).

Args:
    - X: The incremental expression
    - V: The value of the expression
    - B: The bound
*%

%*! defined(X,B)

States that the incremental expression `X` is defined at bound `B`.
Bound-indexed version of `defined` (arity 1).

Args:
    - X: The incremental expression
    - B: The bound
*%

%*! satisfied(X,B)

States that the incremental (boolean) expression `X` is satisfied at bound `B`.
Bound-indexed version of `satisfied` (arity 1).

Args:
    - X: The incremental expression
    - B: The bound
*%

%*! violated(C,B)

States that the incremental constraint `C` is violated at bound `B`.
For incremental table constraints, `C` is a pair of the table constraint instance and the identifier of a row,
and `B` is the bound at which the row was introduced.
Bound-indexed version of `violated` (arity 1).

Args:
    - C: The incremental constraint
    - B: The bound
*%
