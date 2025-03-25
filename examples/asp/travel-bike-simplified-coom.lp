coom_structure("product").
coom_feature("product","totalVolume","num",1,1).
coom_range("product","totalVolume",0,200).
coom_feature("product","requestedVolume","num",1,1).
coom_range("product","requestedVolume",0,200).
coom_feature("product","carrier","Carrier",1,1).
coom_feature("product","frame","Frame",1,1).

coom_structure("Carrier").
coom_feature("Carrier","bag","Bag",0,3).

coom_structure("Frame").
coom_feature("Frame","bag","Bag",0,2).

coom_enumeration("Bag").
coom_attribute("Bag","volume","num").
coom_option("Bag", "B20").
coom_attribute_value("Bag","B20","volume",20).
coom_option("Bag", "B50").
coom_attribute_value("Bag","B50","volume",50).
coom_option("Bag", "B100").
coom_attribute_value("Bag","B100","volume",100).

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"count(carrier.bag)+count(frame.bag)<=4").
coom_binary("count(carrier.bag)+count(frame.bag)<=4","count(carrier.bag)+count(frame.bag)","<=","4").
coom_binary("count(carrier.bag)+count(frame.bag)","count(carrier.bag)","+","count(frame.bag)").
coom_function("product","count(carrier.bag)","count","carrier.bag").
coom_path("carrier.bag",0,"carrier").
coom_path("carrier.bag",1,"bag").
coom_function("product","count(frame.bag)","count","frame.bag").
coom_path("frame.bag",0,"frame").
coom_path("frame.bag",1,"bag").
coom_number("4",4).

coom_behavior(1).
coom_context(1,"product").
coom_require(1,"totalVolume=sum(carrier.bag.volume)+sum(frame.bag.volume)").
coom_binary("totalVolume=sum(carrier.bag.volume)+sum(frame.bag.volume)","totalVolume","=","sum(carrier.bag.volume)+sum(frame.bag.volume)").
coom_path("totalVolume",0,"totalVolume").
coom_binary("sum(carrier.bag.volume)+sum(frame.bag.volume)","sum(carrier.bag.volume)","+","sum(frame.bag.volume)").
coom_function("product","sum(carrier.bag.volume)","sum","carrier.bag.volume").
coom_path("carrier.bag.volume",0,"carrier").
coom_path("carrier.bag.volume",1,"bag").
coom_path("carrier.bag.volume",2,"volume").
coom_function("product","sum(frame.bag.volume)","sum","frame.bag.volume").
coom_path("frame.bag.volume",0,"frame").
coom_path("frame.bag.volume",1,"bag").
coom_path("frame.bag.volume",2,"volume").

coom_behavior(2).
coom_context(2,"product").
coom_require(2,"totalVolume>=requestedVolume").
coom_binary("totalVolume>=requestedVolume","totalVolume",">=","requestedVolume").
coom_path("totalVolume",0,"totalVolume").
coom_path("requestedVolume",0,"requestedVolume").
