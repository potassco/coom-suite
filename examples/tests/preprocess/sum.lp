coom_structure("product").
coom_feature("product","x","num",0,3).
coom_range("product","x",0,10).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"sum(x)<=10").
coom_binary("sum(x)<=10","sum(x)","<=","10").
coom_function("product","sum(x)","sum","x").
coom_path("x",0,"x").
coom_constant("10",int).
