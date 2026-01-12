part("product").
discrete("A",str).
domain("A",("A1";"A2")).
type("root.x[0]","A").
parent("root.x[0]","root").
index("root.x[0]",0).


constraint((0,"root"),"table").
column((0,"root"),0,0,"root.x[0]").
column((0,"root"),0,1,"root.y[0]").
allow(0,(0,0),"A1").
allow(0,(1,0),"A2").
allow(0,(1,0),"A3").

constraint(("root.x",1),"lowerbound").
set("root.x","root.x[0]").
