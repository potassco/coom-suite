%%% Instantiate combination tables

%*! table(C,X)

States that combination table constraint `C` applies to object `X`.

Args:
    - C: The table constraint identifier
    - X: The internal object identifier
*%

table(C,X) :- coom_combinations(C,_,_), coom_context(C,Ctx), type_aux(X,Ctx).

%*! combinations_tuple(C,Col,Tuple)

Builds a nested tuple of the ground column variables of a table,
constructed starting from the last column.
Helper version of `combinations_tuple/2`.

Args:
    - C: The table constraint indentifier
    - Col: The current column index
    - Tuple: The nested tuple of ground column variables from the currnet to the last column

*%

% Base case: produce tuple (X,()) where X is the ground variable of the last column of the table
combinations_tuple((C,Ctx),Col,(X,())) :- table(C,Ctx),
                                          coom_combinations(C,Col,P), not coom_combinations(C,Col+1,_),
                                          path_to(Ctx,P,X).
% Recursive extension: add the ground variable of Col to the tuple of Col+1
combinations_tuple((C,Ctx),Col,(X',X)) :- combinations_tuple((C,Ctx),Col+1,X),
                                          coom_combinations(C,Col,P), Col >= 0,
                                          path_to(Ctx,P,X').

%*! combinations_tuple(C,CT)

Projection of `combinations_tuple/3`.

Args:
    - C: The table constraint identifier
    - CT: The complete tuple of ground variables for each column

*%

combinations_tuple(C,CT) :- combinations_tuple(C,0,CT).

%*! in_tuple(CT,CT',X)

States that `X` is a member of the column cross product tuple `CT`.
Helper version of `in_tuple/2`.

Args:
    - CT: The column cross product tuple identifier
    - CT': The remaining colum cross product tuple to unpack
    - X: The path of the column variable

*%

% Base case: top level combinations tuples
in_tuple((X,CT'),CT',X) :- combinations_tuple(_,CT), CT=(X,CT').
% Recursively unpack the CT' tuple
in_tuple(CT,CT',X)      :- in_tuple(CT,(X,CT'),_).

%*! in_tuple(CT,X)

States that object `X` is a member of the column cross product tuple `CT`
of some combination table.
Projection of `in_tuple/3`.

Args:
    - CT: The column cross product tuple identifier
    - X:  The path of the column variable
*%

in_tuple(CT,X)          :- in_tuple(CT,_,X).
