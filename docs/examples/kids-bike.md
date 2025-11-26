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
comsuite solve examples/coom/bike/kids-bike.coom
```

## COOM model

<!-- ??? quote "COOM Model" -->
<!-- title="Kids Bike" linenums="1" -->
```cpp
--8<-- "examples/coom/bike/kids-bike.coom:5:"
```

## Example solution

```shell
color[0] = "Red"
wheelSupport[0] = "True"
frontWheel[0] = "W14"
frontWheel[0].size[0] = 14
rearWheel[0] = "W14"
rearWheel[0].size[0] = 14
```
