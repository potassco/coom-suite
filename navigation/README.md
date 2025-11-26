# Navigating solution spaces

- we want to explore the solution space of a program in an interactive manner

- to do so we use two types of operations: overview and narrowing operations

- overview operations are used to get an idea of the current solution space

- narrowing operations allow us to narrow down the solution space towards
  desired solutions

- the goal is to implement a general navigation library to be used in different
  applications/projects:

  - as an extended clinguin backend
  - as a command line tool
  - usage in specific domains such as in the coom suite

## Possible operations

### Overview operations

- general solving

  - compute a specific number of solutions
  - solution browsing as in clinguin
  - brave and cautious consequences, (weighted) facets
  - enable/disable optimisation

- diverse or similar models

  - analogous operations to solving
  - custom diversity/similarity measures
  - representative models with respect to some set of target atoms

### Narrowing operations

- assumptions

  - adding and removing assumptions
  - listing current assumptions

- generalisations of assumptions

  - ground boolean queries
  - non-ground queries

- setting values of externals

- modifying the logic program

  - adding rules (or limited to constraints to avoid redefinition issues)
  - add optimisation statements
  - deactivation or softening of constraints

### Support operations

- explanation of unsat situations
- history
  - retract added assumptions/rules/other changes to solution space
  - return to an earlier solution set
  - how fine grained should history be?
  - should history include earlier computed models?
  - ability to retract changes needs modification of certain operations (e.g.
    adding rules would need the option to deactivate the rule later on)

## Material

- [use cases](use-cases.md)
- [implementation ideas](implementation.md)
- [relevant literature](literature.md)
