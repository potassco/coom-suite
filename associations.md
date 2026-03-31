# Associations

- Given a "configuration tree" representing a partonomy, associations (or
  connections) are edges between two nodes
- There are no restrictions on these connections
- Associations can also be understood as references to other objects which do
  not instantiate new objects (while a partonomy create new sub-objects)
- In COOM currently modeled using the `reference` keyword. Then just as any
  other feature: cardinality, target type, and name.
- Associations occur in the following examples: Racks, House, Window Blinds, PC

## Possible representations and encodings

### Bidirectional

A possible implementation would be to encode associations as unilateral objects
but with the possiblity to "match" two opposite associations to form a
bidirectional connection.

```
association("element[0]","Modules","modules",1,4).
association("modules[0]","Element","elements",0,1).

association_match("element[0]",modules,elements).
association_match("module[0]",elements,modules).

:- association(X,T,N,_,_), association_match(X,N,N'), associate((X,X'),N,_), not associate((X',X),N',_).
```

Possible outputs

```
associate(("element[0]","modules[0]"),"modules",0).
associate(("modules[0]","elements[0]"),"elements",0).

associate(("element[0]","elements"),("modules[0]","modules")).
```

## User input

Should user input always require the correct association name?

Possible representations

```
associate elements[0].modules -> modules[0]
associate elements[0] modules[0] (modules)

elements[0].modules -> modules[0]
```

## Open questions

- Should associations be understood as something uni- or bidirectional? In
  practice associations are often bidirectional (wired connection between an
  element an a module or relation between window blind and engine), although,
  not always both directions are used in the model, i.e., in the racks example
  constraints are only expressed using the direction Element->Module.

  In the window blinds example, constraints are expressed in both ways.

  In the house example bidirectional associations seem to be needed to express
  constraints regarding ownership of things and rooms.

- How to represent associations in our formalization? What is an elegant,
  simple way? As (directed) edges? How to use them in constraints, e.g.,
  replace variables? Are names of associations important? The idea of our
  atomic formalization was to get rid of (partonomic) names, however, now there
  can be ambiguities?

- If we represent associations as unidirectional, how to model
  bidirectionalities? Using constraints like `require modules.elements = this`?
  Or `require things.storedInRoom.owner._name = _parent._name` with auxiliary
  paths?
