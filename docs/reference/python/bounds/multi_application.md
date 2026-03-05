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

First, `_update_incremental_data` updates internal data structures to store information from the [multi-shot specific preprocessing](multi-preprocessing).
However, as long as any new facts produced by the preprocessing follow the current argument structure of `incremental/4` no changes to `_update_incremental_data` should be necessary.

[multi-preprocessing]: ../../encodings/multishot/preprocessing.md

Second, `_remove_new_incremental_expressions`

Third, `_get_incremental_prog_part`

Fourth, `_get_prog_part`
