coom_structure("product").
coom_feature("product","basket","Basket",1,1).

coom_structure("Basket").
coom_feature("Basket","color","Color",1,1).
coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Yellow").

coom_behavior(0).
coom_context(0,"Basket").
coom_require(0,"color=Red").
coom_binary("color=Red","color","=","Red").
coom_path("color",0,"color").
coom_constant("Red").
