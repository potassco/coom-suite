coom_structure("product").
coom_feature("product","bikes","Bike",2,2).

coom_structure("Bike").
coom_feature("Bike","bags","Bag",2,2).

coom_enumeration("Bag").
coom_option("Bag", "Small").
coom_option("Bag", "Big").

coom_behavior(0).
coom_context(0,"product").
coom_require(0,"2=count(bforbinbikes.bagsifb=Small)").
coom_binary("2=count(bforbinbikes.bagsifb=Small)","2","=","count(bforbinbikes.bagsifb=Small)").
coom_constant("2",int).
coom_aggregate("product","count(bforbinbikes.bagsifb=Small)","count").
coom_aggregate_set("product","count(bforbinbikes.bagsifb=Small)","bikes.bags").
coom_aggregate_comprehension("product","count(bforbinbikes.bagsifb=Small)","b","b").
coom_aggregate_condition("product","count(bforbinbikes.bagsifb=Small)","b=Small").
coom_path("b",0,"b").
coom_path("bikes.bags",0,"bikes").
coom_path("bikes.bags",1,"bags").
coom_binary("b=Small","b","=","Small").
coom_path("b",0,"b").
coom_constant("Small",str).
