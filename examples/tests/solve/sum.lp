part("product").
numeric("X",int).
range("X",1,2).
type("root.x[0]","X").
type("root.x[1]","X").
parent("root.x[0]","root").
parent("root.x[1]","root").
index("root.x[0]",0).
index("root.x[1]",1).

constraint((0,"sum(root.x)=3"),"boolean").
binary("sum(root.x)=3","sum(root.x)","=","3").
function("sum(root.x)","sum","root.x").
set("root.x","root.x[0]").
set("root.x","root.x[1]").
number("3",3).

constraint(("root.x",2),"lowerbound").
