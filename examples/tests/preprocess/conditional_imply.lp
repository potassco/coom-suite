coom_structure("product").
coom_feature("product","color","Color",1,1).
coom_feature("product","option","num",1,1).
coom_range("product","option",1,2).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Blue").

coom_behavior(0).
coom_context(0,"product").
coom_condition(0,0,"color=Red").
coom_binary("color=Red","color","=","Red").
coom_path("color",0,"color").
coom_constant("Red").
coom_imply(0,"option","1").
coom_path("option",0,"option").
coom_number("1",1).

coom_behavior(1).
coom_context(1,"product").
coom_condition(1,0,"color=Blue").
coom_binary("color=Blue","color","=","Blue").
coom_path("color",0,"color").
coom_constant("Blue").
coom_imply(1,"option","2").
coom_path("option",0,"option").
coom_number("2",2).
