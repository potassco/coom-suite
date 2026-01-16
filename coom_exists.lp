coom_structure("product").
coom_feature("product","modules","Module",2,2).

coom_enumeration("Module").
coom_option("Module", "BM1").
coom_option("Module", "BM2").
coom_option("Module", "Thesis").

coom_behavior(0).
coom_context(0,"product").
coom_alldiff(0,"modules").
coom_path("modules",0,"modules").

coom_behavior(1).
coom_context(1,"product").
coom_exists(1,"m","modules").
coom_path("modules",0,"modules").

coom_require(1,"m=Thesis").
coom_binary("m=Thesis","m","=","Thesis").
coom_path("m",0,"m").
coom_constant("Thesis").
