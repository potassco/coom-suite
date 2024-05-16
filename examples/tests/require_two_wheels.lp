coom_structure("product").
coom_feature("product","frontWheel","Wheel",1,1).
coom_feature("product","rearWheel","Wheel",1,1).

coom_enumeration("Wheel").
coom_attribute("Wheel","size","num").
coom_option("Wheel", "W27").
coom_attribute_value("Wheel","W27","size",27).
coom_option("Wheel", "W28").
coom_attribute_value("Wheel","W28","size",28).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"frontWheel.size=rearWheel.size").
coom_binary("product","frontWheel.size=rearWheel.size","frontWheel.size","=","rearWheel.size").
coom_path("frontWheel.size",0,"frontWheel").
coom_path("frontWheel.size",1,"size").
coom_path("rearWheel.size",0,"rearWheel").
coom_path("rearWheel.size",1,"size").
