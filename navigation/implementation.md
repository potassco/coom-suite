# Implementation ideas for navigation library

- general idea is a navigator class implementing the discussed navigation
  operations
- we may want to initialize this class with an existing control object
  (applications such as coom suite can then just add naviagtion by passing on
  the control object once a model was found)
- maybe take inspiration from clinguin backends? (ui-independent functionality)

## Possible methods

- compute n models
- enter a browsing state (computing models stepwise)
- compute diverse/similar models (number of models analogous to normal solving
  operations)
- add assumption
- remove assumption
- get all assumptions
- set external
- get values of externals
- compute brave consequences
- compute cautious consequences
- turn on/off optimisation
- add a rule to the program
- methods for ground boolean or non-ground queries analogous to assumptions
