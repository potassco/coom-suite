---
title: "Cargo Bike"
icon: "material/bicycle-cargo"
---

# Cargo Bike

The Cargo Bike is a product configuration problem
written in the [COOM\[X*\]][xoomstar] language fragment.
As this example contains unbounded cardinalities,
the current encoding is not able to solve this natively.
Therefore, the *COOM Suite* offers the `--incremental-bounds` option
providing a simple approach which increases the maximum bound in a stepwise
manner until reaching a solution. This approach is captured in the following diagram.

![Workflow](../assets/images/incremental-bounds.png)

!!! info "Acknowledgements"
    The Cargo Bike example has been provided by [denkbares].

[xoomstar]: ../reference/coom/index.md#unbounded-cardinalities
[denkbares]: https://denkbares.com

## Usage

```console
coomsuite solve examples/coom/bike/cargo-bike.coom --incremental-bounds -u examples/coom/bike/user-input-cargo.coom
```
## COOM model

<!-- ??? quote "COOM Model" -->
<!-- title="Cargo Bike" linenums="1" -->
```cpp
--8<-- "examples/coom/bike/cargo-bike.coom:5:31"
```

## Example solution

```shell
Solving with max_bound = 1
UNSATISFIABLE

Solving with max_bound = 2
UNSATISFIABLE

Solving with max_bound = 3
Answer: 1
bags[0]
bags[1]
bags[2]
requestedVolume[0] = 60
totalVolume[0]     = 60

bags[0].size[0] = "large"
bags[0].size[0].volume[0] = 20
bags[0].size[0].weight[0] = 25

bags[1].size[0] = "large"
bags[1].size[0].volume[0] = 20
bags[1].size[0].weight[0] = 25

bags[2].size[0] = "large"
bags[2].size[0].volume[0] = 20
bags[2].size[0].weight[0] = 25

SATISFIABLE

```
