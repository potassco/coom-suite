coom_structure("product").
coom_feature("product","bikes","Bike",2,2).

coom_structure("Bike").
coom_feature("Bike","frame","Frame",1,1).
coom_feature("Bike","saddle","Saddle",1,1).

coom_structure("Frame").
coom_reference("Frame","saddle","Saddle",1,1).

coom_structure("Saddle").
coom_reference("Saddle","frame","Frame",1,1).

coom_behavior(0).
coom_context(0,"Bike").
coom_require(0,"frame.saddle._parent=this").
coom_binary("frame.saddle._parent=this","frame.saddle._parent","=","this").
coom_path("frame.saddle._parent",0,"frame").
coom_path("frame.saddle._parent",1,"saddle").
coom_path("frame.saddle._parent",2,"_parent").
coom_path("this",0,"this").
