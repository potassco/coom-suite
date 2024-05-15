coom_structure("product").
coom_feature("product","color","Color",1,1).
coom_feature("product","basket","Basket",0,1).
coom_feature("product","saddle","Saddle",1,1).
coom_feature("product","frontWheel","Wheel",1,1).
coom_feature("product","rearWheel","Wheel",1,1).
coom_feature("product","carrier","Carrier",1,1).

coom_structure("Basket").
coom_feature("Basket","position","Position",1,1).
coom_feature("Basket","color","Color",1,1).

coom_structure("Carrier").
coom_feature("Carrier","bag","Bag",0,2).

coom_structure("Bag").
coom_feature("Bag","capacity","Capacity",1,1).
coom_feature("Bag","material","Material",1,1).

coom_enumeration("Color").
coom_option("Color", "Silver").
coom_option("Color", "White").
coom_option("Color", "Black").
coom_option("Color", "Blue").

coom_enumeration("Position").
coom_option("Position", "Front").
coom_option("Position", "Back").

coom_enumeration("Saddle").
coom_option("Saddle", "Standard").
coom_option("Saddle", "Comfort").
coom_option("Saddle", "Vintage").

coom_enumeration("Wheel").
coom_attribute("Wheel","size","num").
coom_option("Wheel", "W26").
coom_attribute_value("Wheel","W26","size",26).
coom_option("Wheel", "W27").
coom_attribute_value("Wheel","W27","size",27).
coom_option("Wheel", "W28").
coom_attribute_value("Wheel","W28","size",28).
coom_option("Wheel", "W29").
coom_attribute_value("Wheel","W29","size",29).

coom_enumeration("Capacity").
coom_attribute("Capacity","volume","num").
coom_option("Capacity", "B10").
coom_attribute_value("Capacity","B10","volume",10).
coom_option("Capacity", "B20").
coom_attribute_value("Capacity","B20","volume",20).
coom_option("Capacity", "B50").
coom_attribute_value("Capacity","B50","volume",50).
coom_option("Capacity", "B100").
coom_attribute_value("Capacity","B100","volume",100).

coom_enumeration("Material").
coom_option("Material", "Cotton").
coom_option("Material", "Leather").
coom_option("Material", "Polyester").

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"color=basket.color").
coom_binary("product","color=basket.color","color","=","basket.color").
coom_path("color",0,"color").
coom_path("basket.color",0,"basket").
coom_path("basket.color",1,"color").

coom_behavior(1).
coom_context(1,"product").
coom_condition(1,"basket.position=Front").
coom_binary("product","basket.position=Front","basket.position","=","Front").
coom_path("basket.position",0,"basket").
coom_path("basket.position",1,"position").
coom_constant("Front").
coom_require(1,"frontWheel.size<29").
coom_binary("product","frontWheel.size<29","frontWheel.size","<","29").
coom_path("frontWheel.size",0,"frontWheel").
coom_path("frontWheel.size",1,"size").
coom_number("29",29).

coom_behavior(2).
coom_context(2,"product").
coom_condition(2,"carrier.bag.capacity.volume=100").
coom_binary("product","carrier.bag.capacity.volume=100","carrier.bag.capacity.volume","=","100").
coom_path("carrier.bag.capacity.volume",0,"carrier").
coom_path("carrier.bag.capacity.volume",1,"bag").
coom_path("carrier.bag.capacity.volume",2,"capacity").
coom_path("carrier.bag.capacity.volume",3,"volume").
coom_number("100",100).
coom_require(2,"rearWheel.size>=28").
coom_binary("product","rearWheel.size>=28","rearWheel.size",">=","28").
coom_path("rearWheel.size",0,"rearWheel").
coom_path("rearWheel.size",1,"size").
coom_number("28",28).

coom_behavior(3).
coom_context(3,"product").
coom_condition(3,"saddle=Vintage").
coom_binary("product","saddle=Vintage","saddle","=","Vintage").
coom_path("saddle",0,"saddle").
coom_constant("Vintage").
coom_require(3,"carrier.bag.material=Leather").
coom_binary("product","carrier.bag.material=Leather","carrier.bag.material","=","Leather").
coom_path("carrier.bag.material",0,"carrier").
coom_path("carrier.bag.material",1,"bag").
coom_path("carrier.bag.material",2,"material").
coom_constant("Leather").

coom_behavior(4).
coom_context(4,"product").
coom_require(4,"frontWheel.size=rearWheel.size").
coom_binary("product","frontWheel.size=rearWheel.size","frontWheel.size","=","rearWheel.size").
coom_path("frontWheel.size",0,"frontWheel").
coom_path("frontWheel.size",1,"size").
coom_path("rearWheel.size",0,"rearWheel").
coom_path("rearWheel.size",1,"size").

coom_behavior(5).
coom_context(5,"Bag").
coom_combinations(5,0,"material").
coom_combinations(5,1,"capacity").
coom_path("material",0,"material").
coom_path("capacity",0,"capacity").
coom_allow(5,(0,0),"Leather").
coom_allow(5,(1,0),"B10").
coom_allow(5,(0,1),"Cotton").
coom_allow(5,(1,1),"B20").
coom_allow(5,(1,1),"B50").
coom_allow(5,(0,2),"Polyester").
coom_allow(5,(1,2),"B20").
coom_allow(5,(1,2),"B50").
coom_allow(5,(1,2),"B100").
