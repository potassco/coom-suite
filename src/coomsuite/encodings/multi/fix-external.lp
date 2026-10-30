% permanently set active/max_bound externals to true and remove external status

#program fix_active(l,u).
active(N) :- N = l..u.

#program fix_max_bound(b).
max_bound(b).
