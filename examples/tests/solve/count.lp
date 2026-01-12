part("product").
part("X").
type("root.x[0]","X").
type("root.x[1]","X").
type("root.x[2]","X").
parent("root.x[0]","root").
parent("root.x[1]","root").
parent("root.x[2]","root").
index("root.x[0]",0).
index("root.x[1]",1).
index("root.x[2]",2).

constraint((0,"count(root.x)=2"),"boolean").
binary("count(root.x)=2","count(root.x)","=","2").
function("count(root.x)","count","root.x").
set("root.x","root.x[0]").
set("root.x","root.x[1]").
set("root.x","root.x[2]").
constant(("2",2),int).

constraint(("root.x",0),"lowerbound").
