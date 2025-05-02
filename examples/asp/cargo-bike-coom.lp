%%% COOM model
coom_structure("product").
coom_feature("product","totalVolume","num",1,1).
coom_range("product","totalVolume",0,200).
coom_feature("product","requestedVolume","num",1,1).
coom_range("product","requestedVolume",0,200).
coom_feature("product","bags","Bag",0,#sup).

coom_structure("Bag").
coom_feature("Bag","size","Size",1,1).

coom_enumeration("Color").
coom_option("Color", "Green").
coom_option("Color", "Blue").
coom_option("Color", "Red").

coom_enumeration("Size").
coom_attribute("Size","weight","num").
coom_attribute("Size","volume","num").
coom_option("Size", "small").
coom_attribute_value("Size","small","weight",10).
coom_attribute_value("Size","small","volume",12).
coom_option("Size", "medium").
coom_attribute_value("Size","medium","weight",15).
coom_attribute_value("Size","medium","volume",16).
coom_option("Size", "large").
coom_attribute_value("Size","large","weight",25).
coom_attribute_value("Size","large","volume",20).

coom_behavior(0).
coom_context(0,"product").
coom_explanation(0,"The total volume is equal to the sum of the volumes of all bags.").
coom_require(0,"totalVolume=sum(bags.size.volume)").
coom_binary("totalVolume=sum(bags.size.volume)","totalVolume","=","sum(bags.size.volume)").
coom_path("totalVolume",0,"totalVolume").
coom_function("product","sum(bags.size.volume)","sum","bags.size.volume").
coom_path("bags.size.volume",0,"bags").
coom_path("bags.size.volume",1,"size").
coom_path("bags.size.volume",2,"volume").

coom_behavior(1).
coom_context(1,"product").
coom_explanation(1,"The total volume must be greater than or equal to the requested volume.").
coom_require(1,"totalVolume>=requestedVolume").
coom_binary("totalVolume>=requestedVolume","totalVolume",">=","requestedVolume").
coom_path("totalVolume",0,"totalVolume").
coom_path("requestedVolume",0,"requestedVolume").
