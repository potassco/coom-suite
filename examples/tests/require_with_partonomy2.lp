coom_structure("product").
coom_feature("product","bag","Bag",2,2).

coom_structure("Bag").
coom_feature("Bag","color","Color",1,1).
coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Yellow").

coom_behavior(0).
coom_context(0,"Bag").
coom_require(0,"color=Red").
coom_binary("color=Red","color","=","Red").
coom_path("color",0,"color").
coom_constant("Red").
