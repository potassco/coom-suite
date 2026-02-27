
type("root","product").
type("root.modules[0]","Module").
index("root.modules[0]",0).
parent("root.modules[0]","root").
constraint(("root.modules",1),"lowerbound").
set("root.modules","root.modules[0]").
part("product").
part("Module").
user_associate(("root.basket[0]","root.modules[0]")).
