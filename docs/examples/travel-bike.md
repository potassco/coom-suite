---
title: "Travel Bike"
icon: "material/bike-fast"
---

# Travel Bike

The Travel Bike is a product configuration problem
written in the [COOM\[X\]][xoom] language fragment.
In addition to the City Bike,
it contains numeric features and constraints
involving arithmetics and aggregate functions.

!!! info "flingo"
    Problems involving large numeric ranges may time out
    when using the clingo encoding due to large groundings.
    Here, hybrid solver flingo, which handles integers natively,
    can be used by specifying the `--solver flingo` option.

!!! info "Acknowledgements"
    The Travel Bike example has been provided by [denkbares].

[xoom]: ../reference/coom/index.md#coomx
[denkbares]: https://denkbares.com

## Usage

```console
coomsuite solve examples/coom/bike/travel-bike.coom --solver flingo
```
## COOM model

<!-- ??? quote "COOM Model" -->
<!-- title="Travel Bike" linenums="1" -->
```cpp
--8<-- "examples/coom/bike/travel-bike.coom:5:"
```

## Example solution

```shell
carrier[0]
carrier[0].bag[0]
carrier[0].bag[1]
carrier[0].bag[2]
frame[0]
frame[0].bag[0]
requestedVolume[0] = 200
totalVolume[0] = 200
totalWeight[0] = 3750
maxWeight[0] = 8
color[0] = "Red"
frontWheel[0] = "W20"
frontWheel[0].size[0] = 20
frontWheel[0].weight[0] = 650
rearWheel[0] = "W22"
rearWheel[0].size[0] = 22
rearWheel[0].weight[0] = 700
carrier[0].bag[0].capacity[0] = "B50"
carrier[0].bag[0].capacity[0].volume[0] = 50
carrier[0].bag[0].capacity[0].weight[0] = 600
carrier[0].bag[0].material[0] = "Polyester"
carrier[0].bag[1].capacity[0] = "B50"
carrier[0].bag[1].capacity[0].volume[0] = 50
carrier[0].bag[1].capacity[0].weight[0] = 600
carrier[0].bag[1].material[0] = "Polyester"
carrier[0].bag[2].capacity[0] = "B50"
carrier[0].bag[2].capacity[0].volume[0] = 50
carrier[0].bag[2].capacity[0].weight[0] = 600
carrier[0].bag[2].material[0] = "Cotton"
frame[0].bag[0].capacity[0] = "B50"
frame[0].bag[0].capacity[0].volume[0] = 50
frame[0].bag[0].capacity[0].weight[0] = 600
frame[0].bag[0].material[0] = "Polyester"
```
