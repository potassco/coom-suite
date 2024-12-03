coom_structure("product").
coom_feature("product","wheelSupport","bool",1,1).
coom_feature("product","wheel","Wheel",2,2).

coom_structure("Wheel").
coom_feature("Wheel","size","Size",1,1).

coom_enumeration("Size").
coom_option("Size", "W14").
coom_option("Size", "W16").
coom_option("Size", "W18").
coom_option("Size", "W20").

coom_behavior(0).
coom_context(0,"product").
coom_combinations(0,0,"wheelSupport").
coom_combinations(0,1,"wheel.size").
coom_path("wheelSupport",0,"wheelSupport").
coom_path("wheel.size",0,"wheel").
coom_path("wheel.size",1,"size").
coom_allow(0,(0,0),"True").
coom_allow(0,(1,0),"W14").
coom_allow(0,(1,0),"W16").
coom_allow(0,(0,1),"False").
coom_allow(0,(1,1),"W18").
coom_allow(0,(1,1),"W20").
