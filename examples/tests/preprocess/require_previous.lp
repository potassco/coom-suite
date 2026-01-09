coom_structure("product").
coom_feature("product","semester","Semester",2,2).

coom_structure("Semester").
coom_feature("Semester","type","Type",1,1).

coom_enumeration("Type").
coom_option("Type", "Summer").
coom_option("Type", "Winter").

coom_behavior(0).
coom_context(0,"Semester").
coom_require(0,"previous.type!=type").
coom_binary("previous.type!=type","previous.type","!=","type").
coom_path("previous.type",0,"previous").
coom_path("previous.type",1,"type").
coom_path("type",0,"type").
