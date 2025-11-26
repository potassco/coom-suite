---
title: "Translation"
icon: material/head-dots-horizontal
---

# Translation

In this section we describe the two-step translation from COOM to ASP.
This translation consists of a first conversion from COOM to a serialized fact format
which closely resembles the COOM language.
Subsequently, this gets processed into a refined fact format used for solving.

We use a simplified version of the [Travel Bike][travelbike] example for demonstration.

[travelbike]: ../../examples/travel-bike.md

For more information on the two fact formats
head to the [Encodings][encodings] section.

[encodings]: ../encodings/index.md

=== "COOM model"

    ```cpp title="model.coom"
    --8<-- "examples/coom/bike/travel-bike-simplified.coom:5:"
    ```

=== "Serialization"

    The first step of the translation to ASP closely resembles the COOM language.

    ```prolog title="model-serialized.lp"
    --8<-- "examples/asp/travel-bike-simplified-coom.lp"
    ```

=== "Refined facts"

    The refined facts capture the original configuration problem but are independent of COOM.
    The resulting structure is that of a tree where every variable of the model is explicitly mentioned
    and the root represents the object to be configured.
    Variables can be either parts or attributes.
    Moreover, not all variables are necessarily included in the solution and an excluded variable
    renders all variables in its subtree excluded as well.

    ![Configuration tree](../../assets/images/configuration-tree.png){width="1200"}

    The configuration tree of the simplified travel bike is displayed in the figure above.
    Nodes belonging to parts are highlighted in
    yellow and those belonging to attributes in green. The third bag of the carrier and the
    second bag of the frame are highlighted in a lighter color, meaning that these variables
    are undefined and not included in the solution. This automatically renders their subnodes
    undefined as well. Note that for the sake of readability variable names are abbreviated.
    Cardinalities of features are treated by grouping variables belonging to the same feature
    and with the same parent variable in sets (represented by dashed circles in the diagram).

    ```prolog title="model-refined.lp"
    --8<-- "examples/asp/travel-bike-simplified.lp"
    ```
