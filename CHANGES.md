# Changes

## Unreleased

- Support aggregate comprehensions with optional filters in the COOM parser,
  preprocessing, and both single-shot solvers.
- Adapt function parsing to the grammar's single formula argument;
  comma-separated arguments are no longer supported.
- Reject nested aggregate calls (but allow scalar nesting) in the parser and
  simplify comprehension preprocessing to reuse ordinary path and formula
  instantiation.

## v1.1.2

- fixed a bug with repeating bounds

## v1.1.1

- `--step` option only for linear search
- added `--base` option to parametrize exponential search

## v1.1.0

- added support for parsing and solving simple defaults
- added `--step` option to parametrize linear step size/exponential base for
  search algorithm of minimal upper bounds
- fixed a bug with user include for unbounded cardinalities
- fixed a bug with optimization in incremental bound solving
- minor fixes

## v1.0.0

- initial Release
