coom_structure("product").
coom_feature("product","a","num",1,1).
coom_range("product","a",1,3).
coom_feature("product","b","num",1,1).
coom_range("product","b",3,4).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"b-a>=3").
coom_binary("b-a>=3","b-a",">=","3").
coom_binary("b-a","b","-","a").
coom_path("b",0,"b").
coom_path("a",0,"a").
coom_number("3",3).
