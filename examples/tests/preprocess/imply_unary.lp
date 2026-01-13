coom_structure("product").
coom_feature("product","a","num",1,1).
coom_range("product","a",-5,5).
coom_feature("product","b","num",1,1).
coom_range("product","b",1,3).

coom_behavior(0).
coom_context(0,"product").
coom_imply(0,"a","-b").
coom_path("a",0,"a").
coom_path("b",0,"b").
coom_unary("-b","-","b").
