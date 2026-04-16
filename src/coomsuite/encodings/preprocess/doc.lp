%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Input predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*! coom_structure(N)

Declares a structure.

Args:
    - N: The name of the structure
*%

%*! coom_enumeration(N)

Declares an enumeration.

Args:
    - N: The name of the enumeration
*%

%*! coom_feature(Ctx,F,T,Min,Max)

Declares a feature of a structure or enumeration type.

Args:
    - Ctx: The context of the feature, i.e. the type that contains the feature
    - F: The name of the feature
    - T: The type of the feature (a structure, enumeration, or `"num"` for numeric)
    - Min: The minimum cardinality
    - Max: The maximum cardinality (`#sup` for unbounded)
*%

%*! coom_option(T,V)

Declares an option (domain element) of an enumeration type.

Args:
    - T: The enumeration type
    - V: The value
*%

%*! coom_attribute(T,A,Kind)

Declares an attribute of an enumeration type.

Args:
    - T: The enumeration type of the attribute
    - A: The name of the attribute
    - Kind: The kind of the attribute (`"str"` for string/enumeration, `"num"` for numeric)
*%

%*! coom_attribute_value(T,O,A,V)

Declares the value of an attribute for a specific option of an enumeration type.

Args:
    - T: The enumeration type
    - O: The option of the enumeration
    - A: The name of the attribute
    - V: The value of the attribute for this option
*%

%*! coom_range(Ctx,N,Min,Max)

Declares the range of a numeric feature.

Args:
    - Ctx: The context of the feature, i.e. the type that contains the feature
    - N: The name of the numeric feature
    - Min: The minimum value of the range
    - Max: The maximum value of the range
*%

%*! coom_context(C,Ctx)

Declares the context of a constraint/behavior.

Args:
    - C: The constraint identifier
    - Ctx: The context of the constraint, i.e. the type the constraint applies to
*%

%*! coom_require(C,F)

Declares a require constraint.

Args:
    - C: The constraint identifier
    - F: The formula identifier
*%

%*! coom_condition(C,I,F)

Declares a condition of a constraint.

Args:
    - C: The constraint identifier
    - I: The index of the condition
    - F: The formula identifier of the condition
*%

%*! coom_binary(F,L,Op,R)

Declares a binary formula.

Args:
    - F: The formula identifier
    - L: The identifier of the left subformula
    - Op: The binary operator
    - R: The identifier of the right subformula
*%

%*! coom_unary(F,Op,F')

Declares a unary formula.

Args:
    - F: The formula identifier
    - Op: The unary operator
    - F': The identifier of the subformula
*%

%*! coom_path(P,I,N)

Declares the `I`th step of a path expression

Args:
    - P: The path identifier
    - I: The step index
    - N: The feature name at this step
*%

%*! coom_constant(C)

Declares a string constant

Args:
    - C: The constant
*%

%*! coom_number(C,N)

Declares a numeric literal

Args:
    - C: The string representation of the number (used in formulas)
    - N: The integer value
*%

%*! coom_combinations(C,Col,P)

Defines a column of a combinations table.

Args:
    - C: The table constraint identifier
    - Col: The column index
    - P: The path defining the column
*%

%*! coom_allow(C,XY,V)

Declares an allowed value entry of a combinations table.

Args:
    - C: The table constraint identifier
    - XY: A `(Col,Row)` tuple identifying the column and row of the entry
    - V: The allowed value at that position
*%

%*! coom_function(Ctx,F,T,P)

Declares a function expression.

Args:
    - Ctx: The context of the function, i.e. the type that contains the function
    - F: The function identifier
    - T: The function type
    - P: The path expression that the function is applied to
*%

%*! coom_imply(C,P,F)

Declares an assignment constraint.

Args:
    - C: The constraint identifier
    - P: The path that gets assigned the value
    - F: The formula whose value is assigned
*%

%*! coom_minimize(C,V,P)

Declares a minimization statement.

Args:
    - C: The constraint identifier
    - V: The optimization priority
    - P: The formula to minimize
*%

%*! coom_maximize(C,V,P)

Declares a maximization statement.

Args:
    - C: The constraint identifier
    - V: The optimization priority
    - P: The formula to minimize
*%

%*! coom_default(ID,P,V)

Declares a default value.

Args:
    - ID: The constraint identifier
    - P: The variable that gets assigned a default
    - V: The default value
*%

%*! coom_explanation(C,E)

Declares an explanation for a constraint.

Args:
    - C: The constraint identifier
    - E: The explanation string
*%

%*! coom_user_include(X)

Declares a user requirement to include a specific object.

Args:
    - X: The object to include (given by its path expression)
*%

%*! coom_user_value(X,V)

Declares a user requirement to assign a specific value to a variable.

Args:
    - X: The variable identifier (path expression)
    - V: The assigned value
*%
