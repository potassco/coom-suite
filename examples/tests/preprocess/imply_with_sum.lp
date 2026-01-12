coom_structure("product").
coom_feature("product","a","num",1,1).
coom_range("product","a",0,10).
coom_feature("product","b","num",2,2).
coom_range("product","b",1,3).

coom_behavior(0).
coom_context(0,"product").
coom_imply(0,"a","sum(b)").
coom_path("a",0,"a").
coom_function("product","sum(b)","sum","b").
coom_path("b",0,"b").
