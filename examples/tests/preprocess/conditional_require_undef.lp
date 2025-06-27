coom_structure("product").
coom_feature("product","Size","size",1,1).
coom_enumeration("Size").
coom_option("Size","Small").
coom_option("Size","Big").

coom_behavior(("product",0)).
coom_condition(("product",0),0,"color=Silver").
coom_binary("color=Silver","color","=","Silver").
coom_path("color",0,"color").
coom_constant("Silver").
coom_require(("product",0),"size=Big").
coom_binary("size=Big","size","=","Big").
coom_path("size",0,"size").
coom_constant("Big").
