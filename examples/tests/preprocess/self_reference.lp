coom_structure("product").
coom_feature("product","left_bag","Bag",2,2).
coom_feature("product","right_bag","Bag",2,2).

coom_structure("Bag").
coom_reference("Bag","other_side","Bag",1,1).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"left_bag.other_side!=left_bag").
coom_binary("left_bag.other_side!=left_bag","left_bag.other_side","!=","left_bag").
coom_path("left_bag.other_side",0,"left_bag").
coom_path("left_bag.other_side",1,"other_side").
coom_path("left_bag",0,"left_bag").
