%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Internal predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% instantiate-objects.lp

%*! type_aux(X,T)

Auxiliary predicate representing an instantiated object of a specific type.
Objects are (internally) represented as nested tuples, e.g. `(frame, ((), 0))` for `root.frame[0]`.
The general pattern is `(object, (parent, index))`.
This internal representation is later converted using `@fmt_dotpath`.

Args:
    - X: The object represented as a nested tuple
    - T: The type of the object
*%

%*! child(X,N,X')

Auxiliary predicate matching a parent and child object.
Equivalent to matching the nested tuple `X' = (N,(X,_))` against `type_aux` directly.

Args:
    - X: The internal object identifier of the parent
    - N: The name of the feature or attribute
    - X': The internal object identifier of the child
*%

%*! obj_path(X,P)

Associates every instantiated object with its formatted dotpath.

Args:
    - X: The internal object identifier
    - P: The dot path of the object (output format)
*%

%%% instantiate-paths.lp

%*! path_start(X,P)

Identifies objects relative to which a path expression can be evaluated.
Derived from all possible occurrences of a path: formulas, combinations table columns,
imply and optimization statements.

Args:
    - X: The internal object identifier
    - P: The path identifier
*%

%*! path_to(X,P,I,Y)

States that the path expression `P` evaluated relative to `X` resolves to `Y` at step `I`.
Helper version of `path_to` (arity 3).

Args:
    - X: The starting internal object identifier
    - P: The path identifier
    - I: The current step of the path
    - Y: The resolved target at the current step (internal format)
*%

%*! path_to(X,P,Y)

States that the path expression `P` evaluated relative to `X` resolves to `Y`.
Projection of `path_to` (arity 4) for complete paths of objects.
Special rules for paths of functions, constants, numbers and cardinalities.

Args:
    - X: The starting internal object identifier
    - P: The path identifier
    - Y: The resolved target (dotpath string, formula id, constant, or number)
*%

%%% instantiate-formulas.lp

%*! formula_node(F)

Declares a formula.

Args:
    - F: The formula identifier
*%

%*! formula_context(F,Ctx)

Defines the context type of a formula.
Derived from the top level constraint options (`coom_require`, `coom_condition`, `coom_imply`)
and propagated through the formula tree.

Args:
    - F: The formula identifier
    - Ctx: The context type (i.e. the type of object this formula is evaluated against)
*%

%*! binary(X,F,S,XL,Op,XR)

Defines a binary expression (internal representation).

Args:
    - X: The internal object identifier (object against which `F` is instantiated)
    - F: The formula identifier
    - S: The ground formula identifier (string)
    - XL: The resolved left subexpression
    - Op: The binary operation
    - XR: The resolved right subexpression
*%

%*! unary(X,F,S,Op,X')

Defines a unary expression (internal representation).

Args:
    - X: The internal object identifier (object against which `F` is instantiated)
    - F: The formula identifier
    - S: The ground formula identifier (string)
    - Op: The unary operation
    - X': The resolved subexpression
*%

%*! function(X,F,T,P)

Defines a function expression (internal representation).

Args:
    - X: The internal object identifier (object against which `F` is instantiated)
    - F: The formula identifier
    - T: The function type
    - P: The path representing the argument of the function
*%

%*! ground_formula(X,F,G)

States that formula `F` instantiated for object `X` produces ground formula `G`.
The ground formula is represented by a string produced by the respective output function.
Projections of `binary` (arity 6) and `unary` (arity 5).

Args:
    - X: The internal object identifier
    - F: The source formula identifier
    - G: The ground formula identifier (string)
*%

%%% instantiate-tables.lp

%*! table(C,X)

States that combination table constraint `C` applies to object `X`.

Args:
    - C: The table constraint identifier
    - X: The internal object identifier
*%

%*! combinations_tuple(C,Col,Tuple)

Builds a nested tuple of the ground column variables of a table,
constructed starting from the last column.
Helper version of `combinations_tuple` of arity 2.

Args:
    - C: The table constraint identifier
    - Col: The current column index
    - Tuple: The nested tuple of ground column variables from the current to the last column
*%

%*! combinations_tuple(C,CT)

Projection of `combinations_tuple` of arity 3.

Args:
    - C: The table constraint identifier
    - CT: The complete tuple of ground variables for each column
*%

%*! combinations_column(C,CT,Col,X)

States that `X` is the ground variable of column `Col` in the tuple `CT` of table instance `C`.

Args:
    - C: The table instance (a pair of the table constraint identifier and the internal object identifier)
    - CT: The complete tuple of ground variables for each column
    - Col: The column index
    - X: The ground variable at column `Col` of `CT`
*%

%%% instantiate-constraints.lp

%*! conditions_aux(C,X,I,T)

Represents a conjunction of conditions for a constraint `C` instantiated relative to object `X`.
The index of the current condition is given by `I`.

Args:
    - C: The constraint identifier
    - X: The internal object identifier
    - I: The current condition index
    - T: The tuple of conditions (ground formulas)
*%

%*! conditions_aux(C,X,T)

Projection of `conditions_aux` of arity 4 for complete conjunctions of conditions.

Args:
    - C: The constraint identifier
    - X: The internal object identifier
    - T: The tuple of conditions (ground formulas)
*%

%*! conditions_binary(C,X,F,L,R,T)

Combines the tuple of conditions of `conditions_aux` (arity 3) into a conjunction.

Args:
    - C: The constraint identifier
    - X: The internal object identifier
    - F: The conjunction (in output format)
    - L: The left formula of the conjunction (internal format)
    - R: The right formula of the conjunction (internal format)
    - T: The remaining tuple of conditions to add to the conjunction `F`
*%

%*! conditions(C,X,G)

Represents the conjunction of all conditions for a constraint `C` instantiated relative to object `X`.

Args:
    - C: The constraint identifier
    - X: The internal object identifier
    - G: The ground formula identifier for the combined condition
*%

%*! conditional_requirement(C,G,G')

Represents an instantiated conditional constraint.

Args:
    - C: The constraint identifier
    - G: The ground formula for the condition
    - G': The ground formula for the requirement
*%

%*! imply(C,X',G)

Represents an instantiated imply statement.

Args:
    - C: The constraint identifier
    - X': The path expression of the implied variable
    - G: The ground formula or aggregate identifier for the implied value
*%

%*! attribute_constraint(C)

Represents an auxiliary table constraint for attribute values.

Args:
    - C: The attribute constraint identifier (a tuple of type name and object path)
*%

%*! attribute_constraint_column(T,Col,A)

Represents a column of an auxiliary table constraint for attribute values.

Args:
    - T: The type of the attribute
    - Col: The column index of the value `A`
    - A: The attribute value
*%

%*! cardinality_aux(X,N,Min)

Auxiliary predicate collecting the minimum cardinality of a feature or attribute relative to its parent object.

Args:
    - X: The internal object identifier of the parent
    - N: The feature or attribute name
    - Min: The minimum cardinality (1 for attributes)
*%
