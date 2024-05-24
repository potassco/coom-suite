% Original "COOM" fact format describing the structure of the model
structure("product").
feature("product","totalWeight","num",1,1).
range("product","totalWeight",1,10000).
feature("product","maxWeight","num",1,1).
range("product","maxWeight",1,10).
feature("product","totalVolume","num",1,1).
range("product","totalVolume",0,200).
feature("product","requestedVolume","num",1,1).
range("product","requestedVolume",0,200).
feature("product","frontWheel","Wheel",1,1).
feature("product","rearWheel","Wheel",1,1).
feature("product","frame","Frame",1,1).
feature("product","carrier","Carrier",1,1).
feature("product","color","Color",1,1).

structure("Carrier").
feature("Carrier","bag","Bag",0,3).

structure("Frame").
feature("Frame","bag","Bag",0,2).

structure("Bag").
feature("Bag","capacity","Capacity",1,1).
feature("Bag","material","Material",1,1).

enumeration("Capacity").
attribute("Capacity","volume","num").
attribute("Capacity","weight","num").
option("Capacity", "B10").
attribute_value("Capacity","B10","volume",10).
attribute_value("Capacity","B10","weight",100).
option("Capacity", "B20").
attribute_value("Capacity","B20","volume",20).
attribute_value("Capacity","B20","weight",250).
option("Capacity", "B50").
attribute_value("Capacity","B50","volume",50).
attribute_value("Capacity","B50","weight",600).
option("Capacity", "B100").
attribute_value("Capacity","B100","volume",100).
attribute_value("Capacity","B100","weight",1200).

enumeration("Material").
option("Material", "Cotton").
option("Material", "Leather").
option("Material", "Polyester").

enumeration("Wheel").
attribute("Wheel","size","num").
attribute("Wheel","weight","num").
option("Wheel", "W20").
attribute_value("Wheel","W20","size",20).
attribute_value("Wheel","W20","weight",650).
option("Wheel", "W22").
attribute_value("Wheel","W22","size",22).
attribute_value("Wheel","W22","weight",700).
option("Wheel", "W24").
attribute_value("Wheel","W24","size",24).
attribute_value("Wheel","W24","weight",800).
option("Wheel", "W26").
attribute_value("Wheel","W26","size",26).
attribute_value("Wheel","W26","weight",900).
option("Wheel", "W28").
attribute_value("Wheel","W28","size",28).
attribute_value("Wheel","W28","weight",1000).

enumeration("Color").
option("Color", "Red").
option("Color", "Green").
option("Color", "Yellow").
option("Color", "Blue").

% Complete generated instance tree
type("root","product").

type("root.totalWeight[0]","num").
parent("root.totalWeight[0]","root").
feature("root.totalWeight[0]","totalWeight").

type("root.maxWeight[0]","num").
parent("root.maxWeight[0]","root").
feature("root.maxWeight[0]","maxWeight").

type("root.totalVolume[0]","num").
parent("root.totalVolume[0]","root").
feature("root.totalVolume[0]","totalVolume").

type("root.requestedVolume[0]","num").
parent("root.requestedVolume[0]","root").
feature("root.requestedVolume[0]","requestedVolume").

type("root.carrier[0]","Carrier").
index("root.carrier[0]",0).
parent("root.carrier[0]", "root").
feature("root.carrier[0]","carrier").

type("root.frame[0]","Frame").
index("root.frame[0]",0).
parent("root.frame[0]", "root").
feature("root.frame[0]","frame").

type("root.carrier[0].bag[0]","Bag").
index("root.carrier[0].bag[0]",0).
parent("root.carrier[0].bag[0]", "root.carrier[0]").
feature("root.carrier[0].bag[0]","bag").

type("root.carrier[0].bag[1]","Bag").
index("root.carrier[0].bag[1]",1).
parent("root.carrier[0].bag[1]", "root.carrier[0]").
feature("root.carrier[0].bag[1]","bag").

type("root.carrier[0].bag[2]","Bag").
index("root.carrier[0].bag[2]",2).
parent("root.carrier[0].bag[2]", "root.carrier[0]").
feature("root.carrier[0].bag[2]","bag").

type("root.frame[0].bag[0]","Bag").
index("root.frame[0].bag[0]",0).
parent("root.frame[0].bag[0]", "root.frame[0]").
feature("root.frame[0].bag[0]","bag").

type("root.frame[0].bag[1]","Bag").
index("root.frame[0].bag[1]",1).
parent("root.frame[0].bag[1]", "root.frame[0]").
feature("root.frame[0].bag[1]","bag").

type("root.frontWheel[0]","Wheel").
parent("root.frontWheel[0]", "root").
feature("root.frontWheel[0]","frontWheel").

type("root.frontWheel[0].size[0]","size").
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").
isnumeric("root.frontWheel[0].size[0]").

type("root.frontWheel[0].weight[0]","weight").
parent("root.frontWheel[0].weight[0]","root.frontWheel[0]").
isnumeric("root.frontWheel[0].weight[0]").

type("root.rearWheel[0]","Wheel").
parent("root.rearWheel[0]", "root").
feature("root.rearWheel[0]","rearWheel").

type("root.rearWheel[0].size[0]","size").
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").
isnumeric("root.rearWheel[0].size[0]").

type("root.rearWheel[0].weight[0]","weight").
parent("root.rearWheel[0].weight[0]","root.rearWheel[0]").
isnumeric("root.rearWheel[0].weight[0]").

type("root.color[0]","Color").
parent("root.color[0]", "root").
feature("root.color[0]","color").

type("root.carrier[0].bag[0].capacity[0]","Capacity").
parent("root.carrier[0].bag[0].capacity[0]", "root.carrier[0].bag[0]").
feature("root.carrier[0].bag[0].capacity[0]","capacity").

type("root.carrier[0].bag[0].capacity[0].volume[0]","volume").
parent("root.carrier[0].bag[0].capacity[0].volume[0]","root.carrier[0].bag[0].capacity[0]").
isnumeric("root.carrier[0].bag[0].capacity[0].volume[0]").

type("root.carrier[0].bag[0].capacity[0].weight[0]","weight").
parent("root.carrier[0].bag[0].capacity[0].weight[0]","root.carrier[0].bag[0].capacity[0]").
isnumeric("root.carrier[0].bag[0].capacity[0].weight[0]").

type("root.carrier[0].bag[1].capacity[0]","Capacity").
parent("root.carrier[0].bag[1].capacity[0]", "root.carrier[0].bag[1]").
feature("root.carrier[0].bag[1].capacity[0]","capacity").

type("root.carrier[0].bag[1].capacity[0].volume[0]","volume").
parent("root.carrier[0].bag[1].capacity[0].volume[0]","root.carrier[0].bag[1].capacity[0]").
isnumeric("root.carrier[0].bag[1].capacity[0].volume[0]").

type("root.carrier[0].bag[1].capacity[0].weight[0]","weight").
parent("root.carrier[0].bag[1].capacity[0].weight[0]","root.carrier[0].bag[1].capacity[0]").
isnumeric("root.carrier[0].bag[1].capacity[0].weight[0]").

type("root.carrier[0].bag[2].capacity[0]","Capacity").
parent("root.carrier[0].bag[2].capacity[0]", "root.carrier[0].bag[2]").
feature("root.carrier[0].bag[2].capacity[0]","capacity").

type("root.carrier[0].bag[2].capacity[0].volume[0]","volume").
parent("root.carrier[0].bag[2].capacity[0].volume[0]","root.carrier[0].bag[2].capacity[0]").
isnumeric("root.carrier[0].bag[2].capacity[0].volume[0]").

type("root.carrier[0].bag[2].capacity[0].weight[0]","weight").
parent("root.carrier[0].bag[2].capacity[0].weight[0]","root.carrier[0].bag[2].capacity[0]").
isnumeric("root.carrier[0].bag[2].capacity[0].weight[0]").

type("root.carrier[0].bag[0].material[0]","Material").
parent("root.carrier[0].bag[0].material[0]", "root.carrier[0].bag[0]").
feature("root.carrier[0].bag[0].material[0]","material").

type("root.carrier[0].bag[1].material[0]","Material").
parent("root.carrier[0].bag[1].material[0]", "root.carrier[0].bag[1]").
feature("root.carrier[0].bag[1].material[0]","material").

type("root.carrier[0].bag[2].material[0]","Material").
parent("root.carrier[0].bag[2].material[0]", "root.carrier[0].bag[2]").
feature("root.carrier[0].bag[2].material[0]","material").

type("root.frame[0].bag[0].capacity[0]","Capacity").
parent("root.frame[0].bag[0].capacity[0]", "root.frame[0].bag[0]").
feature("root.frame[0].bag[0].capacity[0]","capacity").

type("root.frame[0].bag[0].capacity[0].volume[0]","volume").
parent("root.frame[0].bag[0].capacity[0].volume[0]","root.frame[0].bag[0].capacity[0]").
isnumeric("root.frame[0].bag[0].capacity[0].volume[0]").

type("root.frame[0].bag[0].capacity[0].weight[0]","weight").
parent("root.frame[0].bag[0].capacity[0].weight[0]","root.frame[0].bag[0].capacity[0]").
isnumeric("root.frame[0].bag[0].capacity[0].weight[0]").

type("root.frame[0].bag[1].capacity[0]","Capacity").
parent("root.frame[0].bag[1].capacity[0]", "root.frame[0].bag[1]").
feature("root.frame[0].bag[1].capacity[0]","capacity").

type("root.frame[0].bag[1].capacity[0].volume[0]","volume").
parent("root.frame[0].bag[1].capacity[0].volume[0]","root.frame[0].bag[1].capacity[0]").
isnumeric("root.frame[0].bag[1].capacity[0].volume[0]").

type("root.frame[0].bag[1].capacity[0].weight[0]","weight").
parent("root.frame[0].bag[1].capacity[0].weight[0]","root.frame[0].bag[1].capacity[0]").
isnumeric("root.frame[0].bag[1].capacity[0].weight[0]").

type("root.frame[0].bag[0].material[0]","Material").
parent("root.frame[0].bag[0].material[0]", "root.frame[0].bag[0]").
feature("root.frame[0].bag[0].material[0]","material").

type("root.frame[0].bag[1].material[0]","Material").
parent("root.frame[0].bag[1].material[0]", "root.frame[0].bag[1]").
feature("root.frame[0].bag[1].material[0]","material").

% Instantiated constraints on complete instance tree
constraint((0,"root")).
require((0,"root"),"count(root.carrier.bag)+count(root.frame.bag)<=4").
binary("count(root.carrier.bag)+count(root.frame.bag)<=4","count(root.carrier.bag)+count(root.frame.bag)","<=","4").
binary("count(root.carrier.bag)+count(root.frame.bag)","count(root.carrier.bag)","+","count(root.frame.bag)").
function("count(root.carrier.bag)","count","root.carrier.bag").
function_path("root.carrier.bag","root.carrier[0].bag[0]").
function_path("root.carrier.bag","root.carrier[0].bag[1]").
function_path("root.carrier.bag","root.carrier[0].bag[2]").
function("count(root.frame.bag)","count","root.frame.bag").
function_path("root.frame.bag","root.frame[0].bag[0]").
function_path("root.frame.bag","root.frame[0].bag[1]").
number("4",4).

constraint((1,"root")).
imply("root.totalWeight[0]","root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","root.frontWheel[0].weight[0]","+","root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","root.rearWheel[0].weight[0]","+","sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","sum(root.carrier.bag.capacity.weight)","+","sum(root.frame.bag.capacity.weight)").
function("sum(root.carrier.bag.capacity.weight)","sum","root.carrier.bag.capacity.weight").
function_path("root.carrier.bag.capacity.weight","root.carrier[0].bag[0].capacity[0].weight[0]").
function_path("root.carrier.bag.capacity.weight","root.carrier[0].bag[1].capacity[0].weight[0]").
function_path("root.carrier.bag.capacity.weight","root.carrier[0].bag[2].capacity[0].weight[0]").
function("sum(root.frame.bag.capacity.weight)","sum","root.frame.bag.capacity.weight").
function_path("root.frame.bag.capacity.weight","root.frame[0].bag[0].capacity[0].weight[0]").
function_path("root.frame.bag.capacity.weight","root.frame[0].bag[1].capacity[0].weight[0]").

constraint((2,"root")).
require((2,"root"),"root.totalWeight[0]<=root.maxWeight[0]*1000").
binary("root.totalWeight[0]<=root.maxWeight[0]*1000","root.totalWeight[0]","<=","root.maxWeight[0]*1000").
binary("root.maxWeight[0]*1000","root.maxWeight[0]","*","1000").
number("1000",1000).

constraint((3,"root")).
imply("root.totalVolume[0]","sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)").
binary("sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)","sum(root.carrier.bag.capacity.volume)","+","sum(root.frame.bag.capacity.volume)").
function("sum(root.carrier.bag.capacity.volume)","sum","root.carrier.bag.capacity.volume").
function_path("root.carrier.bag.capacity.volume","root.carrier[0].bag[0].capacity[0].volume[0]").
function_path("root.carrier.bag.capacity.volume","root.carrier[0].bag[1].capacity[0].volume[0]").
function_path("root.carrier.bag.capacity.volume","root.carrier[0].bag[2].capacity[0].volume[0]").
function("sum(root.frame.bag.capacity.volume)","sum","root.frame.bag.capacity.volume").
function_path("root.frame.bag.capacity.volume","root.frame[0].bag[0].capacity[0].volume[0]").
function_path("root.frame.bag.capacity.volume","root.frame[0].bag[1].capacity[0].volume[0]").

constraint((4,"root")).
require((4,"root"),"root.totalVolume[0]>=root.requestedVolume[0]").
binary("root.totalVolume[0]>=root.requestedVolume[0]","root.totalVolume[0]",">=","root.requestedVolume[0]").

constraint((5,"root")).
condition(5).
condition((5,"root"),"root.color[0]=Red").
binary("root.color[0]=Red","root.color[0]","=","Red").
constant("Red").
require((5,"root"),"root.frontWheel[0].size[0]=20").
binary("root.frontWheel[0].size[0]=20","root.frontWheel[0].size[0]","=","20").
number("20",20).

constraint((6,"root.carrier[0].bag[0]")).
condition(6).
condition((6,"root.carrier[0].bag[0]"),"root.carrier[0].bag[0].material[0]=Leather").
binary("root.carrier[0].bag[0].material[0]=Leather","root.carrier[0].bag[0].material[0]","=","Leather").
require((6,"root.carrier[0].bag[0]"),"root.carrier[0].bag[0].capacity[0]=B10").
binary("root.carrier[0].bag[0].capacity[0]=B10","root.carrier[0].bag[0].capacity[0]","=","B10").
constant("Leather").
constant("B10").

constraint((6,"root.carrier[0].bag[1]")).
condition((6,"root.carrier[0].bag[1]"),"root.carrier[0].bag[1].material[0]=Leather").
binary("root.carrier[0].bag[1].material[0]=Leather","root.carrier[0].bag[1].material[0]","=","Leather").
require((6,"root.carrier[0].bag[1]"),"root.carrier[0].bag[1].capacity[0]=B10").
binary("root.carrier[0].bag[1].capacity[0]=B10","root.carrier[0].bag[1].capacity[0]","=","B10").

constraint((6,"root.carrier[0].bag[2]")).
condition((6,"root.carrier[0].bag[2]"),"root.carrier[0].bag[2].material[0]=Leather").
binary("root.carrier[0].bag[2].material[0]=Leather","root.carrier[0].bag[2].material[0]","=","Leather").
require((6,"root.carrier[0].bag[2]"),"root.carrier[0].bag[2].capacity[0]=B10").
binary("root.carrier[0].bag[2].capacity[0]=B10","root.carrier[0].bag[2].capacity[0]","=","B10").

constraint((6,"root.frame[0].bag[0]")).
condition((6,"root.frame[0].bag[0]"),"root.frame[0].bag[0].material[0]=Leather").
binary("root.frame[0].bag[0].material[0]=Leather","root.frame[0].bag[0].material[0]","=","Leather").
require((6,"root.frame[0].bag[0]"),"root.frame[0].bag[0].capacity[0]=B10").
binary("root.frame[0].bag[0].capacity[0]=B10","root.frame[0].bag[0].capacity[0]","=","B10").

constraint((6,"root.frame[0].bag[1]")).
condition((6,"root.frame[0].bag[1]"),"root.frame[0].bag[1].material[0]=Leather").
binary("root.frame[0].bag[1].material[0]=Leather","root.frame[0].bag[1].material[0]","=","Leather").
require((6,"root.frame[0].bag[1]"),"root.frame[0].bag[1].capacity[0]=B10").
binary("root.frame[0].bag[1].capacity[0]=B10","root.frame[0].bag[1].capacity[0]","=","B10").
