# Navigation use cases

- the following are use cases for the different operations/workflows in the
  context of a bike configuration

## Identifying desired features

- start by getting a certain number of diverse models to get an overview of
  possible bikes
- alternatively (diverse) solutions may be obtained in a browsing mode
- the user identifies desirable features from the different models
- these features can then be enforced through the use of e.g. assumptions
- this process may repeat several times

## Explanations and history

- the user may run into cases where the problem becomes unsatisfiable
- or similarly all remaining solutions may contain undesirable features
- e.g. after selecting desired features for the bike the price of all remaining
  bikes may be too high
- for these cases we want to make use of explanation and history features

## Improving a configuration

- at some point the user may have as one model a bike that is almost perfect
- i.e. the user likes most features of the bike but wants to change some
  specific feature
- in this case computing similar models is helpful
- this operations should be combined with certain restrictions, such as what
  parts of the bike to keep the same and what specific features should be
  changed

## Generalisations of assumptions

### Assumptions for all instances of an object

- generalisations of assumptions would be helpful for objects with higher
  cardinalities
- for example on a travel bike we may have between 0 and 10 bags
- if the user would like to not have large bags this can be expressed using
  standard assumptions
- but using a generalised ground assumptions (in this case conjunctions of
  negations) would be more natural
- it may also be nicer for history as we then only have one operation as
  opposed to 10 operations
- non-ground generalisation would make this even more compact, i.e., we may
  just add not size(X,large), bag(X) as a non-ground query/assumption

### Restricting numeric domains

- another case for non-ground generalisations would be restricting large domain
  (e.g. numeric)
- for example the user may want to restrict the weight of the bike to be below
  10 kilos
- assuming a domain for weight of 0..20 the user would need the assumptions not
  value(weight,10), not value(weight,11), ..., not value(weight,20)
- again ground generalisation would already have the advantage of turning this
  into a single operation
- non-ground generalisation turns it into a single compact operation (not
  value(weight,X), X>=10)

## Assumptions on user defined features

- lets consider an example where we have 4 bags
- the user would like 1 small, 2 medium, and 1 large bag
- this could be enforced through assumptions (e.g. size(bag(1),small),
  size(bag(2),medium), ...)
- but this enforces which specific bag has which size
- it may be desirable to just enforce the overall distribution of sizes without
  having to specify which bags has which size
- this could be done with generalised assumptions (i.e. 1 is small and 2 is
  medium and ... or 1 is medium and ...) but enumerating all the possible
  combinations would be tedious
- here adding a new rule that defining new predicates numSmallBags/1, ... would
  be desirable
- then the requirement can be enforced through the addition of assumptions for
  each predicate
