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

## Extending the input language

This section gives a general workflow for updating the multi-shot implementation for extensions of the input language.
First, the multi-shot preprocessing and encodings need to be updated (see [multi-shot encoding update workflow][multishot-update]).

[multishot-update]: ../../encodings/multishot/index.md#extending-the-input-language

In the multi-shot application there are then several functions that need to be updated to handle extensions of the multi-shot preprocessing and the general extension of the input language
`_update_incremental_data`,
`_remove_new_incremental_expressions`,
`_get_incremental_prog_part`,
`_get_prog_part`.

First, `_update_incremental_data` updates internal data structures to store information from the [multi-shot specific preprocessing][multi-preprocessing].
However, as long as any new facts produced by the preprocessing follow the current argument structure of `incremental/4` no changes to `_update_incremental_data` should be necessary.

[multi-preprocessing]: ../../encodings/multishot/preprocessing.md

Second, `_remove_new_incremental_expressions` removes certain facts from the list of processed facts in order to add them using incremental program parts.
If the language extension added new kinds of incremental expressions then an according check should be added in this function.
E.g. for `function` this function defines a condition `is_incremental_function`.

Third, `_get_incremental_prog_part` handles the conversion of a fact to its respective incremental program part.
The function determines the name of the program part based on the type of the fact (such as `function` or `binary`).
In simple cases (such as `unary` or `minimize`) a new type can just be added to one of the existing cases.
In more complex cases (such as `function`) a new case has to be added.

Fourth, `_get_prog_part` works similarly to `_get_incremental_prog_part` but for non-incremental program parts.
The new program part needs to be added to the list of valid program parts.
For some types of program parts (such as the parts for `type` or `constraint`) it is also necessary to add the current bound as an additional argument.
This is handled by the boolean variable `needs_bound` defined in this function.
