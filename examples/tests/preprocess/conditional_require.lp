coom_structure("product").
coom_feature("product","wheel","Wheel",1,1).
coom_feature("product","wheelSupport","Bool",1,1).

coom_enumeration("Wheel").
coom_option("Wheel", "Small").
coom_option("Wheel", "Large").

coom_behavior(0).
coom_context(0,"product").
coom_condition(0,0,"wheelSupport=True").
coom_binary("wheelSupport=True","wheelSupport","=","True").
coom_path("wheelSupport",0,"wheelSupport").
coom_constant("True").
coom_require(0,"Wheel=Small").
coom_binary("Wheel=Small","Wheel","=","Small").
coom_path("Wheel",0,"wheel").
coom_constant("Small").
