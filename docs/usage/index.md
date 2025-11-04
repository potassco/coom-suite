---
icon: "material/rocket-launch"
---

# Usage

## Solve a COOM model

To solve a COOM model file, run (replacing <coom-model\>)
```console
coomsuite solve <coom-model>
```

To add a user input append (replacing <user-input\>) `-u <user-input>`.

### Solve a COOM model with unbounded cardinalities

To solve a COOM model file which contains unbounded cardinalities, add the following option to the above command
```console
--bounds <ALGORITHM>
```
where <ALGORITHM\> is either `linear` or `exponential`.

For more information see the [cargo bike example][cargo-bike].

[cargo-bike]: ../examples/cargo-bike.md

## Convert COOM to ASP

To convert a COOM model to the serialized ASP fact format, run
```console
coomsuite convert <coom-model>
```

To obtain the (COOM-independent) refined fact format, run
```console
coomsuite solve <coom-model> --show-facts
```

## Command-line interface

Additional options can be found with

```console
coomsuite -h
```
