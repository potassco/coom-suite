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
solving: one for clingo and one for hybrid solver
[fclingo](https://github.com/potassco/fclingo).

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

#### Benchmarks

The COOM suite includes four scalable benchmark sets. More information can be
found in the [`benchmarks`](benchmarks) directory.

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
  configuration problem. To show the "refined" facts, run with option `--show`.
  This will print the facts to the console.

### Extending the workbench

#### Customizing the parser

To get started have a look at the
[COOM grammar](src/coomsuite/utils/coom_grammar/Model.g4).

You can customize the conversion by modifying the
[ASP Visitor](src/coomsuite/utils/parse_coom.py).

More information on the Python target of ANTLR v4 can be found
[here](https://github.com/antlr/antlr4/blob/master/doc/python-target.md).

#### Add encodings

The encodings are stored in
[`src/coomsuite/encodings/`](src/coomsuite/encodings/).

Loading of the encodings is handled with clingo's
[Application class](https://potassco.org/clingo/python-api/5.7/clingo/application.html).
Modify [this line](src/coomsuite/application.py#L182) to insert your own
encoding. Note that you might also have to disable/modify the preprocessing
encoding [here](<(src/coomsuite/application.py#L159)>).

## Development

To improve code quality, we use [nox] to run linters, type checkers, unit
tests, documentation and more. We recommend installing nox using [pipx] to have
it available globally.

```bash
# install
python -m pip install pipx
python -m pipx install nox

# run all sessions
nox

# list all sessions
nox -l

# run individual session
nox -s session_name

# run individual session (reuse install)
nox -Rs session_name
```

Note that the nox sessions create [editable] installs. In case there are
issues, try recreating environments by dropping the `-R` option. If your
project is incompatible with editable installs, adjust the `noxfile.py` to
disable them.

We also provide a [pre-commit][pre] config to autoformat code upon commits. It
can be set up using the following commands:

```bash
python -m pipx install pre-commit
pre-commit install
```

[editable]: https://setuptools.pypa.io/en/latest/userguide/development_mode.html
[nox]: https://nox.thea.codes/en/stable/index.html
[pipx]: https://pypa.github.io/pipx/
[pre]: https://pre-commit.com/
