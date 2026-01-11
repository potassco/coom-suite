type("root","product").
type("root.a[0]","A").
index("root.a[0]",0).
parent("root.a[0]","root").
constraint(("root.a",1),"lowerbound").
set("root.a","root.a[0]").
part("product").
part("A").
