# Installation

coomsuite requires Python 3.8+. We recommend version 3.10.

You can check a successful installation by running

```console
$ coomsuite -h
```

## Installing with pip


The python coomsuite package can be found [here](https://github.com/krr-up/coom-suite.git/).

```console
$ pip install coomsuite
```

## Development

### Installing from source

The project is hosted on [github](https://github.com/krr-up/coom-suite.git/) and can
also be installed from source.

```{warning}
We recommend this only for development purposes.
```

```{note}
The `setuptools` package is required to run the commands below.
```

Execute the following command in the top level coomsuite directory:

```console
$ git clone https://github.com/krr-up/coom-suite.git/
$ cd coomsuite
$ pip install -e .[all]
```
