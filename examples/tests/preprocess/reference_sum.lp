coom_structure("product").
coom_feature("product","modules","Module",2,2).
coom_feature("product","elements","Element",1,1).

coom_structure("Module").

coom_structure("Element").
coom_reference("Element","modules","Module",1,2).

coom_behavior(0).
coom_context(0,"Element").
coom_require(0,"count(modules)=2").
coom_binary("count(modules)=2","count(modules)","=","2").
coom_function("Element","count(modules)","count","modules").
coom_path("modules",0,"modules").
coom_number("2",2).
