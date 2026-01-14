coom_structure("product").
coom_feature("product","bikes","Bike",3,3).

coom_structure("Bike").
coom_feature("Bike","bags","Bag",0,2).

coom_structure("Bag").

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"4=count(bforbinbikes.frame.bags)").
coom_binary("4=count(bforbinbikes.frame.bags)","4","=","count(bforbinbikes.frame.bags)").
coom_constant("4",int).
coom_aggregate("product","count(bforbinbikes.frame.bags)","count").
coom_aggregate_set("product","count(bforbinbikes.frame.bags)","bikes.frame.bags").
coom_aggregate_comprehension("product","count(bforbinbikes.frame.bags)","b","b").
coom_path("b",0,"b").
coom_path("bikes.frame.bags",0,"bikes").
coom_path("bikes.frame.bags",1,"frame").
coom_path("bikes.frame.bags",2,"bags").
