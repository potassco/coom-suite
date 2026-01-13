coom_structure("product").
coom_feature("product","bags","Bag",0,#sup).

coom_enumeration("Bag").
coom_option("Bag", "Small").
coom_option("Bag", "Medium").
coom_option("Bag", "Large").

coom_behavior(0).
coom_context(0,"product").
coom_minimize(0,0,"count(bags)").
coom_aggregate("product","count(bags)","count","bags").
coom_path("bags",0,"bags").
