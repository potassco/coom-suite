coom_structure("product").
coom_feature("product","bag","Bag",0,3).
coom_structure("Bag").

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"count(bag)<=2").
coom_binary("count(bag)<=2","count(bag)","<=","2").
coom_aggregate("product","count(bag)","count","bag").
coom_path("bag",0,"bag").
coom_constant("2",int).
