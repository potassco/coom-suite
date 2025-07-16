%%% COOM model
coom_structure("product").
coom_feature("product","totalWeight","num",1,1).
coom_range("product","totalWeight",1,10000).
coom_feature("product","maxWeight","num",1,1).
coom_range("product","maxWeight",0,10).
coom_feature("product","totalVolume","num",1,1).
coom_range("product","totalVolume",0,200).
coom_feature("product","requestedVolume","num",1,1).
coom_range("product","requestedVolume",0,200).
coom_feature("product","frontWheel","Wheel",1,1).
coom_feature("product","rearWheel","Wheel",1,1).
coom_feature("product","carrier","Carrier",1,1).
coom_feature("product","frame","Frame",1,1).
coom_feature("product","color","Color",1,1).

coom_structure("Carrier").
coom_feature("Carrier","bag","Bag",0,3).

coom_structure("Frame").
coom_feature("Frame","bag","Bag",0,2).

coom_structure("Bag").
coom_feature("Bag","capacity","Capacity",1,1).
coom_feature("Bag","material","Material",1,1).

coom_enumeration("Capacity").
coom_attribute("Capacity","volume","num").
coom_attribute("Capacity","weight","num").
coom_option("Capacity", "B10").
coom_attribute_value("Capacity","B10","volume",10).
coom_attribute_value("Capacity","B10","weight",100).
coom_option("Capacity", "B20").
coom_attribute_value("Capacity","B20","volume",20).
coom_attribute_value("Capacity","B20","weight",250).
coom_option("Capacity", "B50").
coom_attribute_value("Capacity","B50","volume",50).
coom_attribute_value("Capacity","B50","weight",600).
coom_option("Capacity", "B100").
coom_attribute_value("Capacity","B100","volume",100).
coom_attribute_value("Capacity","B100","weight",1200).

coom_enumeration("Material").
coom_option("Material", "Cotton").
coom_option("Material", "Leather").
coom_option("Material", "Polyester").

coom_enumeration("Wheel").
coom_attribute("Wheel","size","num").
coom_attribute("Wheel","weight","num").
coom_option("Wheel", "W20").
coom_attribute_value("Wheel","W20","size",20).
coom_attribute_value("Wheel","W20","weight",650).
coom_option("Wheel", "W22").
coom_attribute_value("Wheel","W22","size",22).
coom_attribute_value("Wheel","W22","weight",700).
coom_option("Wheel", "W24").
coom_attribute_value("Wheel","W24","size",24).
coom_attribute_value("Wheel","W24","weight",800).
coom_option("Wheel", "W26").
coom_attribute_value("Wheel","W26","size",26).
coom_attribute_value("Wheel","W26","weight",900).
coom_option("Wheel", "W28").
coom_attribute_value("Wheel","W28","size",28).
coom_attribute_value("Wheel","W28","weight",1000).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "Green").
coom_option("Color", "Yellow").
coom_option("Color", "Blue").

coom_behavior(0).
coom_context(0,"product").
coom_explanation(0,"The bike can have a maximum of 4 bags.").
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
coom_explanation(1,"The total weight is equal to the weight of the front wheel plus the weight of the rear wheel plus the sum of the weights of all bags on the carrier and the frame.").
coom_require(1,"totalWeight=frontWheel.weight+rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
coom_binary("totalWeight=frontWheel.weight+rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","totalWeight","=","frontWheel.weight+rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
coom_path("totalWeight",0,"totalWeight").
coom_binary("frontWheel.weight+rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","frontWheel.weight","+","rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
coom_binary("rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","rearWheel.weight","+","sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
coom_binary("sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","sum(carrier.bag.capacity.weight)","+","sum(frame.bag.capacity.weight)").
coom_path("frontWheel.weight",0,"frontWheel").
coom_path("frontWheel.weight",1,"weight").
coom_path("rearWheel.weight",0,"rearWheel").
coom_path("rearWheel.weight",1,"weight").
coom_function("product","sum(carrier.bag.capacity.weight)","sum","carrier.bag.capacity.weight").
coom_path("carrier.bag.capacity.weight",0,"carrier").
coom_path("carrier.bag.capacity.weight",1,"bag").
coom_path("carrier.bag.capacity.weight",2,"capacity").
coom_path("carrier.bag.capacity.weight",3,"weight").
coom_function("product","sum(frame.bag.capacity.weight)","sum","frame.bag.capacity.weight").
coom_path("frame.bag.capacity.weight",0,"frame").
coom_path("frame.bag.capacity.weight",1,"bag").
coom_path("frame.bag.capacity.weight",2,"capacity").
coom_path("frame.bag.capacity.weight",3,"weight").

coom_behavior(2).
coom_context(2,"product").
coom_explanation(2,"The total weight must not exceed the maximum weight.").
coom_require(2,"totalWeight<=maxWeight*1000").
coom_binary("totalWeight<=maxWeight*1000","totalWeight","<=","maxWeight*1000").
coom_path("totalWeight",0,"totalWeight").
coom_binary("maxWeight*1000","maxWeight","*","1000").
coom_path("maxWeight",0,"maxWeight").
coom_number("1000",1000).

coom_behavior(3).
coom_context(3,"product").
coom_explanation(3,"The total volume is equal to the sum of the volumes of all bags on the carrier and the frame.").
coom_require(3,"totalVolume=sum(carrier.bag.capacity.volume)+sum(frame.bag.capacity.volume)").
coom_binary("totalVolume=sum(carrier.bag.capacity.volume)+sum(frame.bag.capacity.volume)","totalVolume","=","sum(carrier.bag.capacity.volume)+sum(frame.bag.capacity.volume)").
coom_path("totalVolume",0,"totalVolume").
coom_binary("sum(carrier.bag.capacity.volume)+sum(frame.bag.capacity.volume)","sum(carrier.bag.capacity.volume)","+","sum(frame.bag.capacity.volume)").
coom_function("product","sum(carrier.bag.capacity.volume)","sum","carrier.bag.capacity.volume").
coom_path("carrier.bag.capacity.volume",0,"carrier").
coom_path("carrier.bag.capacity.volume",1,"bag").
coom_path("carrier.bag.capacity.volume",2,"capacity").
coom_path("carrier.bag.capacity.volume",3,"volume").
coom_function("product","sum(frame.bag.capacity.volume)","sum","frame.bag.capacity.volume").
coom_path("frame.bag.capacity.volume",0,"frame").
coom_path("frame.bag.capacity.volume",1,"bag").
coom_path("frame.bag.capacity.volume",2,"capacity").
coom_path("frame.bag.capacity.volume",3,"volume").

coom_behavior(4).
coom_context(4,"product").
coom_explanation(4,"The total volume must be greater than or equal to the requested volume.").
coom_require(4,"totalVolume>=requestedVolume").
coom_binary("totalVolume>=requestedVolume","totalVolume",">=","requestedVolume").
coom_path("totalVolume",0,"totalVolume").
coom_path("requestedVolume",0,"requestedVolume").

coom_behavior(5).
coom_context(5,"product").
coom_explanation(5,"If the color is red, then the size of the front wheel must be 20.").
coom_condition(5,0,"color=Red").
coom_binary("color=Red","color","=","Red").
coom_path("color",0,"color").
coom_constant("Red").
coom_require(5,"frontWheel.size=20").
coom_binary("frontWheel.size=20","frontWheel.size","=","20").
coom_path("frontWheel.size",0,"frontWheel").
coom_path("frontWheel.size",1,"size").
coom_number("20",20).

coom_behavior(6).
coom_context(6,"Bag").
coom_explanation(6,"If the material of the bag is leather, then the capacity must be B10.").
coom_condition(6,0,"material=Leather").
coom_binary("material=Leather","material","=","Leather").
coom_path("material",0,"material").
coom_constant("Leather").
coom_require(6,"capacity=B10").
coom_binary("capacity=B10","capacity","=","B10").
coom_path("capacity",0,"capacity").
coom_constant("B10").
