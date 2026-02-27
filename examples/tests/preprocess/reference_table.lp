coom_structure("product").
coom_feature("product","elements","Element",1,1).
coom_feature("product","modules","Module",2,2).

coom_structure("Module").
coom_feature("Module","type","ModuleType",1,1).

coom_enumeration("ModuleType").
coom_option("ModuleType", "I").
coom_option("ModuleType", "II").

coom_structure("Element").
coom_reference("Element","modules","Module",1,1).
coom_feature("Element","type","ElementType",1,1).

coom_enumeration("ElementType").
coom_option("ElementType", "A").

coom_behavior(0).
coom_context(0,"Element").
coom_combinations(0,0,"type").
coom_combinations(0,1,"modules.type").
coom_path("type",0,"type").
coom_path("modules.type",0,"modules").
coom_path("modules.type",1,"type").
coom_allow(0,(0,0),"A").
coom_allow(0,(1,0),"I").
