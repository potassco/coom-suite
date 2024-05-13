% Derive range for each numeric feature variable
range(X,Min,Max) :- feature(Context,Feature,"num",_,_), range(Context,Feature,Min,Max),
                    num(X), feature(X,Feature), parent(X,Parent), struct_type(Parent,Context).

% Generate numeric values
{ val(X,V) : V = Min..Max } :- num(X), range(X,Min,Max), not imply_instance(X,_).

% Numeric variables are always included when its parents are included
included(X) :- num(X), parent(X,Parent), included(Parent).

% Do not generate value if variable is not included
:- num(X), val(X,_), not included(X).

% If variable is included generate exactly one value
:- num(X), included(X), not { val(X,_) } = 1.

% Check ranges
:- num(X), val(X,V), range(X,Min,Max), not Min <= V <= Max.

% Evaluate functions (aggregates)
val(Function,V) :- function_instance(Function,"count",Path), V = #count{ X : function_path(Path,X), included(X) }.
val(Function,V) :- function_instance(Function,"sum",Path),   V = #sum  { V': function_path(Path,X), val(X,V')   }.
val(Function,V) :- function_instance(Function,"min",Path),   V = #min  { V': function_path(Path,X), val(X,V')   }.
val(Function,V) :- function_instance(Function,"max",Path),   V = #max  { V': function_path(Path,X), val(X,V')   }.


% Arithmetics
val(Formula,VL+VR) :- binary(Formula,XL,"+",XR), val(XL,VL), val(XR,VR).
val(Formula,VL-VR) :- binary(Formula,XL,"-",XR), val(XL,VL), val(XR,VR).
val(Formula,VL*VR) :- binary(Formula,XL,"*",XR), val(XL,VL), val(XR,VR).
% TODO: Add more arithmetics (division and power)

% Imply statements
val(X,V) :- imply_instance(X,Formula), included(X), val(Formula,V).

% Show statement for numeric values
#show val(X,V) : val(X,V), num(X).
