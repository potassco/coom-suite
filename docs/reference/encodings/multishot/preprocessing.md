# Multi-shot specific preprocessing

For jump grounding the preprocessing additionally computes the [bounds of all objects][object-bounds].

[object-bounds]: object-bounds.md

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
