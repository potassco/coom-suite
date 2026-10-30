var(a;b;c).

{include(a;b;c)}.

% set(a;b).

&sum{1} = a :- include(a).
&sum{3} = b :- include(b).
&sum{6} = c :- include(c).
&sum{0} = X :- var(X), not include(X).

&sum{ count(X) } = 1 :- var(X), include(X).
&sum{ count(X) } = 0 :- var(X), not include(X).

&sum{ count(X) : var(X) } = s.

% include(X) :- &sum{X} = 4, var(X).

#show include/1.
% &show{ X : var(X) }.
&show{ s }.
