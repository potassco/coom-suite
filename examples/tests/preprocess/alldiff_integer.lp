coom_structure("product").
coom_feature("product","semester","Semester",4,4).

coom_structure("Semester").
coom_feature("Semester","id","num",1,1).
coom_range("Semester","id",1,4).

coom_behavior(0).
coom_context(0,"product").
coom_alldiff(0,"semester.id").
coom_path("semester.id",0,"semester").
coom_path("semester.id",1,"id").
