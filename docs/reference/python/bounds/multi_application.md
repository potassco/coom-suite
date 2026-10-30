# Multishot Application

Control structure for the [multi-shot encoding] to solve instances with unbounded cardinalities.

[multi-shot encoding]: ../../encodings/multishot/index.md

::: coomsuite.bounds.multi_application.COOMMultiSolverApp
    handler: python
    options:
        show_root_heading: true
        members:
        - __init__
        - main
        - max_bound

## Jump grounding

The [jump grounding strategies][jump-grounding] (`--grounding jump-extend` and `--grounding jump-full`)
are implemented by a subclass of the multi-shot application.
The variant for incremental functions is selected with the `function_mode` argument (`extend` or `full`).

[jump-grounding]: ../../encodings/multishot/index.md#jump-grounding

::: coomsuite.bounds.multi_jump.COOMMultiSolverAppJump
    handler: python
    options:
        show_root_heading: true
        members:
        - __init__
        - main

## Fixing externals

Both application classes accept the `fix_externals` argument (`--fix-externals`),
which permanently fixes the `active/1` (and for jump grounding also the `max_bound/1`) externals
whose value can not change anymore (see [fixing externals][fix-externals]).
This is handled by `_fix_active` (after an unsatisfiable solve call) and `_release_active`
(after a satisfiable solve call during the search for the minimal bound).

[fix-externals]: ../../encodings/multishot/index.md#fixing-externals

## Extending the input language

This section gives a general workflow for updating the multi-shot implementation for extensions of the input language.
First, the multi-shot preprocessing and encodings need to be updated (see [multi-shot encoding update workflow][multishot-update]).

[multishot-update]: ../../encodings/multishot/index.md#extending-the-input-language

In the multi-shot application there are then several functions that need to be updated to handle extensions of the multi-shot preprocessing and the general extension of the input language
`_update_incremental_data`,
`_remove_new_incremental_expressions`,
`_get_incremental_prog_part`,
`_get_prog_part`.
For [jump grounding](#jump-grounding) the subclass `COOMMultiSolverAppJump` may need to be updated as well (see below).

First, `_update_incremental_data` updates internal data structures to store information from the [multi-shot specific preprocessing][multi-preprocessing].
However, as long as any new facts produced by the preprocessing follow the current argument structure of `incremental/4` no changes to `_update_incremental_data` should be necessary.

[multi-preprocessing]: ../../encodings/multishot/preprocessing.md

Second, `_remove_new_incremental_expressions` removes certain facts from the list of processed facts in order to add them using incremental program parts.
If the language extension added new kinds of incremental expressions then an according check should be added in this function.
E.g. for `function` this function defines a condition `is_incremental_function`.

Third, `_get_incremental_prog_part` handles the conversion of a fact to its respective incremental program part.
The function determines the name of the program part based on the type of the fact (such as `function` or `binary`).
In simple cases (such as `unary` or `minimize`) a new type can just be added to one of the existing cases.
In more complex cases (such as `constraint`) a new case has to be added.
Functions are handled separately by `_get_function_prog_part`,
which decides whether the full aggregate is computed or the value of the last grounded bound is extended.

Fourth, `_get_prog_part` works similarly to `_get_incremental_prog_part` but for non-incremental program parts.
The new program part needs to be added to the list of valid program parts.
For some types of program parts (such as the parts for `type` or `constraint`) it is also necessary to add the current bound as an additional argument.
This is handled by the boolean variable `needs_bound` defined in this function.

Finally, for jump grounding `_get_incremental_parts_at` determines the incremental program parts for the range of a jump.
By default the program part for the target bound is used (via `_get_incremental_prog_part`);
new incremental program parts that need to consider all bounds in the range (such as table constraints) need to be added as a special case here.
The grouping of facts by bound (`_bound_of_fact`) is based on the object paths occurring in a fact
and should not need any changes as long as new facts refer to objects by their path (as produced by `@fmt_dotpath`).
