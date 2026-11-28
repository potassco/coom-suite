% every bag has weight 3 (local constraint), their sum has to be at least 9 (minimal bound 3)
% number("1",1) of the local constraints is only added at bound 1 (no other number 1 occurs)
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
coom_require(1,"total>=9").
coom_binary("total>=9","total",">=","9").
coom_path("total",0,"total").
coom_number("9",9).

coom_behavior(2).
coom_context(2,"Bag").
coom_require(2,"weight=3").
coom_binary("weight=3","weight","=","3").
coom_path("weight",0,"weight").
coom_number("3",3).
