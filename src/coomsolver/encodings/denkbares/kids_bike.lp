% Configuration facts
% ===================

instance(":root", "${root}").

% Product structure and behavior
% ==============================

structure(":root").
feature(":root", "color", "Color", 1, 1).
feature(":root", "supportWheels", "bool", 1, 1).
feature(":root", "frontWheel", "Wheel", 1, 1).
feature(":root", "rearWheel", "Wheel", 1, 1).

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
option("Wheel", "W14", 0).
attribute("Wheel", "W14", "size", 14).
attribute("Wheel", "W14", "weight", 550).
option("Wheel", "W16", 1).
attribute("Wheel", "W16", "size", 16).
attribute("Wheel", "W16", "weight", 550).
option("Wheel", "W18", 2).
attribute("Wheel", "W18", "size", 18).
attribute("Wheel", "W18", "weight", 600).
option("Wheel", "W20", 3).
attribute("Wheel", "W20", "size", 20).
attribute("Wheel", "W20", "weight", 650).

behavior(":root", combinations_1).
path(path_1, ":root", "supportWheels", 0).
x(constant_1, const, 0, "true").
eq(compare_1, ":root", path_1, constant_1).
disjunction(disjunction_1, ":root").
path(path_2, ":root", "rearWheel", 0).
x(constant_2, const, 0, "W14").
eq(compare_2, ":root", path_2, constant_2).
disjunction(disjunction_1, ":root", compare_2).
x(constant_3, const, 0, "W16").
eq(compare_3, ":root", path_2, constant_3).
disjunction(disjunction_1, ":root", compare_3).
conjunction(conjunction_1, ":root").
conjunction(conjunction_1, ":root", compare_1).
conjunction(conjunction_1, ":root", disjunction_1).
disjunction(disjunction_2, ":root").
x(constant_4, const, 0, "W18").
eq(compare_4, ":root", path_2, constant_4).
disjunction(disjunction_2, ":root", compare_4).
x(constant_5, const, 0, "W20").
eq(compare_5, ":root", path_2, constant_5).
disjunction(disjunction_2, ":root", compare_5).
conjunction(conjunction_2, ":root").
conjunction(conjunction_2, ":root", constant_1).
conjunction(conjunction_2, ":root", disjunction_2).
disjunction(combinations_1, ":root").
disjunction(combinations_1, ":root", conjunction_1).
disjunction(combinations_1, ":root", conjunction_2).
% Stützräder sind bei Radgröße W14 und W16 obligatorisch..

behavior(":root", compare_6).
path(path_3, ":root", "frontWheel", 0).
attr(path_4, path_3, "Wheel", "size").
attr(path_5, path_2, "Wheel", "size").
eq(compare_6, ":root", path_4, path_5).
% Vorder- und Hinterrad müssen dieselbe Größe haben.

behavior(":root", implication_1).
path(path_6, ":root", "color", 0).
x(constant_6, const, 0, "Yellow").
eq(compare_7, ":root", path_6, constant_6).
x(constant_7, const, 0, 18).
gte(compare_8, ":root", path_4, constant_7).
implication(implication_1, ":root", compare_7, compare_8).
% Farbe Gelb ist erst ab Vorderradgröße 18 möglich..
x(P, V0, (I0), V1) :- path(P, T, F0, I0),
		instance(T, V0),
		value(V0, F0, I0, V1).

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
