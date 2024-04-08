# coomsolver

## Installation

To install the project, run

```bash
pip install .
```

## Usage

Run the following for basic usage information:

```bash
coomsolver -h
```

## Clinguin

Make sure you install clinguin with 

```bash
pip install clinguin
```

Run the following command to open the UI

```bash
clinguin client-server --domain-files src/coomsolver/encodings/clingo-city.lp examples/asp/city-bike.lp --ui-files src/coomsolver/encodings/ui.lp --backend ExplanationBackend  --assumption-signature behavior,1
```

## Name ideas

- coomsuite
- coompiler
- coompressor
- coom2asp
- coomutils
- coomgo
- coolingo

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
