%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Multi-shot predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% incremental.lp

%*! inc_obj(X)

Declares an incremental object, i.e. an instantiated object of a feature with unbounded cardinality.
For a feature with cardinality `0..*` and `max_bound=0` a dummy object with index `-1` is declared,
in order to still detect expressions over such features.

Args:
    - X: The dot path of the object (output format)
*%

%*! help_aux(X,T)

Helper version of `type_aux` for the subtree starting from a dummy incremental object (index `-1`).
Only instantiated for features with cardinality `0..*` and `max_bound=0`.

Args:
    - X: The helper object represented as a nested tuple
    - T: The type of the helper object
*%

%*! help_child(X,N,X')

Helper version of `child` matching a parent and child object for `help_aux`.

Args:
    - X: The internal object identifier of the parent
    - N: The name of the feature
    - X': The internal object identifier of the child (helper object)
*%

%*! help_path_to(X,P,X')

Helper version of `path_to` that additionally resolves paths through helper objects.
Projection of `path_to` (arity 4) without the step index, extended by paths over `help_aux`.

Args:
    - X: The starting internal object identifier
    - P: The path identifier
    - X': The object reached at some step of the path (internal format)
*%

%*! path_step(S,X)

States that the object `X` is reached at some step of the path defining the set `S`.
Only sets starting from regular (non-helper) objects are considered.

Args:
    - S: The set identifier (output format)
    - X: The dot path of the object (output format)
*%

%*! table_column(C,S)

States that the set `S` is used in a column of the table constraint instance `C`.

Args:
    - C: The table constraint instance (a pair of the table constraint identifier and the dot path of the object)
    - S: The set identifier (output format)
*%

%*! possible_inc_set(S)

States that the path defining the set `S` contains an incremental object.

Args:
    - S: The set identifier (output format)
*%

%*! inc_set(S)

Declares an incremental set, i.e. a set whose members change with increasing `max_bound`.
Limited to sets used in functions or in a column of a table constraint.

Args:
    - S: The set identifier (output format)
*%

%*! incremental(T,N,Args)

Declares an incremental expression.
Functions over incremental sets and table constraints with an incremental column are incremental (base case).
Binaries, unaries, boolean constraints and optimization statements are incremental
if one of their subexpressions is incremental.

Args:
    - T: The type of the expression (`"function"`, `"binary"`, `"unary"`, `"constraint"`, `"minimize"` or `"maximize"`)
    - N: The name of the expression
    - Args: The arguments of the corresponding output fact of type `T`
*%
