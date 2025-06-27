coom_structure("product").
coom_feature("product","color","Color",1,1).
coom_feature("product","size","Size",1,1).
coom_feature("product","material","Material",1,1).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Green").

coom_enumeration("Size").
coom_option("Size", "Small").
coom_option("Size", "Medium").

coom_enumeration("Material").
coom_option("Material", "Cotton").
coom_option("Material", "Polyester").

coom_behavior(0).
coom_context(0,"product").
coom_condition(0,0,"size=Small").
coom_binary("size=Small","size","=","Small").
coom_path("size",0,"size").
coom_constant("Small").
coom_condition(0,1,"material=Cotton").
coom_binary("material=Cotton","material","=","Cotton").
coom_path("material",0,"material").
coom_constant("Cotton").
coom_require(0,"color=Red").
coom_binary("color=Red","color","=","Red").
coom_path("color",0,"color").
coom_constant("Red").
