coom_structure("product").
coom_feature("product","wheel","Wheel",2,2).

coom_structure("Wheel").
coom_feature("Wheel","size","Size",1,1).

coom_enumeration("Size").
coom_option("Size", "Small").
coom_option("Size", "Large").

coom_behavior(0).
coom_context(0,"product").
coom_combinations(0,0,"wheel.size").
coom_path("wheel.size",0,"wheel").
coom_path("wheel.size",1,"size").
coom_allow(0,(0,0),"Small").
coom_allow(0,(0,1),"Large").

coom_behavior(1).
coom_context(1,"product").
coom_combinations(1,0,"wheel.size").
coom_combinations(1,1,"wheel.size").
coom_allow(1,(0,0),"Small").
coom_allow(1,(0,0),"Large").
coom_allow(1,(1,0),"Small").
coom_allow(1,(1,0),"Large").
