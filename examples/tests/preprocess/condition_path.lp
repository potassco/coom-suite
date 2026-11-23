coom_structure("product").
coom_feature("product","b","Bool",1,1).
coom_feature("product","c","Bool",1,1).
coom_feature("product","x","num",1,1).
coom_range("product","x",0,2).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"c").
coom_path("c",0,"c").

coom_behavior(1).
coom_context(1,"product").
coom_condition(1,0,"b").
coom_path("b",0,"b").
coom_require(1,"x=2").
coom_binary("x=2","x","=","2").
coom_path("x",0,"x").
coom_number("2",2).
