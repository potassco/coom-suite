%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Input predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Parts and attributes

%*! part(T)

Declares the type of a part

Args:
    - T: The type of the part
*%

%*! discrete(T)

Declares the part of a discrete attribute

Args:
    - T: The type of the attribute
*%

%*! domain(T,V)

Declares a domain element of a discrete attribute

Args:
    - T: The type of the attribute
    - V: The domain element
*%

%*! integer(T)

Declares the part of an integer attribute

Args:
    - T: The type of the attribute
*%

%*! range(T,Min,Max)

Declares the range of an integer attribute

Args:
    - T: The type of the attribute
    - Min: The minimum value of the range
    - Max: The maximum value of the range
*%

%%% Configuration variables

%*! type(X,T)

The type of a variable

Args:
    - X: The variable (either a part or an attribute)
    - T: The type of the variable
*%

%*! parent(X,P)

The parent of a variable

Args:
    - X: The variable (either a part or an attribute)
    - P: The parent of the variable
*%

%*! index(X,I)

The index of a variable in a cardinality set,
for example, "root.frame[1]" has index 1

Args:
    - X: The variable (either a part or an attribute)
    - I: The index of the variable
*%

%%% Constraints

%*! constraint(C,T)

Instantiates a constraint

Args:
    - C: The constraint identifier
    - T: The type of the constraint (boolean, table, lowerbound)
*%

%*! binary(F,L,Op,R)

Defines a binary operation

Args:
    - F: The identifier of the complete formula
    - L: The identifier of the left operand
    - Op: The operator
    - R: The identifier of the right operand
*%

%*! unary(F,Op,F')

Defines a unary operation

Args:
    - F: The identifier of the complete formula
    - Op: The operator
    - F': The identifier of the operand
*%

%*! function(F,Fun,Arg)

Defines a calculation involving a function

Args:
    - F: The identifier of the complete formula
    - Fun: The function type
    - Arg: The argument of the function
*%

%*! set(S,X)

Defines the members of a set (for cardinalities and aggregate functions)

Args:
    - S: The identifier of the set
    - X: The variable (either a part or an attribute) which is a member of the set
*%

%*! constant(C)

Auxiliary predicate which defines a constant (string)

Args:
    - C: The constant as a string
*%

%*! number(C,N)

Auxiliary predicate which defines a constant number

Args:
    - C: The number as a string
    - N: The number as an integer
*%

%*! column(C,ID,Col,X)

Defines a column of a table constraint

Args:
    - C: The identifier of the constraint
    - ID: The identifier of the cross product of the table header variables
    - Col: The column number
    - X: The header variable of the column
*%

%*! allow(Idx,Pos,V)

Defines an entry of a table constraint (for allowed combinations)

Args:
    - Idx: The index of the table constraint (part of the constraint identifier)
    - Pos: The position of the entry as a tuple (Col,Row)
    - V: The value of the table entry
*%

%*! default(X,V)

Defines a default value

Args:
    - X: The variable that gets assigned a default value
    - V: The default value
*%

%%% User input

%*! user_include(X)

An include statement from user input

Args:
    - X: The variable (either a part or an attribute) to be included
*%

%*! user_value(X,V)

An attribute variable value set by user input

Args:
    - X: The attribute variable for which the value is set
    - V: The value of the attribute variable
*%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Encoding predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*! violated(C)

Whether a constraint is violated (Boolean, table or lower bound)

Args:
    - C: The constraint identifier (tuple that differs for each constraint type)
*%

%*! consistent(X)

Whether a user input variable is consistent with the configuration model

Args:
    - X: The variable (either a part or an attribute) to be included
*%

%*! consistent(X,V)

Whether a user input value is consistent with the configuration model

Args:
    - X: The attribute variable for which the value is set
    - V: The value of the attribute variable
*%

%%% Boolean constraints

%*! defined(X)

Whether a variable or (sub)formula is defined

Args:
    - X: The variable or (sub)formula
*%

%*! undefined(X)

Whether a variable or (sub)formula is undefined

Args:
    - X: The variable or (sub)formula
*%

%*! satisfied(X)

Whether a variable or (sub)formula is satisfied

Args:
    - X: The variable or (sub)formula
*%

%*! defined(C,ID)

Whether a table constraint is defined

Args:
    - C: The table constraint identifier
    - ID: The identifier of the cross product of the column header variables
*%

%*! undefined(C,ID)

Whether a table constraint is undefined

Args:
    - C: The table constraint identifier
    - ID: The identifier of the cross product of the column header variables
*%

%*! hit(C,ID,Pos)

Whether an entry of a table constraint is satisfied (only for flingo encoding)

Args:
    - C: The table constraint identifier
    - ID: The identifier of the cross product of the column header variables
    - Pos: The position of the table entry as a tuple (Col,Row)
*%

%*! not_hit(C,ID,Row)

Whether a row of a table constraint is not satisfied

Args:
    - C: The table constraint identifier
    - ID: The identifier of the cross product of the column header variables
    - Row: The row number
*%

%*! satisfied(C,ID)

Whether a table constraint is satisfied

Args:
    - C: The table constraint identifier
    - ID: The identifier of the cross product of the column header variables
*%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Output predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*! include(X)

Whether a variable is included in the configuration

Args:
    - X: The variable (either a part or an attribute)
*%

%*! value(X,V)

The value of an attribute variable

Args:
    - X: The attribute variable
    - V: The value of the variable
*%
