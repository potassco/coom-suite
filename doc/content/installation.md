# Installation

coomsolver requires Python 3.8+. We recommend version 3.10.

You can check a successful installation by running

```console
$ coomsolver -h
```

## Installing with pip


The python coomsolver package can be found [here](https://github.com/krr-up/coom-solver.git/).

```console
$ pip install coomsolver
```

## Development

### Installing from source

The project is hosted on [github](https://github.com/krr-up/coom-solver.git/) and can
also be installed from source.

```{warning}
We recommend this only for development purposes.
```

```{note}
The `setuptools` package is required to run the commands below.
```

Execute the following command in the top level coomsolver directory:

```console
$ git clone https://github.com/krr-up/coom-solver.git/
$ cd coomsolver
$ pip install -e .[all]
```
