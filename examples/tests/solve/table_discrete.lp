part("product").
discrete("A",str).
domain("A",("A1";"A2";"A3")).
type("root.x[0]","A").
type("root.y[0]","A").
parent("root.x[0]","root").
parent("root.y[0]","root").
index("root.x[0]",0).
index("root.y[0]",0).

constraint((0,"root"),"table").
column((0,"root"),0,0,"root.x[0]").
column((0,"root"),0,1,"root.y[0]").
allow(0,(0,0),"A1").
allow(0,(1,0),"A2").
allow(0,(1,0),"A3").
allow(0,(0,1),"A2").
allow(0,(1,1),"A1").
allow(0,(0,2),"A3").
allow(0,(1,2),"A2").

constraint(("root.x",1),"lowerbound").
set("root.x","root.x[0]").
constraint(("root.y",1),"lowerbound").
set("root.y","root.y[0]").
