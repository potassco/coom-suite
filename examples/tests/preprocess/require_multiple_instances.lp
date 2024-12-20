coom_structure("product").
coom_feature("product","wheel","Wheel",2,2).

coom_structure("Wheel").
coom_feature("Wheel","size","Size",1,1).

coom_enumeration("Size").
coom_option("Size","W27").
coom_option("Size","W28").

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"wheel.size=W28").
coom_binary("wheel.size=W28","wheel.size","=","W28").
coom_path("wheel.size",0,"wheel").
coom_path("wheel.size",1,"size").
coom_constant("W28").
