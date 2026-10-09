coom_structure("product").
coom_feature("product","color","Color",1,1).
coom_feature("product","size","Size",0,1).
coom_feature("product","material","Material",1,1).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Blue").

coom_enumeration("Size").
coom_option("Size", "Small").
coom_option("Size", "Large").

coom_enumeration("Material").
coom_option("Material", "Wood").
coom_option("Material", "Steel").

coom_behavior(0).
coom_context(0,"product").
coom_combinations(0,0,"color").
coom_combinations(0,1,"size").
coom_path("color",0,"color").
coom_path("size",0,"size").
coom_allow(0,(0,0),"Red").
coom_allow(0,(1,0),"Small").

coom_behavior(1).
coom_context(1,"product").
coom_combinations(1,0,"color").
coom_combinations(1,1,"material").
coom_path("material",0,"material").
coom_allow(1,(0,0),"Red").
coom_allow(1,(1,0),"Wood").
coom_allow(1,(0,1),"Blue").
coom_allow(1,(1,1),"Steel").
