---
title: "COOM Reference"
icon: "material/book-open-variant"
---

# COOM documentation

For a more complete documentation to the COOM language
we refer to the official [website][coomlang].

In the following we give an overview of the three
COOM language fragments as described in [Baumeister et al., 2025][coompaper].


These fragments have similar
counterparts in the
[COOM language profiles][profiles]
from the official documentation.
However, they might differ in some details.

> J. Baumeister, S. Hahn, K. Herud, M. Ostrowski, J. Reutelshöfer, N. Rühling, T. Schaub, P. Wanko.
> Towards Industrial-scale Product Configuration. _CoRR_, abs/2504.00013, 2025.
> doi: 10.48550/arXiv.2504.00013. URL https://arxiv.org/abs/2504.00013.

## COOM Core

This is the basic language fragment which
contains the most essential language features.

It corresponds to the CORE profile of
the [language profiles][profiles].

### Configuration tree / Product hierarchy

- The configuration has a root which is specified by the `product` keyword
  which in turn can have features with a fixed cardinality of 1.
- The only features allowed are `enumeration`[s] which can have `attribute`[s].

### Constraints

- Constraints are specified by the `behavior` keyword
- The possible constraints are:
    - `require` (not nested)
    - `require` with single `condition` (not nested)
- Formulas can be specified by using the following operators:
    - Binary comparison: `=`, `!=`, `<`, `<=`, `>`, `>=`
    - Unary logical: `!`, `()`
    - Binary logical: `||`, `&&`
    - *Example*: `require ! (color = Red && size = XXL)`
  - Further, table constraints are allowed by using the `combinations` keyword:
    - The entries of the table can be formed by using `allow` keyword
    - The `forbid` keyword is currently not permitted
    - Table entries can be single values, tuples or a wildcard `-*-`

## COOM\[P\]

**COOM\[P\]** extends **COOM core** by the following.
This extension corresponds to the C-USER profile.

### Configuration tree / Product hierarchy

- Features can have cardinalities (`0..1 Basket  basket`) but these have to be bounded
- Features can also be `structure` (which builds up a partonomy)

### Constraints

- Constraints can be specified locally for a `structure`, eg. `behavior Bag {...}`
- This enables longer path expressions, eg. `carrier.bag.capacity.volume`

## COOM\[X\]

**COOM\[X\]** extends **COOM\[P\]** by the following.
This extension corresponds to the N-LIN profile.

### Configuration tree / Product hierarchy

- Features can be numeric, eg. `num .#/g 1-10000 totalWeight`
  with their range specified or left open (only for flingo).

### Constraints

- Formulas can now be built using
  - Aggregate functions (`count`, `sum`, `min`, `max`)
  - Arithmetics
    - Unary: `()`, `+`, `-`
    - Binary: `+`, `-`, `*`
      - no support yet for `/` and `^`
      - flingo only supports linear calculations (no multiplication of two
        variables)

### Function comprehensions

Aggregate functions accept a single formula, optionally followed by a
Python-style comprehension:

```coom
sum(b.weight for b in bags if b.weight > 10)
count(b for b in bags if b.color = Red)
min(b.weight for b in bags)
max(b.weight for b in bags)
```

The syntax is `function(formula for variable in path if condition)`, where
`if condition` is optional. The variable refers to each included instance
selected by `path`. Other paths are resolved relative to the surrounding
behavior context; paths starting with `root` are absolute.
Arithmetic projections and logical filter expressions are supported subject
to the solver's existing arithmetic restrictions.

Comprehensions are evaluated by both single-shot solvers (`clingo` and
`flingo`). Multi-shot solving currently rejects comprehensions explicitly.
Comprehensions on non-aggregate functions (such as `sqrt`) are also rejected.
Plain calls such as `sum(bags.weight)` and `sqrt(weight)` retain their
existing syntax. Comma-separated function arguments are no longer part of
the grammar.

The parser rejects aggregates (`sum`, `count`, `min`, `max`, or `avg`) inside
other aggregates, including in comprehension filters or through intervening
scalar calls. For example, `sum(sqrt(count(bags)))` and
`sum(b.weight for b in bags if count(b.items) > 0)` are not supported.
Scalar function nesting is allowed: `sqrt(sqrt(weight))`,
`sqrt(sum(bags.weight))`, and `sum(sqrt(b.weight) for b in bags)` can be
parsed. Evaluation remains subject to the solver's supported scalar functions.
Separate calls such as `sum(bags.weight) + count(bags)` are also allowed.
The grammar itself remains unchanged.

The parser preserves `function(Context, Expression, Function, Formula)` facts
and adds `function_binding(Expression, Variable, Path)` and, when present,
`function_condition(Expression, Condition)`. Filter expressions are decomposed
into the same binary, unary, path, and number facts as other conditions.
Preprocessing binds the variable for each member, reuses the ordinary path
and formula instantiation rules, and emits
`aggregate_member(Proxy, Member, Projection)`,
`aggregate_filtered(Proxy)`, and `aggregate_condition(Proxy, Condition)`.
These proxies preserve member identity (including duplicate projected values)
and select aggregate contributions at solve time.

## Unbounded Cardinalities

The fragments **COOM\[P\]** and **COOM\[X\]**, respectively,
have extensions which allow for unbounded cardinalities (e.g. `0..*`).
This extension corresponds to the C-OPEN profile.

We call these fragments **COOM\[P*\]** and **COOM\[X*\]**, respectively.


[coomlang]: https://coom-lang.org
[profiles]: https://www.coom-lang.org/profile_about/
[coompaper]: https://arxiv.org/pdf/2504.00013
