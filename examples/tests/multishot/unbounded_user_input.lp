% user input for objects of an unbounded feature: bags[1] is included and bags[3] has weight 5 (does not exist yet)
% the sum of the weights has to be at least 12 (minimal bound 1, bags[0] and bags[1])
coom_structure("product").
coom_feature("product","bags","Bag",0,#sup).

coom_structure("Bag").
coom_feature("Bag","weight","num",1,1).
coom_range("Bag","weight",0,10).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"sum(bags.weight)>=12").
coom_binary("sum(bags.weight)>=12","sum(bags.weight)",">=","12").
coom_function("product","sum(bags.weight)","sum","bags.weight").
coom_path("bags.weight",0,"bags").
coom_path("bags.weight",1,"weight").
coom_number("12",12).

coom_user_include("root.bags[1]").
coom_user_value("root.bags[3].weight[0]",5).
