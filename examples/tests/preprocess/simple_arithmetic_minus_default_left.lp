coom_structure("product").
coom_feature("product","b","num",1,1).
coom_range("product","b",1,3).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"a-b=-2").
coom_binary("a-b=-2","a-b","=","-2").
coom_binary("a-b","a","-","b").
coom_path("a",0,"a").
coom_path("b",0,"b").
coom_unary("-2","-","2").
coom_number("2",2).
