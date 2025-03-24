---
icon: material/tune
---


# Customization

## Customizing the parser

Parsing and translating the COOM files is done via the Python target of ANTLR v4.
- To get started have a look at the [COOM grammar][grammar]
- You can customize the translation by modifying the [ASP Visitor][visitor]

!!! tip
    More information on the Python target of ANTLR v4 can be found [here][antlr-python].

## Add encodings

- Check out the [Encodings folder][encodings].
- Loading of the encodings is handled with clingo's [Application class][application].

!!! warning
    If using a different fact format,
    you might have to modify the preprocessing encoding
    located in the [Encodings folder][encodings] as well.

## Generate ANTLR4 Python files

These files are used by the parser.
To generate them from an ANTLR4 grammar,
navigate to the corresponding folder and run
(possibly replacing the version number and grammar file name)

```shell
antlr4 -v 4.9.3 -Dlanguage=Python3 Grammar.g4 -visitor
```

[grammar]: https://github.com/potassco/coom-suite/tree/master/src/coomsuite/utils/coom_grammar/model/Model.g4
[visitor]: https://github.com/potassco/coom-suite/tree/master/src/coomsuite/utils/parse_coom.py
[encodings]: https://github.com/potassco/coom-suite/tree/master/src/coomsuite/encodings/
[application]: ../reference/python/application.md
[antlr-python]: https://github.com/antlr/antlr4/blob/master/doc/python-target.md

## Contributing

If you want to contribute to the **COOM Suite**,
check out the following [guidelines].

[guidelines]: CONTRIBUTING.md
