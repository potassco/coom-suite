[![Documentation](https://img.shields.io/badge/docs-potassco.org-blue)](https://docs.potassco.org/coom-suite/)
[![PyPI version](https://img.shields.io/pypi/v/coomsuite)](https://pypi.org/project/coomsuite/)
[![License](https://img.shields.io/github/license/potassco/coom-suite)](LICENSE)

# COOM Suite

The [COOM language](https://www.coom-lang.org/) is a domain-specific language
for modelling product configuration problems. While currently geared towards
ASP, the *COOM Suite* is intended to serve as a **general workbench** for
experimentation with **industrial-scale product configuration problems**. It
includes a (customizable) [ANTLR v4](https://www.antlr.org/) parser to convert
COOM specifications into facts, and currently contains two ASP encodings for
solving: one for [clingo](https://potassco.org/clingo) and one for hybrid
solver [flingo](https://github.com/potassco/flingo).

In addition, a prototypical UI, a range of examples and a benchmark collection
with four scalable benchmark sets is provided.

If you want to cite the COOM Suite, please use the following reference

> J. Baumeister, S. Hahn, K. Herud, M. Ostrowski, J. Reutelshöfer, N. Rühling,
> T. Schaub, P. Wanko. Towards Industrial-scale Product Configuration. _CoRR_,
> abs/2504.00013, 2025. doi: 10.48550/arXiv.2504.00013. URL
> https://arxiv.org/abs/2504.00013.

## Documentation

Full documentation is available at
**[docs.potassco.org/coom-suite](https://docs.potassco.org/coom-suite/)**.
