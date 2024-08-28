# COOM language fragments
As covered by our encodings

## **COOM core**
### Configuration tree / Product hierarchy
- Root is `product` with features
    -  Every feature has cardinality 1
- Only features allowed are `enumeration`
    - which can have `attribute`

### Constraints
- `behavior`
    - `require` and `require` with single `condition` (both not nested)
        - Binary comparison operators: `=`, `!=`, `<`, `<=`, `>`, `>=`
        - Unary logical operators: `!`, `()`
        - Binary logical operators: `||`, `&&`
        - *Example*: `require ! (color = Red && size = XXL)`
    - `combinations`
        - only `allow`
        - `forbid` not yet implemented
        - table entries can be tuples
        - wildcard `-*-` supported

## COOM[P]
Everything from **COOM core** plus

### Configuration tree / Product hierarchy
- Features can have cardinalities (`0..1 Basket  basket`)
    - No open cardinalities
- Features can also be `structure`

### Constraints
- Constraints can be specified locally for a structure, eg. `behavior Bag {...}`
- This enables longer path expressions, eg. `carrier.bag.capacity.volume`

## COOM[X]
Everything from **COOM[P]** plus

### Configuration tree / Product hierarchy
- Features can be numeric, eg. `num .#/g 1-10000 totalWeight`
    - no open ranges
    - number of decimals and SI units have no effect

### Constraints
- Aggregate functions (`count`, `sum`, `min`, `max`)
- Arithmetics
    - Unary: `()`, `+`, `-`
    - Binary: `+`, `-`, `*`
        - no support yet for `/` and `^`
        - fclingo only supports linear calculations (no multiplication of two variables)



## Future work
- Open cardinalities
- Open numeric intervals
