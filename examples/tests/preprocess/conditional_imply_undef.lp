coom_structure("product").
coom_feature("product","color","Color",1,1).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Green").

coom_behavior(0).
coom_context(0,"product").
coom_condition(0,0,"size=5").
coom_binary("size=5","size","=","5").
coom_path("size",0,"size").
coom_number("5",5).
coom_imply(0,"color","Red").
coom_path("color",0,"color").
coom_constant("Red").
