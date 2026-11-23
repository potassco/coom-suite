% every bag has to be big, big bags have v=0 and the default of w is v+1 (so w=1), the sum of w has to be at least 6
% minimal bound 6 (3 if the condition on the Bool path is dropped, 1 if the default is dropped)
coom_structure("product").
coom_feature("product","bags","Bag",0,#sup).

coom_structure("Bag").
coom_feature("Bag","big","Bool",1,1).
coom_feature("Bag","v","num",1,1).
coom_range("Bag","v",0,1).
coom_feature("Bag","w","num",1,1).
coom_range("Bag","w",0,9).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"sum(bags.w)>=6").
coom_binary("sum(bags.w)>=6","sum(bags.w)",">=","6").
coom_function("product","sum(bags.w)","sum","bags.w").
coom_path("bags.w",0,"bags").
coom_path("bags.w",1,"w").
coom_number("6",6).

coom_behavior(1).
coom_context(1,"Bag").
coom_require(1,"big").
coom_path("big",0,"big").

coom_behavior(2).
coom_context(2,"Bag").
coom_condition(2,0,"big").
coom_path("big",0,"big").
coom_imply(2,"v","0").
coom_path("v",0,"v").
coom_number("0",0).

coom_behavior(3).
coom_context(3,"Bag").
coom_default(3,"w","v+1").
coom_path("w",0,"w").
coom_binary("v+1","v","+","1").
coom_path("v",0,"v").
coom_number("1",1).
