# Design decisions and open topics
- How to handle SI units?
    - Should there be a conversion by the parser to some base unit? Simple to implement but maybe an advanced feature which we do not want in the paper
    - Or should all numerics be specified without SI units, thus in the same unit?
    - Or allow different units and user has to build in conversion into constraint, e.g., for travel bike?
- COOM allows nesting of conditions and requires. This is not supported by parser and encoding currently.
- COOM allows pointing to specific instances (e.g., first bag of carrier), although,
    this is not documented in the Quick Guide I found.
    Currently, the parser does not support this feature.
- Use of wildcards in tables is not supported
- forbid statement in tables is not supported
- Encoding assumes that there is one possible attribute at the end of a path / paths point only to one value
- Assumes that enumeration features have cardinality 1
- Assumes that constant and numbers appear only on the right hand side of a binary relation
- Paths starting with `root.foo` are not supported
- How should arithmetics with undefined terms be handled?
- The `imply` statement can only assign values to local attributes

## fclingo
- Currently no division. Is this supported in fclingo?
- fclingo only supports linear constraints, so multiplication is only allowed
  if one of the terms is a  constant number
- Only if attributes are marked as numeric, fclingo will use treat them as such.
  Outside of tables it is not possible to compare non-numeric with numeric attributes.
- How should arithmetics with undefined terms be handled?
