coom_structure("product").
coom_feature("product","a","num",1,1).
coom_range("product","a",1,1).
coom_feature("product","b","num",1,1).
coom_range("product","b",3,3).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"a+b<6").
coom_binary("a+b<6","a+b","<","6").
coom_binary("a+b","a","+","b").
coom_path("a",0,"a").
coom_path("b",0,"b").
coom_number("6",6).
