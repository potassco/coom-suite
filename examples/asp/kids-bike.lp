coom_structure("product").
coom_feature("product","color","Color",1,1).
coom_feature("product","wheelSupport","bool",1,1).
coom_feature("product","frontWheel","Wheel",1,1).
coom_feature("product","rearWheel","Wheel",1,1).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Green").
coom_option("Color", "Yellow").
coom_option("Color", "Blue").

coom_enumeration("Wheel").
coom_attribute("Wheel","size","num").
coom_option("Wheel", "W14").
coom_attribute_value("Wheel","W14","size",14).
coom_option("Wheel", "W16").
coom_attribute_value("Wheel","W16","size",16).
coom_option("Wheel", "W18").
coom_attribute_value("Wheel","W18","size",18).
coom_option("Wheel", "W20").
coom_attribute_value("Wheel","W20","size",20).

coom_behavior(0).
coom_context(0,"product").
coom_condition(0,"color=Yellow").
coom_binary("product","color=Yellow","color","=","Yellow").
coom_path("color",0,"color").
coom_constant("Yellow").
coom_require(0,"frontWheel.size>16").
coom_binary("product","frontWheel.size>16","frontWheel.size",">","16").
coom_path("frontWheel.size",0,"frontWheel").
coom_path("frontWheel.size",1,"size").
coom_number("16",16).

coom_behavior(1).
coom_context(1,"product").
coom_combinations(1,0,"wheelSupport").
coom_combinations(1,1,"rearWheel").
coom_path("wheelSupport",0,"wheelSupport").
coom_path("rearWheel",0,"rearWheel").
coom_allow(1,(0,0),"True").
coom_allow(1,(1,0),"W14").
coom_allow(1,(1,0),"W16").
coom_allow(1,(0,1),"False").
coom_allow(1,(1,1),"W18").
coom_allow(1,(1,1),"W20").

coom_behavior(2).
coom_context(2,"product").
coom_require(2,"frontWheel.size=rearWheel.size").
coom_binary("product","frontWheel.size=rearWheel.size","frontWheel.size","=","rearWheel.size").
coom_path("frontWheel.size",0,"frontWheel").
coom_path("frontWheel.size",1,"size").
coom_path("rearWheel.size",0,"rearWheel").
coom_path("rearWheel.size",1,"size").
