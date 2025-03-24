---
title: "Kids Bike"
icon: "material/bike"
---

# Kids Bike

The Kids Bike is a simple product configuration problem
written in the [COOM Core][core] language fragment.
It consists of different enumeration features and constraints over them.

!!! info "Acknowledgements"
    The Kids Bike example has been provided by [denkbares].

[core]: ../reference/coom/index.md#coom-core
[denkbares]: https://denkbares.com

## Usage

```console
coomsuite solve examples/coom/kids-bike.coom
```

!!! info
    The usual clingo command-line arguments can be used, eg. to calculate all
    stable models or suppress printing models.


## COOM model

<!-- ??? quote "COOM Model" -->
<!-- title="Kids Bike" linenums="1" -->
```cpp
--8<-- "examples/coom/kids-bike.coom:5:"
```

## Example solution

```
color[0] = "Red"
wheelSupport[0] = "True"
frontWheel[0] = "W14"
frontWheel[0].size[0] = 14
rearWheel[0] = "W14"
rearWheel[0].size[0] = 14
```

!!! tip "COOM output"
    By default the COOM suite outputs ASP atoms.
    To get the COOM output add the option
    `--output coom` (`-o`).
