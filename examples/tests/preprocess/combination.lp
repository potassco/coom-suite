coom_structure("product").
coom_feature("product","wheelSupport","Bool",1,1).
coom_feature("product","wheel","Wheel",1,1).

coom_enumeration("Wheel").
coom_option("Wheel", "W14").
coom_option("Wheel", "W16").
coom_option("Wheel", "W18").
coom_option("Wheel", "W20").

coom_behavior(0).
coom_context(0,"product").
coom_combinations(0,0,"wheelSupport").
coom_combinations(0,1,"Wheel").
coom_path("wheelSupport",0,"wheelSupport").
coom_path("Wheel",0,"wheel").
coom_allow(0,(0,0),"True").
coom_allow(0,(1,0),"W14").
coom_allow(0,(1,0),"W16").
coom_allow(0,(0,1),"False").
coom_allow(0,(1,1),"W18").
coom_allow(0,(1,1),"W20").
