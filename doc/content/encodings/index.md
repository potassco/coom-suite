# ASP Encodings

There are three modular COOM language profiles with different levels of features.
They are modular in the sense that `clingo-core.lp` forms the basis for the other ones.
The `clingo-partonomy.lp` and `clingo-numeric.lp` encoding can be combined arbitrarily with the core encoding.

The `encodings/clingo-core.lp` contains all features of the kids bike.

## fclingo
The `fclingo` solver allows hybrid ASP reasoning
combined with founded conditional linear constraints.
This makes it possible to reason over (large) numeric domains
which are frequent in configuration problems.

Like the `clingo` encodings the `fclingo` encodings are built in a modular structure.

```{toctree}
instance.md
```
