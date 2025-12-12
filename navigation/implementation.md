# Implementation ideas for navigation library

- general idea is a navigator class implementing the discussed navigation
  operations
- we may want to initialize this class with an existing control object
  (applications such as coom suite can then just add naviagtion by passing on
  the control object once a model was found)
- maybe take inspiration from clinguin backends? (ui-independent functionality)

## API

- initialize: optionally with existing control object
- load: load further files into the control object
- enable/disable optimization
- compute n models
- browse models: iteratively compute models
- compute brave/cautious/facets
- similar/diverse: same operations as for normals models (n or iteratively,
  iteratively may not work with every strategy from the literature)
- add assumption
- remove assumption
- clear assumptions
- get assumptions
- set external
- clear externals
- get externals
- add rule
- add constraint (can avoid checks needed for adding rules)
