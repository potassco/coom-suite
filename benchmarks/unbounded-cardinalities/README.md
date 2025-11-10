# Unbounded Cardinalities Benchmarks

The COOM Suite contains the following sets of benchmarks for the **COOM[X\*]**
language.

In all benchmark sets the minimal satisfiable bound for the unbounded
cardinalities is scaled through the addition of user input.

Furthermore, some of the benchmark sets can also be scaled via certain domain
sizes, resulting in larger configuration spaces.

## Cargo Bike

- Two variations of the cargo bike with increasing complexity
- The domain size of volume attributes can be scaled
- User inputs on the requested volume scale the minimal satisfiable bound

## Racks

- Two variations of the racks problem with increasing complexity
- User inputs on the required number of elements scale the minimal satisfiable
  bound

## House

- A benchmark set based on the house configuration problem
- The domain sizes of the number of rooms, and number of things can be scaled
- Additionally the number of persons scales the instance
- User inputs on the number of things per person scale the minimal satisfiable
  bound
