% only Green bags (w=1) are allowed by the table, their sum has to be at least 6 (minimal bound 6)
coom_structure("product").
coom_feature("product","bags","Bag",0,#sup).

coom_structure("Bag").
coom_feature("Bag","color","Color",1,1).

coom_enumeration("Color").
coom_attribute("Color","w","num").
coom_option("Color", "Green").
coom_attribute_value("Color","Green","w",1).
coom_option("Color", "Red").
coom_attribute_value("Color","Red","w",2).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"sum(bags.color.w)>=6").
coom_binary("sum(bags.color.w)>=6","sum(bags.color.w)",">=","6").
coom_function("product","sum(bags.color.w)","sum","bags.color.w").
coom_path("bags.color.w",0,"bags").
coom_path("bags.color.w",1,"color").
coom_path("bags.color.w",2,"w").
coom_number("6",6).

coom_behavior(1).
coom_context(1,"product").
coom_combinations(1,0,"bags.color").
coom_path("bags.color",0,"bags").
coom_path("bags.color",1,"color").
coom_allow(1,(0,0),"Green").
