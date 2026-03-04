coom_structure("product").
coom_feature("product","wheel","Wheel",1,1).

coom_enumeration("Wheel").
coom_attribute("Wheel","size","num").
coom_option("Wheel", "W27").
coom_attribute_value("Wheel","W27","size",27).
coom_option("Wheel", "W28").
coom_attribute_value("Wheel","W28","size",28).

coom_behavior(0).
coom_context(0,"product").
coom_imply(0,"wheel.size","27").
coom_path("wheel.size",0,"wheel").
coom_path("wheel.size",1,"size").
coom_number("27",27).
