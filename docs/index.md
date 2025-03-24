---
hide:
- navigation
- toc
---

# COOM Suite

The [COOM language][coom] is a domain-specific language
for modelling product configuration problems. While currently geared towards
ASP, the COOM Suite is intended to serve as a general workbench for
experimentation with industrial-scale product configuration problems. It
includes a (customizable) [ANTLR v4][antlr] parser to convert
COOM specifications into facts, and currently contains two [ASP encodings][encodings] for
solving: one for [clingo] and one for
hybrid solver [fclingo].

In addition, a range of examples and a benchmark collection with four scalable
benchmark sets is provided.

!!! info
    The *COOM suite* is part of the [Potassco] suite.

[coom]: https://www.coom-lang.org/
[antlr]: https://www.antlr.org
[encodings]: reference/encodings/index.md
[clingo]: https://potassco.org/clingo
[fclingo]: https://github.com/potassco/fclingo
[Potassco]: https://potassco.org
