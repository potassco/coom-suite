coom_structure("product").
coom_feature("product","wheel","Wheel",2,2).

coom_structure("Wheel").
coom_feature("Wheel","size","Size",1,1).
coom_feature("Wheel","material","Material",1,1).

coom_enumeration("Size").
coom_option("Size", "W28").
coom_option("Size", "W30").

coom_enumeration("Material").
coom_option("Material", "Carbon").
coom_option("Material", "Aluminum").

coom_behavior(0).
coom_context(0,"Wheel").
coom_combinations(0,0,"size").
coom_combinations(0,1,"material").
coom_path("size",0,"size").
coom_path("material",0,"material").
coom_allow(0,(0,0),"W28").
coom_allow(0,(0,1),"W30").
coom_allow(0,(1,1),"Aluminum").

coom_behavior(1).
coom_context(1,"product").
coom_require(1,"wheel.size=wheel.size").
coom_binary("wheel.size=wheel.size","wheel.size","=","wheel.size").
coom_path("wheel.size",0,"wheel").
coom_path("wheel.size",1,"size").
coom_path("wheel.size",0,"wheel").
coom_path("wheel.size",1,"size").
