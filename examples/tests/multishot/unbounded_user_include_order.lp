% user include of bags[2] (instantiated at bound 0), at least two boxes are required (minimal bound 2)
% bags[1] is only added at bound 2 and then has to be included as well (only one model at bound 2)
coom_structure("product").
coom_feature("product","bags","Bag",0,#sup).
coom_feature("product","boxes","Box",0,#sup).

coom_structure("Bag").

coom_structure("Box").

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"count(boxes)>=2").
coom_binary("count(boxes)>=2","count(boxes)",">=","2").
coom_function("product","count(boxes)","count","boxes").
coom_path("boxes",0,"boxes").
coom_number("2",2).

coom_user_include("root.bags[2]").
