% Derive range for each numeric feature variable
range(X,Min,Max) :- feature(Ctx,Feat,"num",_,_), range(Ctx,Feat,Min,Max),
                    num(X), feature(X,Feat), parent(X,Parent), struct_type(Parent,Ctx).

% Numeric variables are always included when its parents are included
included(X) :- num(X), parent(X,Parent), included(Parent).

% Assign a value to a numeric feature
&in{Min..Max} =: X :- num(X), range(X,Min,Max), included(X).

% Evaluate functions (aggregates)
&sus{ 1,X : function_path(Path,X), included(X) } =: Function :- function_instance(Function,"count",Path).
&sus{   X : function_path(Path,X), included(X) } =: Function :- function_instance(Function,"sum",  Path).
&min{   X : function_path(Path,X), included(X) } =: Function :- function_instance(Function,"min",  Path).
&max{   X : function_path(Path,X), included(X) } =: Function :- function_instance(Function,"max",  Path).

% Arithmetics
&sus{ XL;  XR } =: Formula :- binary(Formula,XL,"+",XR).
&sus{ XL; -XR } =: Formula :- binary(Formula,XL,"-",XR).

% Only linear constraints are supported
&sus{ XL*N } =: Formula :- binary(Formula,XL,"*",XR), number(XR,N).
&sus{ XR*N } =: Formula :- binary(Formula,XL,"*",XR), number(XL,N).
% TODO: Is division possible in fclingo?
% TODO: Add more arithmetics (division and power)

% Imply statements
&sus{ Formula } =: X :- imply_instance(X,Formula), included(X).

% Show statement for numeric values
&show { X : num(X), included(X) }.
