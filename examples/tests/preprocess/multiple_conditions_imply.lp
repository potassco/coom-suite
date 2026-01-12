coom_structure("product").
coom_feature("product","color","Color",1,1).
coom_feature("product","size","Size",1,1).
coom_feature("product","option","num",1,1).
coom_range("product","option",1,2).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Blue").

coom_enumeration("Size").
coom_option("Size", "Small").
coom_option("Size", "Big").

coom_behavior(0).
coom_context(0,"product").
coom_condition(0,0,"color=Red").
coom_binary("color=Red","color","=","Red").
coom_path("color",0,"color").
coom_constant("Red").
coom_condition(0,1,"size=Small").
coom_binary("size=Small","size","=","Small").
coom_path("size",0,"size").
coom_constant("Small").
coom_imply(0,"option","2").
coom_path("option",0,"option").
coom_number("2",2).
