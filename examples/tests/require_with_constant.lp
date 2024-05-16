coom_structure("product").
coom_feature("product","wheel","Wheel",1,1).

coom_enumeration("Wheel").
coom_option("Wheel", "W27").
coom_option("Wheel", "W28").

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"wheel=W28").
coom_binary("product","wheel=W28","wheel","=","W28").
coom_path("wheel",0,"wheel").
coom_constant("W28").
