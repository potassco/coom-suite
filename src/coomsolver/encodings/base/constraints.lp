#include "clingo/binary.lp".
#include "clingo/table.lp".
#include "clingo/function.lp".
#include "clingo/arithmetics.lp".

% Constraints cannot be unsatisfied
:- constraint(C), unsatisfied(C,_).

:- constraint(C,F), defined(F), not satisfied(F).
