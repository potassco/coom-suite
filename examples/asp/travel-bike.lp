% Partonomy of the model
cardinality("product","totalWeight",1,1).
range("product","totalWeight",1,10000).
cardinality("product","maxWeight",1,1).
range("product","maxWeight",10,10).
cardinality("product","totalVolume",1,1).
range("product","totalVolume",0,200).
cardinality("product","requestedVolume",1,1).
range("product","requestedVolume",200,200).
cardinality("product","frontWheel",1,1).
cardinality("product","rearWheel",1,1).
cardinality("product","frame",1,1).
cardinality("product","carrier",1,1).
cardinality("product","color",1,1).

part("Carrier").
cardinality("Carrier","bag",0,3).

part("Frame").
cardinality("Frame","bag",0,2).

part("Bag").
cardinality("Bag","capacity",1,1).
cardinality("Bag","material",1,1).

attribute("Capacity","discrete").
domain("Capacity", "B10").
domain("Capacity", "B20").
domain("Capacity", "B50").
domain("Capacity", "B100").

attribute("Capacity.volume","numeric").
domain("Capacity.volume",10).
domain("Capacity.volume",20).
domain("Capacity.volume",50).
domain("Capacity.volume",100).

attribute("Capacity.weight","numeric").
domain("Capacity.weight",100).
domain("Capacity.weight",250).
domain("Capacity.weight",600).
domain("Capacity.weight",1200).

attribute("Material","discrete").
domain("Material", "Cotton").
domain("Material", "Leather").
domain("Material", "Polyester").

attribute("Wheel","discrete").
domain("Wheel", "W20").
domain("Wheel", "W22").
domain("Wheel", "W24").
domain("Wheel", "W26").
domain("Wheel", "W28").

attribute("Wheel.size","numeric").
domain("Wheel.size",20).
domain("Wheel.size",22).
domain("Wheel.size",24).
domain("Wheel.size",26).
domain("Wheel.size",28).

attribute("Wheel.weight","numeric").
domain("Wheel.weight",650).
domain("Wheel.weight",700).
domain("Wheel.weight",800).
domain("Wheel.weight",900).
domain("Wheel.weight",1000).

attribute("Color","discrete").
domain("Color", "Red").
domain("Color", "Green").
domain("Color", "Yellow").
domain("Color", "Blue").

% Complete generated instance tree
type("root","product").

type("root.totalWeight[0]","num").
parent("root.totalWeight[0]","root").
name("root.totalWeight[0]","totalWeight").

type("root.maxWeight[0]","num").
parent("root.maxWeight[0]","root").
name("root.maxWeight[0]","maxWeight").

type("root.totalVolume[0]","num").
parent("root.totalVolume[0]","root").
name("root.totalVolume[0]","totalVolume").

type("root.requestedVolume[0]","num").
parent("root.requestedVolume[0]","root").
name("root.requestedVolume[0]","requestedVolume").

type("root.carrier[0]","Carrier").
index("root.carrier[0]",0).
parent("root.carrier[0]", "root").
name("root.carrier[0]","carrier").

type("root.frame[0]","Frame").
index("root.frame[0]",0).
parent("root.frame[0]", "root").
name("root.frame[0]","frame").

type("root.carrier[0].bag[0]","Bag").
index("root.carrier[0].bag[0]",0).
parent("root.carrier[0].bag[0]", "root.carrier[0]").
name("root.carrier[0].bag[0]","bag").

type("root.carrier[0].bag[1]","Bag").
index("root.carrier[0].bag[1]",1).
parent("root.carrier[0].bag[1]", "root.carrier[0]").
name("root.carrier[0].bag[1]","bag").

type("root.carrier[0].bag[2]","Bag").
index("root.carrier[0].bag[2]",2).
parent("root.carrier[0].bag[2]", "root.carrier[0]").
name("root.carrier[0].bag[2]","bag").

type("root.frame[0].bag[0]","Bag").
index("root.frame[0].bag[0]",0).
parent("root.frame[0].bag[0]", "root.frame[0]").
name("root.frame[0].bag[0]","bag").

type("root.frame[0].bag[1]","Bag").
index("root.frame[0].bag[1]",1).
parent("root.frame[0].bag[1]", "root.frame[0]").
name("root.frame[0].bag[1]","bag").

type("root.frontWheel[0]","Wheel").
parent("root.frontWheel[0]", "root").
name("root.frontWheel[0]","frontWheel").

type("root.frontWheel[0].size[0]","Wheel.size").
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").
isnumeric("root.frontWheel[0].size[0]").

type("root.frontWheel[0].weight[0]","Wheel.weight").
parent("root.frontWheel[0].weight[0]","root.frontWheel[0]").
isnumeric("root.frontWheel[0].weight[0]").

type("root.rearWheel[0]","Wheel").
parent("root.rearWheel[0]", "root").
name("root.rearWheel[0]","rearWheel").

type("root.rearWheel[0].size[0]","Wheel.size").
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").
isnumeric("root.rearWheel[0].size[0]").

type("root.rearWheel[0].weight[0]","Wheel.weight").
parent("root.rearWheel[0].weight[0]","root.rearWheel[0]").
isnumeric("root.rearWheel[0].weight[0]").

type("root.color[0]","Color").
parent("root.color[0]", "root").
name("root.color[0]","color").

type("root.carrier[0].bag[0].capacity[0]","Capacity").
parent("root.carrier[0].bag[0].capacity[0]", "root.carrier[0].bag[0]").
name("root.carrier[0].bag[0].capacity[0]","capacity").

type("root.carrier[0].bag[0].capacity[0].volume[0]","Capacity.volume").
parent("root.carrier[0].bag[0].capacity[0].volume[0]","root.carrier[0].bag[0].capacity[0]").
isnumeric("root.carrier[0].bag[0].capacity[0].volume[0]").

type("root.carrier[0].bag[0].capacity[0].weight[0]","Capacity.weight").
parent("root.carrier[0].bag[0].capacity[0].weight[0]","root.carrier[0].bag[0].capacity[0]").
isnumeric("root.carrier[0].bag[0].capacity[0].weight[0]").

type("root.carrier[0].bag[1].capacity[0]","Capacity").
parent("root.carrier[0].bag[1].capacity[0]", "root.carrier[0].bag[1]").
name("root.carrier[0].bag[1].capacity[0]","capacity").

type("root.carrier[0].bag[1].capacity[0].volume[0]","Capacity.volume").
parent("root.carrier[0].bag[1].capacity[0].volume[0]","root.carrier[0].bag[1].capacity[0]").
isnumeric("root.carrier[0].bag[1].capacity[0].volume[0]").

type("root.carrier[0].bag[1].capacity[0].weight[0]","Capacity.weight").
parent("root.carrier[0].bag[1].capacity[0].weight[0]","root.carrier[0].bag[1].capacity[0]").
isnumeric("root.carrier[0].bag[1].capacity[0].weight[0]").

type("root.carrier[0].bag[2].capacity[0]","Capacity").
parent("root.carrier[0].bag[2].capacity[0]", "root.carrier[0].bag[2]").
name("root.carrier[0].bag[2].capacity[0]","capacity").

type("root.carrier[0].bag[2].capacity[0].volume[0]","Capacity.volume").
parent("root.carrier[0].bag[2].capacity[0].volume[0]","root.carrier[0].bag[2].capacity[0]").
isnumeric("root.carrier[0].bag[2].capacity[0].volume[0]").

type("root.carrier[0].bag[2].capacity[0].weight[0]","Capacity.weight").
parent("root.carrier[0].bag[2].capacity[0].weight[0]","root.carrier[0].bag[2].capacity[0]").
isnumeric("root.carrier[0].bag[2].capacity[0].weight[0]").

type("root.carrier[0].bag[0].material[0]","Material").
parent("root.carrier[0].bag[0].material[0]", "root.carrier[0].bag[0]").
name("root.carrier[0].bag[0].material[0]","material").

type("root.carrier[0].bag[1].material[0]","Material").
parent("root.carrier[0].bag[1].material[0]", "root.carrier[0].bag[1]").
name("root.carrier[0].bag[1].material[0]","material").

type("root.carrier[0].bag[2].material[0]","Material").
parent("root.carrier[0].bag[2].material[0]", "root.carrier[0].bag[2]").
name("root.carrier[0].bag[2].material[0]","material").

type("root.frame[0].bag[0].capacity[0]","Capacity").
parent("root.frame[0].bag[0].capacity[0]", "root.frame[0].bag[0]").
name("root.frame[0].bag[0].capacity[0]","capacity").

type("root.frame[0].bag[0].capacity[0].volume[0]","Capacity.volume").
parent("root.frame[0].bag[0].capacity[0].volume[0]","root.frame[0].bag[0].capacity[0]").
isnumeric("root.frame[0].bag[0].capacity[0].volume[0]").

type("root.frame[0].bag[0].capacity[0].weight[0]","Capacity.weight").
parent("root.frame[0].bag[0].capacity[0].weight[0]","root.frame[0].bag[0].capacity[0]").
isnumeric("root.frame[0].bag[0].capacity[0].weight[0]").

type("root.frame[0].bag[1].capacity[0]","Capacity").
parent("root.frame[0].bag[1].capacity[0]", "root.frame[0].bag[1]").
name("root.frame[0].bag[1].capacity[0]","capacity").

type("root.frame[0].bag[1].capacity[0].volume[0]","Capacity.volume").
parent("root.frame[0].bag[1].capacity[0].volume[0]","root.frame[0].bag[1].capacity[0]").
isnumeric("root.frame[0].bag[1].capacity[0].volume[0]").

type("root.frame[0].bag[1].capacity[0].weight[0]","Capacity.weight").
parent("root.frame[0].bag[1].capacity[0].weight[0]","root.frame[0].bag[1].capacity[0]").
isnumeric("root.frame[0].bag[1].capacity[0].weight[0]").

type("root.frame[0].bag[0].material[0]","Material").
parent("root.frame[0].bag[0].material[0]", "root.frame[0].bag[0]").
name("root.frame[0].bag[0].material[0]","material").

type("root.frame[0].bag[1].material[0]","Material").
parent("root.frame[0].bag[1].material[0]", "root.frame[0].bag[1]").
name("root.frame[0].bag[1].material[0]","material").

% Instantiated constraints on complete instance tree
constraint((0,"root")).
require((0,"root"),"count(root.carrier.bag)+count(root.frame.bag)<=4").
binary("count(root.carrier.bag)+count(root.frame.bag)<=4","count(root.carrier.bag)+count(root.frame.bag)","<=","4").
binary("count(root.carrier.bag)+count(root.frame.bag)","count(root.carrier.bag)","+","count(root.frame.bag)").
function("count(root.carrier.bag)","count","root.carrier.bag").
path("root.carrier.bag","root.carrier[0].bag[0]").
path("root.carrier.bag","root.carrier[0].bag[1]").
path("root.carrier.bag","root.carrier[0].bag[2]").
function("count(root.frame.bag)","count","root.frame.bag").
path("root.frame.bag","root.frame[0].bag[0]").
path("root.frame.bag","root.frame[0].bag[1]").
number("4",4).

constraint((1,"root")).
imply("root.totalWeight[0]","root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","root.frontWheel[0].weight[0]","+","root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","root.rearWheel[0].weight[0]","+","sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","sum(root.carrier.bag.capacity.weight)","+","sum(root.frame.bag.capacity.weight)").
function("sum(root.carrier.bag.capacity.weight)","sum","root.carrier.bag.capacity.weight").
path("root.carrier.bag.capacity.weight","root.carrier[0].bag[0].capacity[0].weight[0]").
path("root.carrier.bag.capacity.weight","root.carrier[0].bag[1].capacity[0].weight[0]").
path("root.carrier.bag.capacity.weight","root.carrier[0].bag[2].capacity[0].weight[0]").
function("sum(root.frame.bag.capacity.weight)","sum","root.frame.bag.capacity.weight").
path("root.frame.bag.capacity.weight","root.frame[0].bag[0].capacity[0].weight[0]").
path("root.frame.bag.capacity.weight","root.frame[0].bag[1].capacity[0].weight[0]").

constraint((2,"root")).
require((2,"root"),"root.totalWeight[0]<=root.maxWeight[0]*1000").
binary("root.totalWeight[0]<=root.maxWeight[0]*1000","root.totalWeight[0]","<=","root.maxWeight[0]*1000").
binary("root.maxWeight[0]*1000","root.maxWeight[0]","*","1000").
number("1000",1000).

constraint((3,"root")).
imply("root.totalVolume[0]","sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)").
binary("sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)","sum(root.carrier.bag.capacity.volume)","+","sum(root.frame.bag.capacity.volume)").
function("sum(root.carrier.bag.capacity.volume)","sum","root.carrier.bag.capacity.volume").
path("root.carrier.bag.capacity.volume","root.carrier[0].bag[0].capacity[0].volume[0]").
path("root.carrier.bag.capacity.volume","root.carrier[0].bag[1].capacity[0].volume[0]").
path("root.carrier.bag.capacity.volume","root.carrier[0].bag[2].capacity[0].volume[0]").
function("sum(root.frame.bag.capacity.volume)","sum","root.frame.bag.capacity.volume").
path("root.frame.bag.capacity.volume","root.frame[0].bag[0].capacity[0].volume[0]").
path("root.frame.bag.capacity.volume","root.frame[0].bag[1].capacity[0].volume[0]").

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


% Attribute constraints
constraint(("Wheel","root.frontWheel[0]")).
column(("Wheel","root.frontWheel[0]"),0,0,"root.frontWheel[0]").
column(("Wheel","root.frontWheel[0]"),0,1,"root.frontWheel[0].size[0]").
column(("Wheel","root.frontWheel[0]"),0,2,"root.frontWheel[0].weight[0]").

constraint(("Wheel","root.rearWheel[0]")).
column(("Wheel","root.rearWheel[0]"),0,0,"root.rearWheel[0]").
column(("Wheel","root.rearWheel[0]"),0,1,"root.rearWheel[0].size[0]").
column(("Wheel","root.rearWheel[0]"),0,2,"root.rearWheel[0].weight[0]").

allow("Wheel",(0,0),"W20").
allow("Wheel",(1,0),20).
allow("Wheel",(2,0),650).
allow("Wheel",(0,1),"W22").
allow("Wheel",(1,1),22).
allow("Wheel",(2,1),700).
allow("Wheel",(0,2),"W24").
allow("Wheel",(1,2),24).
allow("Wheel",(2,2),800).
allow("Wheel",(0,3),"W26").
allow("Wheel",(1,3),26).
allow("Wheel",(2,3),900).
allow("Wheel",(0,4),"W28").
allow("Wheel",(1,4),28).
allow("Wheel",(2,4),1000).


constraint(("Capacity","root.carrier[0].bag[0]")).
column(("Capacity","root.carrier[0].bag[0]"),0,0,"root.carrier[0].bag[0].capacity[0]").
column(("Capacity","root.carrier[0].bag[0]"),0,1,"root.carrier[0].bag[0].capacity[0].volume[0]").
column(("Capacity","root.carrier[0].bag[0]"),0,2,"root.carrier[0].bag[0].capacity[0].weight[0]").

constraint(("Capacity","root.carrier[0].bag[1]")).
column(("Capacity","root.carrier[0].bag[1]"),0,0,"root.carrier[0].bag[1].capacity[0]").
column(("Capacity","root.carrier[0].bag[1]"),0,1,"root.carrier[0].bag[1].capacity[0].volume[0]").
column(("Capacity","root.carrier[0].bag[1]"),0,2,"root.carrier[0].bag[1].capacity[0].weight[0]").

constraint(("Capacity","root.carrier[0].bag[2]")).
column(("Capacity","root.carrier[0].bag[2]"),0,0,"root.carrier[0].bag[2].capacity[0]").
column(("Capacity","root.carrier[0].bag[2]"),0,1,"root.carrier[0].bag[2].capacity[0].volume[0]").
column(("Capacity","root.carrier[0].bag[2]"),0,2,"root.carrier[0].bag[2].capacity[0].weight[0]").

constraint(("Capacity","root.frame[0].bag[0]")).
column(("Capacity","root.frame[0].bag[0]"),0,0,"root.frame[0].bag[0].capacity[0]").
column(("Capacity","root.frame[0].bag[0]"),0,1,"root.frame[0].bag[0].capacity[0].volume[0]").
column(("Capacity","root.frame[0].bag[0]"),0,2,"root.frame[0].bag[0].capacity[0].weight[0]").

constraint(("Capacity","root.frame[0].bag[1]")).
column(("Capacity","root.frame[0].bag[1]"),0,0,"root.frame[0].bag[1].capacity[0]").
column(("Capacity","root.frame[0].bag[1]"),0,1,"root.frame[0].bag[1].capacity[0].volume[0]").
column(("Capacity","root.frame[0].bag[1]"),0,2,"root.frame[0].bag[1].capacity[0].weight[0]").

allow("Capacity",(0,0),"B10").
allow("Capacity",(1,0),10).
allow("Capacity",(2,0),100).
allow("Capacity",(0,1),"B20").
allow("Capacity",(1,1),20).
allow("Capacity",(2,1),250).
allow("Capacity",(0,2),"B50").
allow("Capacity",(1,2),50).
allow("Capacity",(2,2),600).
allow("Capacity",(0,3),"B100").
allow("Capacity",(1,3),100).
allow("Capacity",(2,3),1200).
