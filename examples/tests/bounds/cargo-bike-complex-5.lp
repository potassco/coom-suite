coom_structure("product").
coom_feature("product","totalBags","num",1,1).
coom_range("product","totalBags",0,10).
coom_feature("product","requestedBags","num",1,1).
coom_range("product","requestedBags",0,10).
coom_feature("product","bags","Bag",0,#sup).
coom_feature("product","color","Color",1,1).

coom_structure("Bag").
coom_feature("Bag","color","Color",1,1).
coom_feature("Bag","size","Size",1,1).
coom_feature("Bag","pockets","Pocket",0,#sup).
coom_feature("Bag","openings","Opening",1,3).

coom_enumeration("Pocket").
coom_option("Pocket", "S").
coom_option("Pocket", "M").
coom_option("Pocket", "L").
coom_option("Pocket", "XL").

coom_enumeration("Opening").
coom_option("Opening", "Zipper").
coom_option("Opening", "Velcro").

coom_enumeration("Color").
coom_option("Color", "Green").
coom_option("Color", "Blue").
coom_option("Color", "Red").

coom_enumeration("Size").
coom_option("Size", "Small").
coom_option("Size", "Medium").
coom_option("Size", "Large").

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"totalBags=count(bags)").
coom_binary("totalBags=count(bags)","totalBags","=","count(bags)").
coom_path("totalBags",0,"totalBags").
coom_function("product","count(bags)","count","bags").
coom_path("bags",0,"bags").

coom_behavior(1).
coom_context(1,"product").
coom_require(1,"totalBags>=requestedBags").
coom_binary("totalBags>=requestedBags","totalBags",">=","requestedBags").
coom_path("totalBags",0,"totalBags").
coom_path("requestedBags",0,"requestedBags").

coom_behavior(2).
coom_context(2,"product").
coom_require(2,"color=Blue").
coom_binary("color=Blue","color","=","Blue").
coom_path("color",0,"color").
coom_constant("Blue").

coom_behavior(3).
coom_context(3,"product").
coom_condition(3,0,"color=Blue").
coom_binary("color=Blue","color","=","Blue").
coom_path("color",0,"color").
coom_constant("Blue").
coom_require(3,"3<=count(bags)").
coom_binary("3<=count(bags)","3","<=","count(bags)").
coom_number("3",3).
coom_function("product","count(bags)","count","bags").
coom_path("bags",0,"bags").

coom_behavior(4).
coom_context(4,"product").
coom_require(4,"bags.color=Green").
coom_binary("bags.color=Green","bags.color","=","Green").
coom_path("bags.color",0,"bags").
coom_path("bags.color",1,"color").
coom_constant("Green").

coom_behavior(5).
coom_context(5,"Bag").
coom_require(5,"2<=count(pockets)").
coom_binary("2<=count(pockets)","2","<=","count(pockets)").
coom_number("2",2).
coom_function("Bag","count(pockets)","count","pockets").
coom_path("pockets",0,"pockets").

coom_behavior(6).
coom_context(6,"Bag").
coom_combinations(6,0,"size").
coom_combinations(6,1,"pockets").
coom_path("size",0,"size").
coom_path("pockets",0,"pockets").
coom_allow(6,(0,0),"Small").
coom_allow(6,(1,0),"S").
coom_allow(6,(0,1),"Medium").
coom_allow(6,(1,1),"M").
coom_allow(6,(0,2),"Large").
coom_allow(6,(1,2),"L").
coom_allow(6,(1,2),"XL").

coom_behavior(7).
coom_context(7,"Bag").
coom_require(7,"2<=count(openings)").
coom_binary("2<=count(openings)","2","<=","count(openings)").
coom_number("2",2).
coom_function("Bag","count(openings)","count","openings").
coom_path("openings",0,"openings").

coom_behavior(8).
coom_context(8,"product").
coom_require(8,"5<count(bags.pockets)").
coom_binary("5<count(bags.pockets)","5","<","count(bags.pockets)").
coom_number("5",5).
coom_function("product","count(bags.pockets)","count","bags.pockets").
coom_path("bags.pockets",0,"bags").
coom_path("bags.pockets",1,"pockets").

coom_user_value("root.requestedBags[0]",5).
