coom_structure("product").
coom_feature("product","elements","Element",1,1).
coom_feature("product","modules","Module",1,1).

coom_structure("Module").
coom_feature("Module","type","ModuleType",1,1).

coom_enumeration("ModuleType").
coom_option("ModuleType", "I").
coom_option("ModuleType", "II").

coom_structure("Element").
coom_reference("Element","modules","Module",1,1).

coom_behavior(0).
coom_context(0,"Element").
coom_require(0,"modules.type=I").
coom_binary("modules.type=I","modules.type","=","I").
coom_path("modules.type",0,"modules").
coom_path("modules.type",1,"type").
coom_constant("I").
