variable("a").
variable("b").
variable("c").
% variable("x").

constraint((0,"x=a+b+c"),"boolean").
binary("x=a+b+c",x,"=","a+b+c").
binary("a+b+c","a","+","b+c").
binary("b+c","b","+","c").

include("a").
include("b").
include("c") :- test(defined).
&sum{"a"} = 5.
&sum{"b"} = 7.
&sum{"c"} = 3 :- test(defined).

&sum{ X : appearsIn(ID,"right",X), include(X) } = L :- constraint(ID,"boolean"), appearsIn(ID,"left",L), test(sum), test(include).
&sus{ X : appearsIn(ID,"right",X), include(X) } =: L :- constraint(ID,"boolean"), appearsIn(ID,"left",L), test(sus), test(include).

&sum{ X : appearsIn(ID,"right",X), variable(X)} = L :- constraint(ID,"boolean"), appearsIn(ID,"left",L), test(sum), not test(include).
&sus{ X : appearsIn(ID,"right",X), variable(X)} =: L :- constraint(ID,"boolean"), appearsIn(ID,"left",L), test(sus), not test(include).

% test(defined).
% test(include).
{ test(sum) ; test(sus) } = 1.
% test(sum).
#show test/1.
#show .
&show{x}.

appearsIn(ID,"left",X)  :- constraint(ID,"boolean"), ID = (_,F), binary(F,X,_,_).
appearsIn(ID,"right",R) :- constraint(ID,"boolean"), ID = (_,F), binary(F,_,_,R).
appearsIn(ID,"right",L) :- appearsIn(ID,"right",F), binary(F,L,_,_).
appearsIn(ID,"right",R) :- appearsIn(ID,"right",F), binary(F,_,_,R).
