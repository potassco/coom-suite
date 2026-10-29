[![Documentation](https://img.shields.io/badge/docs-potassco.org-blue)](https://docs.potassco.org/coom-suite/)
[![PyPI version](https://img.shields.io/pypi/v/coomsuite)](https://pypi.org/project/coomsuite/)
[![License](https://img.shields.io/github/license/potassco/coom-suite)](LICENSE)

# COOM Suite

The [COOM language](https://www.coom-lang.org/) is a domain-specific language
for modelling product configuration problems. While currently geared towards
ASP, the *COOM Suite* is intended to serve as a **general workbench** for
experimentation with **industrial-scale product configuration problems**. It
includes a (customizable) [ANTLR v4](https://www.antlr.org/) parser to convert
COOM specifications into facts, and currently contains ASP encodings for
[clingo](https://potassco.org/clingo) and for hybrid solver
[flingo](https://github.com/potassco/flingo), as well as a multi-shot encoding
for incremental solving of problems with unbounded cardinalities.

In addition, a prototypical UI, a range of examples and a benchmark collection
is provided.

## Documentation

For installation instructions and detailed usage, visit our
[official documentation](https://docs.potassco.org/coom-suite/).
