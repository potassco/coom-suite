coom_structure("product").
coom_feature("product","color","Color",1,1).
coom_feature("product","wheel","Wheel",1,1).

coom_structure("Wheel").
coom_feature("Wheel","size","Size",1,1).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Blue").

coom_enumeration("Size").
coom_option("Size", "Small").
coom_option("Size", "Large").

coom_behavior(0).
coom_context(0,"product").
coom_combinations(0,0,"root.color").
coom_combinations(0,1,"wheel.size").
coom_path("root.color",0,"root").
coom_path("root.color",1,"color").
coom_path("wheel.size",0,"wheel").
coom_path("wheel.size",1,"size").
coom_allow(0,(0,0),"Red").
coom_allow(0,(1,0),"Small").
coom_allow(0,(0,1),"Blue").
coom_allow(0,(1,1),"Large").

coom_behavior(1).
coom_context(1,"Wheel").
coom_combinations(1,0,"root.color").
coom_allow(1,(0,0),"Red").
coom_allow(1,(0,1),"Blue").
