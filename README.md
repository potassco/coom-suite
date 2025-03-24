# COOM Suite

Python package to parse and solve product configuration problems specified in
COOM using ASP.

## Installation

```bash
pip install .
```

## Usage

The [COOM language](https://www.coom-lang.org/) is a domain-specific language
for modelling product configuration problems. While currently geared towards
ASP, the COOM Suite is intended to serve as a general workbench for
experimentation with industrial-scale product configuration problems. It
includes a (customizable) [ANTLR v4](https://www.antlr.org/) parser to convert
COOM specifications into facts, and currently contains two ASP encodings for
solving: one for [clingo](https://potassco.org/clingo) and one for hybrid
solver [fclingo](https://github.com/potassco/fclingo).

In addition, a range of examples and a benchmark collection with four scalable
benchmark sets is provided.

### COOM language fragments

We define the following three COOM language fragments:

- **COOM Core** corresponds to a simple Constraint Satisfaction Problem (CSP).
  It mainly consists of table and Boolean constraints over discrete attributes
  and all variables are defined.
- **COOM\[P\]** adds partonomies and cardinalities on top of **COOM Core**.
- **COOM\[X\]** adds numeric variables and calculations (arithmetic expressions
  and aggregate functions) on top of **COOM\[P\]**.

### Examples and Benchmarks

#### Examples

The COOM Suite contains a range of (product) configuration examples encoded in
the COOM language. They can be found in the [`examples/coom`](examples/coom)
directory. We highlight here only the *Bike* collection, containing three
examples in increasing complexity that correspond to the three COOM language
fragments defined above: the [Kids](examples/coom/kids-bike.coom),
[City](examples/coom/city-bike.coom), and
[Travel](examples/coom/travel-bike.coom) Bike.

We also provide the corresponding (serialized and refined) facts to these
examples under [`examples/asp`](examples/asp).

### Convert COOM to facts

To convert a COOM instance into a set of (serialized) facts run

```bash
coomsuite convert examples/coom/kids-bike.coom
```

By default, the facts are printed to the console.

Optionally, an output directory can be provided using option `--output dir` in
which case the facts will be saved to the given directory.

### Solving

To solve a COOM model using ASP run

```bash
coomsuite solve examples/coom/kids-bike.coom
```

This will convert the given COOM file to a set of (serialized) facts and solve
them with the clingo encoding.

Possible options include:

- Using `--output coom`, the output facts will be converted into a (more
  readable) COOM format.

- For solving with solver fclingo, specify `--solver fclingo`.

- The usual clingo command-line arguments can be used, eg. to calculate all
  stable models and suppress printing models.

```bash
coomsuite solve examples/coom/kids-bike.coom 0 -q
```

- Note that the direct conversion of COOM into facts is a mere serialization of
  the COOM model. We make use of a preprocessing encoding to translate the
  "serialized" facts into a set of "refined" facts, capturing the essence of a
  configuration problem. To show the "refined" facts, run with option
  `--show-facts`. This will print the facts to the console.

#### User input

The coomsuite allows to add user input (or user requirements) for solving with
the `--user-input` (or `-u`) option.

```bash
coomsuite solve examples/coom/kids-bike.coom -u examples/coom/user-input-kids.coom
```

This file contains the `set color[0] = Yellow` directive and therefore returns
only solutions where the color of the bike is set to Yellow.

#### Unbounded cardinalities

For reasoning with unbounded cardinalites the `--incremental-bounds` option
provides a simple approach which increases the maximum bound in a stepwise
manner until reaching a solution.

```bash
coomsuite solve examples/coom/cargo-bike.coom -u examples/coom/user-input-cargo.coom
```

### Documentation

To generate the documentation, run

```bash
nox -s doc -- serve
```

Instructions to install and use `nox` can be found in
[DEVELOPMENT.md](./DEVELOPMENT.md)
