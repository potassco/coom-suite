# Bounds

This module solves instances with unbounded cardinalities in an incremental fashion.
A `max_bound` is used to turn all unbounded cardinalities into bounded cardinalities.
This `max_bound` is increased (and possibly also decreased) until a (minimal) bound is found.

This can be done using standard single-shot solving or multi-shot solving.
Both approaches use a common [solver class][solver].
For multi-shot solving a specific [multi-shot application class][multi-application] is used.

[solver]: solver.md
[multi-application]: multi_application.md

The `max_bound` can either be increased in a `linear` or `exponential` fashion.
In both approaches it is possible to supply an initial value.
The step size of the linear search is set with `--step` (default 1),
the base of the exponential search with `--base` (default 2.0).
For examples see [bound search][bound-search].

[bound-search]: ../../../examples/cargo-bike.md#bound-search

Once a satisfiable `max_bound` has been found, solving continues to compute what the minimal satisfiable value for `max_bound` is.

::: coomsuite.bounds
    handler: python
    options:
        show_root_heading: true
