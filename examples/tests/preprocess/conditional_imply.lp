coom_structure("product").
coom_feature("product","color","Color",1,1).
coom_feature("product","v","num",1,1).
coom_range("product","v",0,10).
coom_feature("product","x","num",1,1).
coom_range("product","x",0,100).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Green").

coom_behavior(0).
coom_context(0,"product").
coom_condition(0,0,"color=Red").
coom_binary("color=Red","color","=","Red").
coom_path("color",0,"color").
coom_constant("Red","str").
coom_imply(0,"x","v+0").
coom_path("x",0,"x").
coom_binary("v+0","v","+","0").
coom_path("v",0,"v").
coom_constant("0","int").

coom_behavior(1).
coom_context(1,"product").
coom_condition(1,0,"color=Green").
coom_binary("color=Green","color","=","Green").
coom_path("color",0,"color").
coom_constant("Green","str").
coom_imply(1,"x","v+38").
coom_path("x",0,"x").
coom_binary("v+38","v","+","38").
coom_path("v",0,"v").
coom_constant("38","int").
