coom_structure("product").
coom_feature("product","elements","Element",2,2).
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
coom_option("ElementType", "B").

coom_behavior(0).
coom_context(0,"Element").
coom_condition(0,0,"type=A").
coom_binary("type=A","type","=","A").
coom_path("type",0,"type").
coom_constant("A").
coom_require(0,"modules.type=I").
coom_binary("modules.type=I","modules.type","=","I").
coom_path("modules.type",0,"modules").
coom_path("modules.type",1,"type").
coom_constant("I").

coom_behavior(1).
coom_context(1,"Element").
coom_condition(1,0,"type=B").
coom_binary("type=B","type","=","B").
coom_path("type",0,"type").
coom_constant("B").
coom_require(1,"modules.type=II").
coom_binary("modules.type=II","modules.type","=","II").
coom_path("modules.type",0,"modules").
coom_path("modules.type",1,"type").
coom_constant("II").

coom_user_value("root.elements[0].type[0]","A").
coom_user_value("root.elements[1].type[0]","B").
coom_user_value("root.modules[0].type[0]","I").
coom_user_value("root.modules[1].type[0]","II").
