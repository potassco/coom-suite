coom_structure("product").
coom_feature("product","modules","Module",2,2).

coom_enumeration("Module").
coom_attribute("Module","ects","num").
coom_option("Module", "A").
coom_attribute_value("Module","A","ects",6).
coom_option("Module", "B").
coom_attribute_value("Module","B","ects",9).
coom_option("Module", "C").
coom_attribute_value("Module","C","ects",3).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"12=sum(m.ectsforminmodules)").
coom_binary("12=sum(m.ectsforminmodules)","12","=","sum(m.ectsforminmodules)").
coom_constant("12",int).
coom_aggregate("product","sum(m.ectsforminmodules)","sum").
coom_aggregate_set("product","sum(m.ectsforminmodules)","modules").
coom_aggregate_comprehension("product","sum(m.ectsforminmodules)","m.ects","m").
coom_path("m.ects",0,"m").
coom_path("m.ects",1,"ects").
coom_path("modules",0,"modules").
