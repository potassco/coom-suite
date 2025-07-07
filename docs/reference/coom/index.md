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
  with their range specified or left open (only for fclingo).

### Constraints

- Formulas can now be built using
  - Aggregate functions (`count`, `sum`, `min`, `max`)
  - Arithmetics
    - Unary: `()`, `+`, `-`
    - Binary: `+`, `-`, `*`
      - no support yet for `/` and `^`
      - fclingo only supports linear calculations (no multiplication of two
        variables)

## Unbounded Cardinalities

The fragments **COOM\[P\]** and **COOM\[X\]**, respectively,
have extensions which allow for unbounded cardinalities.
This extension corresponds to the C-OPEN profile.

We call these fragments **COOM\[P*\]** and **COOM\[X*\]**, respectively.


[coomlang]: https://coom-lang.org
[profiles]: https://www.coom-lang.org/profile_about/
[coompaper]: https://arxiv.org/pdf/2504.00013
