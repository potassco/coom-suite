% Max bound for unbounded cardinalities
#const max_bound = 10.

%*! type_aux(X,T)

Auxiliary predicate representing an instantiated object of a specific type.
Object are (internally) represented as nested tuples, e.g. `(frame, ((), 0))` for `root.frame[0]`.
The general pattern is `(object, (parent, index))`.
This internal representation is later converted using `@dotpath`.

Args:
    - X: The object represented as a nested tuple
    - T: The type of the object
*%

% Instantiate the root object
type_aux((),"product") :- coom_structure("product").

% Recursively instantiate the configuration tree
type_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,    _,  Max),  type_aux(X,Ctx), I = 0..Max-1, T != "num".
type_aux((F,(X,I)),T)            :- coom_feature(Ctx,F,T,    Min,#sup), type_aux(X,Ctx), I = 0..Min+max_bound-1, T != "num".
type_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",_,  Max),  type_aux(X,Ctx), I = 0..Max-1.
type_aux((F,(X,I)),@join(Ctx,F)) :- coom_feature(Ctx,F,"num",Min,#sup), type_aux(X,Ctx), I = 0..Min+max_bound-1.


% Create auxiliary instantiations for attribute values
type_aux((A,(X,0)),A) :- type_aux(X,T), coom_enumeration(T), coom_attribute_value(T,_,A,_).
