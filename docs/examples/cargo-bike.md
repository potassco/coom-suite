---
title: "Cargo Bike"
icon: "material/bicycle-cargo"
---

# Cargo Bike

The Cargo Bike is a product configuration problem
written in the [COOM\[X*\]][xoomstar] language fragment.

!!! info "Acknowledgements"
    The Cargo Bike example has been provided by [denkbares].

[xoomstar]: ../reference/coom/index.md#coomx-1
[denkbares]: https://denkbares.com

## Usage

```console
coomsuite solve examples/coom/cargo-bike.coom --incremental-bounds
```
## COOM model

<!-- ??? quote "COOM Model" -->
<!-- title="Cargo Bike" linenums="1" -->
```cpp
--8<-- "examples/coom/cargo-bike.coom:5:31"
```
