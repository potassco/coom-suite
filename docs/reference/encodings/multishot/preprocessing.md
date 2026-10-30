# Multi-shot specific preprocessing

::: src/coomsuite/encodings/preprocess/incremental.lp
    handler: asp
    options:
        encodings:
            git_link: true
            source: true
        predicate_table: true
        glossary:
            include_references: false
        start_level: 1

## Object bounds

For [jump grounding][jump-grounding] the preprocessing (`preprocess-multishot-jump.lp`) additionally computes the bound
at which every object exists (`obj_bound/2`).
This is used to group the facts of a single preprocessing step by the bound they belong to.
The facts over `obj_bound/2` themselves are not added to any program part.
In Python this encoding is enabled with `preprocess(..., object_bounds=True)`.

[jump-grounding]: index.md#jump-grounding

::: src/coomsuite/encodings/preprocess/object-bounds.lp
    handler: asp
    options:
        encodings: true
