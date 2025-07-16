# COOM Suite

The [COOM language](https://www.coom-lang.org/) is a domain-specific language
for modelling product configuration problems. While currently geared towards
ASP, the *COOM Suite* is intended to serve as a **general workbench** for
experimentation with **industrial-scale product configuration problems**. It
includes a (customizable) [ANTLR v4](https://www.antlr.org/) parser to convert
COOM specifications into facts, and currently contains two ASP encodings for
solving: one for [clingo](https://potassco.org/clingo) and one for hybrid
solver [fclingo](https://github.com/potassco/fclingo).

In addition, a prototypical UI, a range of examples and a benchmark collection
with four scalable benchmark sets is provided.

If you want to cite the COOM Suite, please use the following reference

> J. Baumeister, S. Hahn, K. Herud, M. Ostrowski, J. Reutelshöfer, N. Rühling,
> T. Schaub, P. Wanko. Towards Industrial-scale Product Configuration. _CoRR_,
> abs/2504.00013, 2025. doi: 10.48550/arXiv.2504.00013. URL
> https://arxiv.org/abs/2504.00013.

## Usage

Look at our [documentation page](https://potassco.org/coom-suite) to see how to
use the *COOM Suite*.

### Solving

The main functionality the *COOM Suite* offers is converting a COOM
configuration model and solving it using ASP. To do this, run

```bash
coomsuite solve examples/coom/kids-bike.coom
```

This will convert the given COOM file to a set of (serialized) facts, refine
these facts, and finally solve them with the clingo encoding.

- Note that the direct conversion of COOM into facts is a mere serialization of
  the COOM model. We make use of a preprocessing encoding to translate the
  "serialized" facts into a set of "refined" facts, capturing the essence of
  the configuration problem. To show the "refined" facts, run the `solve` mode
  with option `--show-facts`.

### Convert COOM to facts

To convert a COOM instance into a set of (serialized) facts run

```bash
coomsuite convert examples/coom/kids-bike.coom
```

By default, the facts are printed to the console. Optionally, an output
directory can be provided using option `--output dir`.

## Examples

The COOM Suite contains a range of (product) configuration examples encoded in
the COOM language. They can be found in the [`examples/coom`](examples/coom)
directory. We highlight here only the *Bike* collection, containing three
examples in increasing complexity that correspond to the three COOM language
fragments defined above: the [Kids](examples/coom/bike/kids-bike.coom),
[City](examples/coom/bike/city-bike.coom), and
[Travel](examples/coom/bike/travel-bike.coom) Bike.

We also provide the corresponding (serialized and refined) facts to these
examples under [`examples/asp`](examples/asp).

## Installation

For instructions on how to install from source or `pip` see our
[documentation page](https://potassco.org/coom-suite).
