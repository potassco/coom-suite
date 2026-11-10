%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Object bound predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% object-bounds.lp

%*! obj_inc(X,M)

States that the object `X` of a feature with unbounded cardinality only exists for `max_bound >= M`,
based on its own index.
The object may only appear at a larger bound if one of its ancestors does (see `obj_level`).

Args:
    - X: The internal object identifier
    - M: The smallest bound at which the object can exist
*%

%*! user_obj(X)

States that the object `X` is on the path of a user include containing a feature with unbounded cardinality.
Such objects are instantiated for every `max_bound` (see `user_path_unbounded`) and thus exist from bound 0 on.

Args:
    - X: The internal object identifier
*%

%*! obj_level(X,L)

States that the object `X` exists from bound `L` on.
The level of an object is the maximum of the `obj_inc` bounds of all objects on its path to the root.

Args:
    - X: The internal object identifier
    - L: The bound from which on the object exists
*%

%*! obj_bound(X,B)

Output version of `obj_level`: the object `X` exists from bound `B` on.
Used to group the facts of a single preprocessing step by the bound they belong to.

Args:
    - X: The dot path of the object (output format)
    - B: The bound from which on the object exists
*%
