---
title: "City Bike"
icon: "material/bicycle-basket"
---


# City Bike

The City Bike is a product configuration problem
written in the [COOM\[P\]][poom] language fragment.
It contains a simple partonomy with cardinalities different than 1,
including optional parts.

<!-- !!! info "Acknowledgements"
    The City Bike example has been provided by [denkbares]. -->

[poom]: ../reference/coom/index.md#coomp
<!-- [denkbares]: https://denkbares.com -->

## Usage

```console
coomsuite solve examples/bike/coom/city-bike.coom
```
## COOM model

<!-- ??? quote "COOM Model" -->
<!-- title="City Bike" linenums="1" -->
```cpp
--8<-- "examples/coom/bike/city-bike.coom:5:"
```

## Example solution

```shell
basket[0]
carrier[0]
saddle[0] = "Comfort"
color[0] = "Blue"
frontWheel[0] = "W29"
frontWheel[0].size[0] = 29
rearWheel[0] = "W29"
rearWheel[0].size[0] = 29
basket[0].color[0] = "Blue"
basket[0].position[0] = "Back"
```
