% include(a;b;c).
var(a;b;c;s).
set(a;b).

&sum{1} = a.
&sum{3} = b.
&sum{6} = c.

&sum{ X : set(X)} = s.

include(X) :- &sum{X} = 4, var(X).
