coom_structure("product").
coom_feature("product","x","num",1,1).
coom_range("product","x",0,9).
coom_feature("product","y","num",1,1).
coom_range("product","y",0,2).
coom_feature("product","z","num",1,1).
coom_range("product","z",0,2).

coom_behavior(0).
coom_context(0,"product").
coom_imply(0,"x","5").
coom_path("x",0,"x").
coom_number("5",5).

coom_behavior(1).
coom_context(1,"product").
coom_imply(1,"y","z").
coom_path("y",0,"y").
coom_path("z",0,"z").
