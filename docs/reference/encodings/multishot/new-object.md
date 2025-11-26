# New object encoding

This encoding just splits up the standard COOM encoding into different program parts for each fact specifying a new object,
i.e. `parent`, `index`, `type`, and `set`.

The only important change is the addition of the `active/1` external to control whether a bound is currently considered to be active.
The inclusion of an object introduced at bound `n` is then only possible if `active(n)` holds.

::: src/coomsuite/encodings/multi/new-object.lp
    handler: asp
    options:
        encodings: true
