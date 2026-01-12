coom_structure("product").
coom_feature("product","rack","Rack",1,1).
coom_feature("product","module","Module",0,#sup).
coom_feature("product","element","Element",1,#sup).

coom_structure("Rack").
coom_reference("Rack","element","Element",1,1).

coom_structure("Module").
coom_feature("Module","type","ModuleType",1,1).

coom_structure("Element").
coom_feature("Element","type","ElementType",1,1).
coom_reference("Element","modules","Module",1,2).

coom_enumeration("ModuleType").
coom_option("ModuleType", "I").
coom_option("ModuleType", "II").

coom_enumeration("ElementType").
coom_option("ElementType", "A").
coom_option("ElementType", "B").

coom_behavior(0).
coom_context(0,"Element").
coom_condition(0,0,"type=A").
coom_binary("type=A","type","=","A").
coom_path("type",0,"type").
coom_constant("A").
coom_require(0,"count(modules)=1").
coom_binary("count(modules)=1","count(modules)","=","1").
coom_function("Element","count(modules)","count","modules").
coom_path("modules",0,"modules").
coom_number("1",1).

coom_behavior(1).
coom_context(1,"Rack").
coom_require(1,"element.type=A").
coom_binary("element.type=A","element.type","=","A").
coom_path("element.type",0,"element").
coom_path("element.type",1,"type").
coom_constant("A").
