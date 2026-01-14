coom_structure("product").
coom_feature("product","modules","Module",1,1).

coom_enumeration("Module").
coom_attribute("Module","ects","num").
coom_attribute("Module","group","str").
coom_option("Module", "A1").
coom_attribute_value("Module","A1","ects",6).
coom_attribute_value("Module","A1","group","A").
coom_option("Module", "A2").
coom_attribute_value("Module","A2","ects",9).
coom_attribute_value("Module","A2","group","A").
coom_option("Module", "B1").
coom_attribute_value("Module","B1","ects",9).
coom_attribute_value("Module","B1","group","B").

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"7<=min(m.ectsforminmodulesifm.group=A)").
coom_binary("7<=min(m.ectsforminmodulesifm.group=A)","7","<=","min(m.ectsforminmodulesifm.group=A)").
coom_constant("7",int).
coom_aggregate("product","min(m.ectsforminmodulesifm.group=A)","min").
coom_aggregate_set("product","min(m.ectsforminmodulesifm.group=A)","modules").
coom_aggregate_comprehension("product","min(m.ectsforminmodulesifm.group=A)","m.ects","m").
coom_aggregate_condition("product","min(m.ectsforminmodulesifm.group=A)","m.group=A").
coom_path("m.ects",0,"m").
coom_path("m.ects",1,"ects").
coom_path("modules",0,"modules").
coom_binary("m.group=A","m.group","=","A").
coom_path("m.group",0,"m").
coom_path("m.group",1,"group").
coom_constant("A",str).
