# Encodings for adding incremental constraints

The following encodings contain the program parts for incremental constraints and their sub-expressions.
Most of these program parts are grounded for a single bound and evaluate the expression at this bound
(using the `max_bound/1` external).

Program parts that depend on objects added at earlier bounds take a range `(prev, cur]` of bounds as arguments:

- `incremental_function_extend(f,agg,p,prev,cur)` extends the value of a function at bound `prev` by the objects added in `(prev, cur]`,
  while `incremental_function_full(f,agg,p,cur)` computes the full aggregate at bound `cur`.
- `incremental_table_constraint(cons,type,prev,cur)` checks all table rows added in `(prev, cur]`.

For stepwise grounding the range is always `(bound-1, bound]`,
for [jump grounding][jump-grounding] it covers the whole jump.

[jump-grounding]: index.md#jump-grounding

## Encodings for incremental boolean constraints
::: src/coomsuite/encodings/multi/inc-boolean-constraint.lp
    handler: asp
    options:
        encodings: true

::: src/coomsuite/encodings/multi/inc-function.lp
    handler: asp
    options:
        encodings: true

::: src/coomsuite/encodings/multi/inc-unary.lp
    handler: asp
    options:
        encodings: true

::: src/coomsuite/encodings/multi/inc-binary.lp
    handler: asp
    options:
        encodings: true

## Encodings for incremental table constraints
::: src/coomsuite/encodings/multi/inc-table-constraint.lp
    handler: asp
    options:
        encodings: true

## Encodings for incremental optimization statements

Optimization statements over incremental expressions only take the value at the current bound into account
(using the `max_bound/1` external).

::: src/coomsuite/encodings/multi/inc-optimize.lp
    handler: asp
    options:
        encodings: true
