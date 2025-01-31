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
% include("c").
&sum{"a"} = 5.
&sum{"b"} = 7.
% &sum{"c"} = 3.

&show{x}.


appearsIn(ID,"left",X)  :- constraint(ID,"boolean"), ID = (_,F), binary(F,X,_,_).
appearsIn(ID,"right",R) :- constraint(ID,"boolean"), ID = (_,F), binary(F,_,_,R).
appearsIn(ID,"right",L) :- appearsIn(ID,"right",F), binary(F,L,_,_).
appearsIn(ID,"right",R) :- appearsIn(ID,"right",F), binary(F,_,_,R).

&sum{ X : appearsIn(ID,"right",X), include(X) } = L :- constraint(ID,"boolean"), appearsIn(ID,"left",L).
% &sus{ X : appearsIn(ID,"right",X), include(X) } =: L :- constraint(ID,"boolean"), appearsIn(ID,"left",L).
#show .
