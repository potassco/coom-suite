# Literature

- Gebser, Obermeier, Schaub (2015): Interactive Answer Set Programming -
  Preliminary Report

  - operations for adding/removing assumptions, setting externals
  - change clingo configuration (enumeration modes, number of models,
    optimisation)
  - add rules to the program
  - generalisation of assumptions: ground boolean and non-ground queries (using
    new atoms, additional rules, and assumptions)
  - implemented as command line tool using multi-shot solving

## Facet-based Navigation

- Alrabbaa, Rudolph, Schweizer (2018): Faceted Answer-Set Navigation

  - introduction of facet-based navigation (facet = brave but not cautious
    consequence)
  - navigation is a series of facet activations (enforce truth of facet)
  - strict navigation: only facets under current facets available
  - free navigation: available facets not further restricted
  - conflict resolution for free navigation
  - implementation in [inca](https://github.com/lukeswissman/inca), tested on
    n-queens for large n (where number of solution is unknown)

- Fichte, Gaggl, Rusovac (2022): Rushing and Strolling among Answer Sets -
  Navigation Made Easy

  - introduction of weighted facets
  - weights quantify the effect (on the solution space) of activating a facet
  - example weights: answer set count, supported model count, facet count
  - navigation modes based on weight: strict but maximising/minimising weight
    in every step
  - implementation (fasb): on top of clingo
  - evaluation (random navigation steps) on PC configuration and abstract
    argumentation

- Rusovac, Hecher, Gebser, Gaggl, Fichte (2024): Navigating and Querying Answer
  Sets: How Hard Is It Really and Why

  - complexity results for faceted navigation
  - generalisation to more general propositional queries (e.g., CNF and DNF)
  - comparison of three approaches to count facets: fasb, model-guided
    (meta-encoding turning program into manifold program whose optimal models
    yields facets), core-guided (as model-guided but with core-guided
    optimization)
  - evaluation on planning, argumentation, and configuration problems

Navigation in Planning Problems

- Speck, Hecher, Gnad, Fichte, Correa (2025): Counting and Reasoning with Plans

  - taxonomy of counting and reasoning problems for classical planning with
    bounded plan length
  - practical tool to answer plan space reasoning queries, evaluation of
    practical feasability

- Gnad, Correa, Fichte, Speck, Rusovac, Gaggl, Hecher (2025): PlanPilot:
  Efficient Navigation in Plan Space

  - tool for navigating solutions of pddl problems using faceted navigation

- Gnad, Hecher, Gaggl, Rusovac, Speck, Fichte (2025): Interactive Exploration
  of Plan Spaces

  - use case of planpilot for airbus beluga logistics problem
  - interactively output plans, filter plans, restrict plans, restrict
    flexibility in plans, count plans, count flexibility in actions, estimate
    effects

Implementation

- [savan](https://github.com/drwadu/savan) and
  [fasb](https://github.com/drwadu/fasb): library and command line tool
  implementing faceted navigation (also representative models)
- [planpilot](https://github.com/abcorrea/planpilot): ui on top of fasb for
  navigating solutions of pddl problems
  ([video demo long](https://www.youtube.com/watch?v=75UngGNr5bc),
  [short version](https://www.youtube.com/watch?v=stovYamkur0))

## Diverse and Similar Models

- Eiter, Erdem, Erdogan, Fink (2013): Finding Similar/Diverse Solutions in
  Answer Set Programming

  - offline method: compute all stable models then use clustering method (in
    ASP)
  - online methods: reformulate program to compute n solutions at once, compute
    diverse/similar models iteratively, modified solver
  - solver modifications show best performance

- Haselbock, Schenner (2015): A Heuristic, Replay-based Approach for
  Reconfiguration

  - fixing a configuration for updated requirements
  - using heuristics to keep truth values of atoms according to old
    configuration

- Romero, Schaub, Wanko (2016): Computing Diverse Optimal Stable Models

  - framework for computing diverse/similar models for programs with
    preferences
  - three different approaches: enumeration, replication, approximation
  - exact methods (enumeration, replication) not feasible in most applications
  - approximation techniques: iteratively compute most diverse model with
    respect to current solutions; start from a partial interpretation and
    compute model closest to partial interpretation; or using partial
    interpretation but only heuristically close
  - purely heuristic methods show best performance at cost of solution quality

- Böhl, Gaggl (2022): Tunas - Fishing for Diverse Answer Sets: A Multi-shot
  Trade up Strategy

  - method for finding diverse set of stable models
  - multi-shot solving to collect diverse models by iteratively solving and
    updating the logic program
  - models in the solution set are traded for models improving the solution set

- Böhl, Gaggl, Rusovac (2023): Representative Answer Sets: Collecting
  Somethings of Everything

  - find a set of models that represent specified target atoms and is as
    diverse as possible
  - number of representative models is not a user specified parameter but
    dependent on the logic program and target atoms
  - i.e. in worst case every stable model is a representative model
  - implemented in savan/fasb (see above)
