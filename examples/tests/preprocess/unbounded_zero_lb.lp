coom_structure("product").
coom_feature("product","totalVolume","num",1,1).
coom_range("product","totalVolume",0,200).
coom_feature("product","requestedVolume","num",1,1).
coom_range("product","requestedVolume",0,200).
coom_feature("product","bags","Bag",0,#sup).
coom_feature("product","color","Color",1,1).

coom_structure("Bag").
coom_feature("Bag","color","Color",1,1).
coom_feature("Bag","size","Size",1,1).
coom_feature("Bag","pockets","Pocket",0,#sup).
coom_feature("Bag","closures","Closure",1,3).

coom_enumeration("Color").
coom_option("Color", "Green").
coom_option("Color", "Blue").
coom_option("Color", "Red").

coom_enumeration("Pocket").
coom_option("Pocket", "S").
coom_option("Pocket", "M").
coom_option("Pocket", "L").
coom_option("Pocket", "XL").

coom_enumeration("Closure").
coom_option("Closure", "Zipper").
coom_option("Closure", "Velcro").

coom_enumeration("Size").
coom_attribute("Size","volume","num").
coom_option("Size", "small").
coom_attribute_value("Size","small","volume",12).
coom_option("Size", "medium").
coom_attribute_value("Size","medium","volume",16).
coom_option("Size", "large").
coom_attribute_value("Size","large","volume",20).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"totalVolume=sum(bags.size.volume)").
coom_binary("totalVolume=sum(bags.size.volume)","totalVolume","=","sum(bags.size.volume)").
coom_path("totalVolume",0,"totalVolume").
coom_function("product","sum(bags.size.volume)","sum","bags.size.volume").
coom_path("bags.size.volume",0,"bags").
coom_path("bags.size.volume",1,"size").
coom_path("bags.size.volume",2,"volume").

coom_behavior(1).
coom_context(1,"product").
coom_require(1,"totalVolume>=requestedVolume").
coom_binary("totalVolume>=requestedVolume","totalVolume",">=","requestedVolume").
coom_path("totalVolume",0,"totalVolume").
coom_path("requestedVolume",0,"requestedVolume").

coom_behavior(2).
coom_context(2,"product").
coom_require(2,"color=Blue").
coom_binary("color=Blue","color","=","Blue").
coom_path("color",0,"color").
coom_constant("Blue").

coom_behavior(3).
coom_context(3,"product").
coom_require(3,"bags.color=Green").
coom_binary("bags.color=Green","bags.color","=","Green").
coom_path("bags.color",0,"bags").
coom_path("bags.color",1,"color").
coom_constant("Green").

coom_behavior(4).
coom_context(4,"product").
coom_require(4,"5<count(bags.pockets)").
coom_binary("5<count(bags.pockets)","5","<","count(bags.pockets)").
coom_number("5",5).
coom_function("product","count(bags.pockets)","count","bags.pockets").
coom_path("bags.pockets",0,"bags").
coom_path("bags.pockets",1,"pockets").

coom_behavior(5).
coom_context(5,"Bag").
coom_require(5,"2<=count(pockets)").
coom_binary("2<=count(pockets)","2","<=","count(pockets)").
coom_number("2",2).
coom_function("Bag","count(pockets)","count","pockets").
coom_path("pockets",0,"pockets").

coom_behavior(6).
coom_context(6,"Bag").
coom_require(6,"2<=count(closures)").
coom_binary("2<=count(closures)","2","<=","count(closures)").
coom_number("2",2).
coom_function("Bag","count(closures)","count","closures").
coom_path("closures",0,"closures").

coom_behavior(7).
coom_context(7,"Bag").
coom_combinations(7,0,"size").
coom_combinations(7,1,"pockets").
coom_path("size",0,"size").
coom_path("pockets",0,"pockets").
coom_allow(7,(0,0),"small").
coom_allow(7,(1,0),"S").
coom_allow(7,(0,1),"medium").
coom_allow(7,(1,1),"M").
coom_allow(7,(0,2),"large").
coom_allow(7,(1,2),"L").
coom_allow(7,(1,2),"XL").

coom_behavior(8).
coom_context(8,"Bag").
coom_combinations(8,0,"color").
coom_combinations(8,1,"closures").
coom_path("color",0,"color").
coom_path("closures",0,"closures").
coom_allow(8,(0,0),"Green").
coom_allow(8,(1,0),"Zipper").
coom_allow(8,(1,0),"Velcro").
coom_allow(8,(0,1),"Blue").
coom_allow(8,(0,1),"Red").
coom_allow(8,(1,1),"Zipper").
