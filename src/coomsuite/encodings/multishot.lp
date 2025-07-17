#include "multi/new-object.lp".
#include "multi/new-constraint.lp".
#include "multi/new-column.lp".
#include "multi/new-unary.lp".
#include "multi/new-binary.lp".
#include "multi/new-function.lp".
#include "multi/new-allow.lp".

% TODO: proper handling for nested unbounded cardinalities
% - will require having two program parts for each type of expression
% - new_incremental_function defines initial value of the function
%   (compared to current encoding this initial value can be at any bound not just 0/1)
% - update_incremental_function is like the current encoding just with initial definitions removed
% incremental functions and co
#include "multi/inc-function.lp".
#include "multi/inc-unary.lp".
#include "multi/inc-binary.lp".
#include "multi/inc-constraint.lp".
