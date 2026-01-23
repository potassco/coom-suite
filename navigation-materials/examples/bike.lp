1 { type(race;city;travel) } 1.

{ include(light;bell;mudguards) }.

1 { framesize(s;m;l) } 1.

1 { color(red;blue;green) } 1.

0 { bagsize(X,(s;m;l)) } 1 :- X = 1..4.

weight(W) :- W = #sum{ 3   : framesize(s) ; 4   : framesize(m) ; 5   : framesize(l) ;
                       1,X : bagsize(X,s) ; 2,X : bagsize(X,m) ; 3,X : bagsize(X,l) ;
                       1,X : include(X) }.

:- type(race), include(mudguards).
:- type(city), not include(light).
:- type(race), bagsize(X,l).
:- type(travel), not bagsize(X,l) : X = 1..4.
:- bagsize(1,l).
:- bagsize(4,s).
