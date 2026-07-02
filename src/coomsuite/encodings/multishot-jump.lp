% program parts for the jump grounding strategy
% the non-incremental new-* parts and the non-function incremental parts are identical to the
% stepwise strategy (multishot.lp); only the incremental function parts differ: instead of the
% stepwise new-/update-function parts, two alternative function encodings are provided
% (self-contained "full" and "extend"), selected at grounding time by the application class.
#include "multi/new-object.lp".
#include "multi/new-constraint.lp".
#include "multi/new-column.lp".
#include "multi/new-unary.lp".
#include "multi/new-binary.lp".
#include "multi/new-function.lp".
#include "multi/new-allow.lp".
#include "multi/new-constant.lp".
#include "multi/new-number.lp".
#include "multi/new-optimize.lp".

#defined value/3.
#include "multi/inc-function-full.lp".
#include "multi/inc-function-extend.lp".
#include "multi/inc-unary.lp".
#include "multi/inc-binary.lp".
#include "multi/inc-constraint.lp".
#include "multi/inc-optimize.lp".
