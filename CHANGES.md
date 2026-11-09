# Changes

## unreleased changes

- updated preprocessing encoding
- updated tools for documentation and tests
- added new options for multishot mode:
  - `--grounding {stepwise,jump-extend,jump-full}`
    - `stepwise` (the default) is the old behaviour: every bound is grounded.
    - `jump-*` grounds only the bounds that are actually solved
    - `jump-extend` reuses the incremental function values from the previous
      solved bound; `jump-full` recomputes the aggregates.
  - `--fix-externals`: once a bound is UNSAT, the active externals up to it are
    fixed as facts. Once a bound is SAT, the externals above it are released.

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
