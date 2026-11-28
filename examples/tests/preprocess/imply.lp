coom_structure("product").
coom_feature("product","v","num",1,1).
coom_range("product","v",0,10).
coom_feature("product","x","num",1,1).
coom_range("product","x",0,100).

coom_behavior(0).
coom_context(0,"product").
coom_imply(0,"x","v+5").
coom_path("x",0,"x").
coom_binary("v+5","v","+","5").
coom_path("v",0,"v").
coom_constant("5","int").
