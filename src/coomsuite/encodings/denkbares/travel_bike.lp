% Configuration facts
% ===================

instance(":root", "${root}").
value("${root}", "frame", 0, "$ref{Frame:0}").
value("${root}", "carrier", 0, "$ref{Carrier:0}").
instance("Frame", "$ref{Frame:0}").
instance("Carrier", "$ref{Carrier:0}").

% Product structure and behavior
% ==============================

structure(":root").
feature(":root", "totalWeight", num, 1, 1).
minmax(":root", "totalWeight", infinity, infinity).
feature(":root", "maxWeight", num, 1, 1).
minmax(":root", "maxWeight", 1000, 20000).
feature(":root", "totalVolume", num, 1, 1).
minmax(":root", "totalVolume", 0, 2000).
feature(":root", "requestedVolume", num, 1, 1).
minmax(":root", "requestedVolume", 0, 2000).
feature(":root", "frontWheel", "Wheel", 1, 1).
feature(":root", "rearWheel", "Wheel", 1, 1).
feature(":root", "color", "Color", 1, 1).
feature(":root", "frame", "Frame", 1, 1).
feature(":root", "carrier", "Carrier", 1, 1).

structure("Bag").
feature("Bag", "capacity", "Capacity", 1, 1).
feature("Bag", "material", "Material", 1, 1).

structure("Frame").
feature("Frame", "bags", "Bag", 0, 2).
feature("Frame", "material", "FrameMaterial", 1, 1).

structure("GeneralFeatures").

structure("Mounting").
feature("Mounting", "Befestigungsmaterial", "bool", 1, 1).
feature("Mounting", "Thermoplatte", "bool", 1, 1).

structure("Elektrics").
feature("Elektrics", "drive", "PowerDrive", 1, 1).

structure("Carrier").
feature("Carrier", "bags", "Bag", 0, 3).

structure("Grouping").

structure("Pricing").

structure("Finish").
feature("Finish", "color", "Color", 1, 1).

structure("PowerDrive").
feature("PowerDrive", "power", "Power", 1, 1).
feature("PowerDrive", "capacity", "BatteryCapacity", 1, 1).
feature("PowerDrive", "detachableBattery", "bool", 1, 1).

structure("Safety").
feature("Safety", "SupportWheels", "bool", 1, 1).
feature("Safety", "width", num, 1, 1).
minmax("Safety", "width", 10000, 1000000).

structure("Handle").
feature("Handle", "color", "Color", 1, 1).
feature("Handle", "extraSoftGrips", "bool", 1, 1).

structure("Accessories").
feature("Accessories", "bags", "Bag", 1, 1).

structure("Mechanics").
feature("Mechanics", "wheel", "Wheel", 1, 1).
feature("Mechanics", "frame", "Frame", 1, 1).
feature("Mechanics", "Carrier", "Carrier", 1, 1).
feature("Mechanics", "handle", "Handle", 1, 1).

enumeration("bool").
option("bool", "false", 0).
option("bool", "true", 1).

enumeration("Power").
option("Power", "_200W", 0).
option("Power", "_400W", 1).
option("Power", "_600W", 2).

enumeration("Color").
option("Color", "Red", 0).
option("Color", "Green", 1).
option("Color", "Yellow", 2).
option("Color", "Blue", 3).
option("Color", "White", 4).
option("Color", "Black", 5).

enumeration("Capacity").
option("Capacity", "B10", 0).
attribute("Capacity", "B10", "volume", 10).
attribute("Capacity", "B10", "weight", 100).
option("Capacity", "B20", 1).
attribute("Capacity", "B20", "volume", 20).
attribute("Capacity", "B20", "weight", 250).
option("Capacity", "B50", 2).
attribute("Capacity", "B50", "volume", 50).
attribute("Capacity", "B50", "weight", 600).
option("Capacity", "B100", 3).
attribute("Capacity", "B100", "volume", 100).
attribute("Capacity", "B100", "weight", 1200).

enumeration("FrameMaterial").
option("FrameMaterial", "Steel", 0).
option("FrameMaterial", "Aluminium", 1).
option("FrameMaterial", "Carbon", 2).

enumeration("BatteryCapacity").
option("BatteryCapacity", "_400Wh", 0).
option("BatteryCapacity", "_650Wh", 1).
option("BatteryCapacity", "_800Wh", 2).

enumeration("Material").
option("Material", "Cotton", 0).
option("Material", "Leather", 1).
option("Material", "Polyester", 2).

enumeration("Wheel").
option("Wheel", "W20", 0).
attribute("Wheel", "W20", "size", 20).
attribute("Wheel", "W20", "weight", 650).
option("Wheel", "W22", 1).
attribute("Wheel", "W22", "size", 22).
attribute("Wheel", "W22", "weight", 700).
option("Wheel", "W24", 2).
attribute("Wheel", "W24", "size", 24).
attribute("Wheel", "W24", "weight", 800).
option("Wheel", "W26", 3).
attribute("Wheel", "W26", "size", 26).
attribute("Wheel", "W26", "weight", 900).
option("Wheel", "W28", 4).
attribute("Wheel", "W28", "size", 28).
attribute("Wheel", "W28", "weight", 1000).

behavior(":root", combinations_1).
path(path_1, ":root", "frontWheel", 0).
x(constant_1, const, 0, "W24").
eq(compare_1, ":root", path_1, constant_1).
path(path_2, ":root", "rearWheel", 0).
eq(compare_2, ":root", path_2, constant_1).
path(path_3, ":root", "color", 0).
x(constant_2, const, 0, "Green").
neq(compare_3, ":root", path_3, constant_2).
conjunction(conjunction_1, ":root").
conjunction(conjunction_1, ":root", compare_1).
conjunction(conjunction_1, ":root", compare_2).
conjunction(conjunction_1, ":root", compare_3).
disjunction(disjunction_1, ":root").
x(constant_3, const, 0, "W26").
eq(compare_4, ":root", path_1, constant_3).
disjunction(disjunction_1, ":root", compare_4).
x(constant_4, const, 0, "W28").
eq(compare_5, ":root", path_1, constant_4).
disjunction(disjunction_1, ":root", compare_5).
eq(compare_6, ":root", path_2, constant_4).
eq(compare_7, ":root", path_3, constant_2).
conjunction(conjunction_2, ":root").
conjunction(conjunction_2, ":root", disjunction_1).
conjunction(conjunction_2, ":root", compare_6).
conjunction(conjunction_2, ":root", compare_7).
disjunction(disjunction_2, ":root").
disjunction(disjunction_2, ":root", compare_4).
disjunction(disjunction_2, ":root", compare_1).
conjunction(conjunction_3, ":root").
conjunction(conjunction_3, ":root", disjunction_2).
conjunction(conjunction_3, ":root", compare_2).
conjunction(conjunction_3, ":root", compare_7).
conjunction(conjunction_4, ":root").
conjunction(conjunction_4, ":root", compare_5).
conjunction(conjunction_4, ":root", compare_6).
conjunction(conjunction_4, ":root", compare_3).
eq(compare_8, ":root", path_2, constant_3).
x(constant_5, const, 0, "true").
conjunction(conjunction_5, ":root").
conjunction(conjunction_5, ":root", compare_4).
conjunction(conjunction_5, ":root", compare_8).
conjunction(conjunction_5, ":root", constant_5).
disjunction(combinations_1, ":root").
disjunction(combinations_1, ":root", conjunction_1).
disjunction(combinations_1, ":root", conjunction_2).
disjunction(combinations_1, ":root", conjunction_3).
disjunction(combinations_1, ":root", conjunction_4).
disjunction(combinations_1, ":root", conjunction_5).

behavior(":root", assign_1).
path(path_4, ":root").
attr(path_5, path_1, "Wheel", "weight").
attr(path_6, path_2, "Wheel", "weight").
add(formula_1, ":root", path_5, path_6).
path(path_7, ":root", "carrier", 0, "bags", 0..2, "capacity", 0).
attr(path_8, path_7, "Capacity", "weight").
sum(formula_2, ":root", path_8).
add(formula_3, ":root", formula_1, formula_2).
path(path_9, ":root", "frame", 0, "bags", 0..1, "capacity", 0).
attr(path_10, path_9, "Capacity", "weight").
sum(formula_4, ":root", path_10).
add(formula_5, ":root", formula_3, formula_4).
assign(assign_1, path_4, "totalWeight", 0, formula_5).

behavior(":root", compare_9).
path(path_11, ":root", "carrier", 0, "bags", 0..2).
count(formula_6, ":root", path_11).
path(path_12, ":root", "frame", 0, "bags", 0..1).
count(formula_7, ":root", path_12).
add(formula_8, ":root", formula_6, formula_7).
x(constant_6, const, 0, 4).
lte(compare_9, ":root", formula_8, constant_6).

behavior(":root", assign_2).
attr(path_13, path_7, "Capacity", "volume").
sum(formula_9, ":root", path_13).
attr(path_14, path_9, "Capacity", "volume").
sum(formula_10, ":root", path_14).
add(formula_11, ":root", formula_9, formula_10).
assign(assign_2, path_4, "totalVolume", 0, formula_11).

behavior(":root", implication_1).
path(path_15, ":root", "requestedVolume", 0).
x(constant_7, const, 0, 0).
gt(compare_10, ":root", path_15, constant_7).
path(path_16, ":root", "totalVolume", 0).
gte(compare_11, ":root", path_16, path_15).
implication(implication_1, ":root", compare_10, compare_11).

behavior(":root", compare_12).
attr(path_17, path_1, "Wheel", "size").
attr(path_18, path_2, "Wheel", "size").
eq(compare_12, ":root", path_17, path_18).

behavior(":root", implication_2).
x(constant_8, const, 0, "Red").
eq(compare_13, ":root", path_3, constant_8).
x(constant_9, const, 0, 20).
eq(compare_14, ":root", path_17, constant_9).
implication(implication_2, ":root", compare_13, compare_14).

behavior(":root", implication_3).
x(constant_10, const, 0, "Yellow").
eq(compare_15, ":root", path_3, constant_10).
x(constant_11, const, 0, 18).
gte(compare_16, ":root", path_17, constant_11).
implication(implication_3, ":root", compare_15, compare_16).
% Farbe Gelb ist erst ab Vorderradgröße 18 möglich..

behavior(":root", assign_3).
default(assign_3, path_4, "color", 0, constant_8, 1).

behavior("Bag", assign_4).
path(path_19, "Bag").
x(constant_12, const, 0, "Leather").
default(assign_4, path_19, "material", 0, constant_12, 1).

behavior("Bag", assign_5).
path(path_20, "Bag", "material", 0).
eq(compare_17, "Bag", path_20, constant_12).
x(constant_13, const, 0, "B10").
default(compare_17, path_19, "capacity", 0, constant_13, 2).

behavior("Frame", assign_6).
path(path_21, "Frame", "bags", 1).
path(path_22, "Frame", "bags", 0).
constituent(exists_1, "Frame", path_22).
path(path_23, "Frame", "bags", 0, "material", 0).
default(exists_1, path_21, "material", 0, path_23, 2).

behavior("Carrier", assign_7).
path(path_24, "Carrier", "bags", 1..2).
path(path_25, "Carrier", "bags", 0).
constituent(exists_2, "Carrier", path_25).
path(path_26, "Carrier", "bags", 0, "material", 0).
default(exists_2, path_24, "material", 0, path_26, 2).
%
% Generated rules
%
x(P, V0, (), V0) :- path(P, T),
		instance(T, V0).
x(P, V0, (I0), V1) :- path(P, T, F0, I0),
		instance(T, V0),
		value(V0, F0, I0, V1).
x(P, V0, (I0, I1), V2) :- path(P, T, F0, I0, F1, I1),
		instance(T, V0),
		value(V0, F0, I0, V1),
		value(V1, F1, I1, V2).
x(P, V0, (I0, I1, I2), V3) :- path(P, T, F0, I0, F1, I1, F2, I2),
		instance(T, V0),
		value(V0, F0, I0, V1),
		value(V1, F1, I1, V2),
		value(V2, F2, I2, V3).

% Commonly used letters:
% T: type
% X: some id of a fact
% N: name of instance
% I,J,K: indices
% O: option
% A: attribute
% V: value
% _L, _R: something left or right
% B: behavior

% First, derive attribute values from their parent non-attribute path.
% Note, that path rules will be separately generated in the model factory.
% Also, we implicitly assume a path given by PID here (otherwise this rule will not hold).
x(X, N, (I, A), V) :- attr(X, P, T, A), x(P, N, I, O), attribute(T, O, A, V).
value(N, F, I, V) :- assign(X, P, F, I, Y),
                     not unsat(X, N),
                     x(P, NP, J, N),
                     x(Y, VP, K, V).

% Arithmetic Operations
x(X, N, (IL, IR), VL + VR) :- add(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR).
x(X, N, (IL, IR), VL - VR) :- sub(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR).
x(X, N, (IL, IR), VL * VR) :- mul(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR).
x(X, N, (IL, IR), VL / VR) :- div(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR).
x(X, N,  I, -V)            :- neg(X, T, Y),    instance(T, N), x(Y, (N;":root";const), I, V).

% Aggregations
x(X, N, 0, Y) :-   sum(X, T, P), instance(T, N), Y =   #sum{ V,I : x(P, (N;":root";const), I, V) }.
x(X, N, 0, Y) :- count(X, T, P), instance(T, N), Y = #count{ V,I : x(P, (N;":root";const), I, V) }.
x(X, N, 0, Y) :-   max(X, T, P), instance(T, N), Y =   #max{ V : x(P, (N;":root";const), I, V) }.
x(X, N, 0, Y) :-   min(X, T, P), instance(T, N), Y =   #min{ V : x(P, (N;":root";const), I, V) }.

% If we assume satisfiability by default, we can easily work with sequence values, since a single value will make
% the expression unsat.
% Assuming unsatisfiablity on the other hand, would mean to specify the conditions of satisfiability, which is
% harder if the concrete number of values in a sequence is not known.
unsat(X, N) :-  lt(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR), VL >= VR.
unsat(X, N) :- lte(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR), VL >  VR.
unsat(X, N) :-  gt(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR), VL <= VR.
unsat(X, N) :- gte(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR), VL <  VR.
unsat(X, N) :-  eq(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR), VL != VR.
unsat(X, N) :- neq(X, T, L, R), instance(T, N), x(L, (N;":root";const), IL, VL), x(R, (N;":root";const), IR, VR), VL  = VR.

unsat(X, N) :- disjunction(X, T),       instance(T, N), unsat(Y, N) : disjunction(X, T, Y).
unsat(X, N) :- conjunction(X, T, Y),    instance(T, N), unsat(Y, N).
unsat(X, N) :- implication(X, T, L, R), instance(T, N), not unsat(L, N), unsat(R, N).
unsat(X, N) :- negation(X, T, Y),       instance(T, N), not unsat(Y, N).
unsat(X, N) :- exists(X, T, E),         instance(T, N), not x(E, N, _, _).

% for discrete values choose exactly one from its possible values
MIN { value(N, F, I, V) : option(T, V, O), I=0..MAX-1 } MAX :-
	instance(S, N), feature(S, F, T, MIN, MAX), enumeration(T).

% for numerical values there is either a given value, a default value, a calculation (given as option) or no value
{ value(N, F, I, V) : value(N, F, I, V) ;
  value(N, F, I, V) : default(D, P, F, I, Y, C),
                      not unsat(D, N),
                      x(P, NP, J, N),
                      x(Y, VP, K, V) %;
  %value(N, F, I, V) : option(PID, VID),
  %                    path(PID, S, F, I),
  %                    value(VID, V)
 } <= 1 :- instance(S, N), feature(S, F, num, MIN, MAX), I=0..MAX-1.

:- behavior(T, B), instance(T, N), unsat(B, N).
:~ behavior(T, B), instance(T, N), unsat(B, B), cost(B, C). [C,B,N]

% it cannot be, that
:- instance(S, N), % there is an instance
   feature(S, F, T, MIN, MAX), % with a feature
   MAX > 1, % that allows more than one value
   value(N, F, I, V1), % where there exists a value1 for a certain index
   value(N, F, I, V2), % and a value2 for the same index
   V1 < V2. % and the values are not equal.


% the heuristic says, that default values should be set true first (prio level 1000)
#heuristic value(N, F, I, V) : default(D, P, F, I, Y, C),
                               not unsat(D, N),
                               x(P, NP, J, N),
                               x(Y, VP, K, V). [C,true]
