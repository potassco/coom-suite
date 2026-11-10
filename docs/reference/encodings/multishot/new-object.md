# New object encoding

This encoding just splits up the standard COOM encoding into different program parts for each fact specifying a new object,
i.e. `parent`, `index`, `type`, and `set`.

The only important change is the addition of the `active/1` external to control whether a bound is currently considered to be active.
The inclusion of an object introduced at bound `n` is then only possible if `active(n)` holds.

As the rules of the base program are not grounded again for objects of later bounds, the program part for `type`
additionally contains the rules for user values of the object (`base/clingo/user.lp`).
Objects of a user include are instantiated at bound 0 even for unbounded features,
so their predecessors (in the order of the indices) may only be added at a later bound.
Therefore, the ordering constraint between objects of a set is also stated for the case where the new object is the predecessor.

::: src/coomsuite/encodings/multi/new-object.lp
    handler: asp
    options:
        encodings: true

## Constants and numbers

The program parts for `constant` and `number` facts add the respective fact together with its auxiliary value.
Usually these facts are already produced at bound 0, but they can also be new at later bounds,
e.g. `number("1",1)` is produced for the first local constraint of an object, which may be added at a later bound.

::: src/coomsuite/encodings/multi/new-constant.lp
    handler: asp
    options:
        encodings: true

::: src/coomsuite/encodings/multi/new-number.lp
    handler: asp
    options:
        encodings: true

## Defaults

The program part for `default` facts adds the default value of an object (unless the user set a value for it).
Defaults of objects added at later bounds are produced at the bound of the object.

::: src/coomsuite/encodings/multi/new-default.lp
    handler: asp
    options:
        encodings: true
