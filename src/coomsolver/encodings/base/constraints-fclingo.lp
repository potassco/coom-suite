#include "fclingo/binary.lp".
#include "fclingo/table.lp".
#include "fclingo/function.lp".
#include "fclingo/arithmetics.lp".

% Constraints cannot be unsatisfied
:- constraint(C), unsatisfied(C,_).

:- constraint(C,F), defined(F), not satisfied(F).
