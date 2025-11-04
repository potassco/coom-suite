# Encodings for adding simple constraints

The following encodings contain the rules of the standard COOM encoding split up into program parts for the part of a constraint they specify,
i.e. the `constraint` itself, one of the sub-expressions of a boolean constraint (`binary`, `unary`, `function`), or parts of a table constraint (`allow`, `column`).

The `active/1` externals is used here to only check for constraint violations of bounds that are active.

::: src/coomsuite/encodings/multi/new-constraint.lp
    handler: asp
    options:
        encodings: true

## Encodings for boolean constraints
::: src/coomsuite/encodings/multi/new-function.lp
    handler: asp
    options:
        encodings: true

::: src/coomsuite/encodings/multi/new-unary.lp
    handler: asp
    options:
        encodings: true

::: src/coomsuite/encodings/multi/new-binary.lp
    handler: asp
    options:
        encodings: true

## Encodings for table constraints
::: src/coomsuite/encodings/multi/new-allow.lp
    handler: asp
    options:
        encodings: true

::: src/coomsuite/encodings/multi/new-column.lp
    handler: asp
    options:
        encodings: true
