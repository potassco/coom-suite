% user value for an object added at a later bound: bags[2] has weight 5 (bags[2] only exists from bound 3 on)
% the sum of the weights has to be at least 26 (minimal bound 4: 10+10+5+10, without the user value 3)
coom_structure("product").
coom_feature("product","total","num",1,1).
coom_range("product","total",0,100).
coom_feature("product","bags","Bag",0,#sup).

coom_structure("Bag").
coom_feature("Bag","weight","num",1,1).
coom_range("Bag","weight",0,10).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"total=sum(bags.weight)").
coom_binary("total=sum(bags.weight)","total","=","sum(bags.weight)").
coom_path("total",0,"total").
coom_function("product","sum(bags.weight)","sum","bags.weight").
coom_path("bags.weight",0,"bags").
coom_path("bags.weight",1,"weight").

coom_behavior(1).
coom_context(1,"product").
coom_require(1,"total>=26").
coom_binary("total>=26","total",">=","26").
coom_path("total",0,"total").
coom_number("26",26).

coom_user_value("root.bags[2].weight[0]",5).
