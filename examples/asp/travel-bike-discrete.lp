% Types of the model
type("product.totalWeight").
type("product.maxWeight").
type("product.totalVolume").
type("product.requestedVolume").
type("Capacity.volume").
type("Capacity.weight").
type("Wheel.size").
type("Wheel.weight").
type("Capacity").
type("Material").
type("Wheel").
type("Color").
type("Carrier").
type("Frame").
type("Bag").

part("Carrier").
part("Frame").
part("Bag").

% Attributes of the model
integer("product.totalWeight").
range("product.totalWeight",1,10000).

integer("product.maxWeight").
range("product.maxWeight",10,10).

integer("product.totalVolume").
range("product.totalVolume",0,200).

integer("product.requestedVolume").
range("product.requestedVolume",200,200).

discrete("Capacity").
domain("Capacity", "B10").
domain("Capacity", "B20").
domain("Capacity", "B50").
domain("Capacity", "B100").

discrete("Capacity.volume").
% range("Capacity.volume",10,100).
domain("Capacity.volume",10).
domain("Capacity.volume",20).
domain("Capacity.volume",50).
domain("Capacity.volume",100).

discrete("Capacity.weight").
% range("Capacity.numeric",100,1200).
domain("Capacity.weight",100).
domain("Capacity.weight",250).
domain("Capacity.weight",600).
domain("Capacity.weight",1200).

discrete("Material").
domain("Material", "Cotton").
domain("Material", "Leather").
domain("Material", "Polyester").

discrete("Wheel").
domain("Wheel", "W20").
domain("Wheel", "W22").
domain("Wheel", "W24").
domain("Wheel", "W26").
domain("Wheel", "W28").

discrete("Wheel.size").
% range("Wheel.size",20,28).
domain("Wheel.size",20).
domain("Wheel.size",22).
domain("Wheel.size",24).
domain("Wheel.size",26).
domain("Wheel.size",28).

discrete("Wheel.weight").
% range("Wheel.weight",650,1000).
domain("Wheel.weight",650).
domain("Wheel.weight",700).
domain("Wheel.weight",800).
domain("Wheel.weight",900).
domain("Wheel.weight",1000).

discrete("Color").
domain("Color", "Red").
domain("Color", "Green").
domain("Color", "Yellow").
domain("Color", "Blue").

% Complete instance tree
type("root","product").

type("root.totalWeight[0]","product.totalWeight").
index("root.totalWeight[0]",0).
parent("root.totalWeight[0]","root").
% name("root.totalWeight[0]","totalWeight").

type("root.maxWeight[0]","product.maxWeight").
index("root.maxWeight[0]",0).
parent("root.maxWeight[0]","root").
% name("root.maxWeight[0]","maxWeight").

type("root.totalVolume[0]","product.totalVolume").
index("root.totalVolume[0]",0).
parent("root.totalVolume[0]","root").
% name("root.totalVolume[0]","totalVolume").

type("root.requestedVolume[0]","product.requestedVolume").
index("root.requestedVolume[0]",0).
parent("root.requestedVolume[0]","root").
% name("root.requestedVolume[0]","requestedVolume").

type("root.carrier[0]","Carrier").
index("root.carrier[0]",0).
parent("root.carrier[0]", "root").
% name("root.carrier[0]","carrier").

type("root.frame[0]","Frame").
index("root.frame[0]",0).
parent("root.frame[0]", "root").
% name("root.frame[0]","frame").

type("root.carrier[0].bag[0]","Bag").
index("root.carrier[0].bag[0]",0).
parent("root.carrier[0].bag[0]", "root.carrier[0]").
% name("root.carrier[0].bag[0]","bag").

type("root.carrier[0].bag[1]","Bag").
index("root.carrier[0].bag[1]",1).
parent("root.carrier[0].bag[1]", "root.carrier[0]").
% name("root.carrier[0].bag[1]","bag").

type("root.carrier[0].bag[2]","Bag").
index("root.carrier[0].bag[2]",2).
parent("root.carrier[0].bag[2]", "root.carrier[0]").
% name("root.carrier[0].bag[2]","bag").

type("root.frame[0].bag[0]","Bag").
index("root.frame[0].bag[0]",0).
parent("root.frame[0].bag[0]", "root.frame[0]").
% name("root.frame[0].bag[0]","bag").

type("root.frame[0].bag[1]","Bag").
index("root.frame[0].bag[1]",1).
parent("root.frame[0].bag[1]", "root.frame[0]").
% name("root.frame[0].bag[1]","bag").

type("root.frontWheel[0]","Wheel").
index("root.frontWheel[0]",0).
parent("root.frontWheel[0]", "root").
% name("root.frontWheel[0]","frontWheel").

type("root.frontWheel[0].size[0]","Wheel.size").
index("root.frontWheel[0].size[0]",0).
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").
% name("root.frontWheel[0].size[0]","size").
% % isnumeric("root.frontWheel[0].size[0]").

type("root.frontWheel[0].weight[0]","Wheel.weight").
index("root.frontWheel[0].weight[0]",0).
parent("root.frontWheel[0].weight[0]","root.frontWheel[0]").
% name("root.frontWheel[0].weight[0]","weight").
% % isnumeric("root.frontWheel[0].weight[0]").

type("root.rearWheel[0]","Wheel").
index("root.rearWheel[0]",0).
parent("root.rearWheel[0]", "root").
% name("root.rearWheel[0]","rearWheel").

type("root.rearWheel[0].size[0]","Wheel.size").
index("root.rearWheel[0].size[0]",0).
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").
% name("root.rearWheel[0].size[0]","size").
% % isnumeric("root.rearWheel[0].size[0]").

type("root.rearWheel[0].weight[0]","Wheel.weight").
index("root.rearWheel[0].weight[0]",0).
parent("root.rearWheel[0].weight[0]","root.rearWheel[0]").
% name("root.rearWheel[0].weight[0]","weight").
% isnumeric("root.rearWheel[0].weight[0]").

type("root.color[0]","Color").
index("root.color[0]",0).
parent("root.color[0]", "root").
% name("root.color[0]","color").

type("root.carrier[0].bag[0].capacity[0]","Capacity").
index("root.carrier[0].bag[0].capacity[0]",0).
parent("root.carrier[0].bag[0].capacity[0]", "root.carrier[0].bag[0]").
% name("root.carrier[0].bag[0].capacity[0]","capacity").

type("root.carrier[0].bag[0].capacity[0].volume[0]","Capacity.volume").
index("root.carrier[0].bag[0].capacity[0].volume[0]",0).
parent("root.carrier[0].bag[0].capacity[0].volume[0]","root.carrier[0].bag[0].capacity[0]").
% isnumeric("root.carrier[0].bag[0].capacity[0].volume[0]").

type("root.carrier[0].bag[0].capacity[0].weight[0]","Capacity.weight").
index("root.carrier[0].bag[0].capacity[0].weight[0]",0).
parent("root.carrier[0].bag[0].capacity[0].weight[0]","root.carrier[0].bag[0].capacity[0]").
% isnumeric("root.carrier[0].bag[0].capacity[0].weight[0]").

type("root.carrier[0].bag[1].capacity[0]","Capacity").
index("root.carrier[0].bag[1].capacity[0]",0).
parent("root.carrier[0].bag[1].capacity[0]", "root.carrier[0].bag[1]").
% name("root.carrier[0].bag[1].capacity[0]","capacity").

type("root.carrier[0].bag[1].capacity[0].volume[0]","Capacity.volume").
index("root.carrier[0].bag[1].capacity[0].volume[0]",0).
parent("root.carrier[0].bag[1].capacity[0].volume[0]","root.carrier[0].bag[1].capacity[0]").
% isnumeric("root.carrier[0].bag[1].capacity[0].volume[0]").

type("root.carrier[0].bag[1].capacity[0].weight[0]","Capacity.weight").
index("root.carrier[0].bag[1].capacity[0].weight[0]",0).
parent("root.carrier[0].bag[1].capacity[0].weight[0]","root.carrier[0].bag[1].capacity[0]").
% isnumeric("root.carrier[0].bag[1].capacity[0].weight[0]").

type("root.carrier[0].bag[2].capacity[0]","Capacity").
index("root.carrier[0].bag[2].capacity[0]",0).
parent("root.carrier[0].bag[2].capacity[0]", "root.carrier[0].bag[2]").
% name("root.carrier[0].bag[2].capacity[0]","capacity").

type("root.carrier[0].bag[2].capacity[0].volume[0]","Capacity.volume").
index("root.carrier[0].bag[2].capacity[0].volume[0]",0).
parent("root.carrier[0].bag[2].capacity[0].volume[0]","root.carrier[0].bag[2].capacity[0]").
% isnumeric("root.carrier[0].bag[2].capacity[0].volume[0]").

type("root.carrier[0].bag[2].capacity[0].weight[0]","Capacity.weight").
index("root.carrier[0].bag[2].capacity[0].weight[0]",0).
parent("root.carrier[0].bag[2].capacity[0].weight[0]","root.carrier[0].bag[2].capacity[0]").
% isnumeric("root.carrier[0].bag[2].capacity[0].weight[0]").

type("root.carrier[0].bag[0].material[0]","Material").
index("root.carrier[0].bag[0].material[0]",0).
parent("root.carrier[0].bag[0].material[0]", "root.carrier[0].bag[0]").
% name("root.carrier[0].bag[0].material[0]","material").

type("root.carrier[0].bag[1].material[0]","Material").
index("root.carrier[0].bag[1].material[0]",0).
parent("root.carrier[0].bag[1].material[0]", "root.carrier[0].bag[1]").
% name("root.carrier[0].bag[1].material[0]","material").

type("root.carrier[0].bag[2].material[0]","Material").
index("root.carrier[0].bag[2].material[0]",0).
parent("root.carrier[0].bag[2].material[0]", "root.carrier[0].bag[2]").
% name("root.carrier[0].bag[2].material[0]","material").

type("root.frame[0].bag[0].capacity[0]","Capacity").
index("root.frame[0].bag[0].capacity[0]",0).
parent("root.frame[0].bag[0].capacity[0]", "root.frame[0].bag[0]").
% name("root.frame[0].bag[0].capacity[0]","capacity").

type("root.frame[0].bag[0].capacity[0].volume[0]","Capacity.volume").
index("root.frame[0].bag[0].capacity[0].volume[0]",0).
parent("root.frame[0].bag[0].capacity[0].volume[0]","root.frame[0].bag[0].capacity[0]").
% isnumeric("root.frame[0].bag[0].capacity[0].volume[0]").

type("root.frame[0].bag[0].capacity[0].weight[0]","Capacity.weight").
index("root.frame[0].bag[0].capacity[0].weight[0]",0).
parent("root.frame[0].bag[0].capacity[0].weight[0]","root.frame[0].bag[0].capacity[0]").
% isnumeric("root.frame[0].bag[0].capacity[0].weight[0]").

type("root.frame[0].bag[1].capacity[0]","Capacity").
index("root.frame[0].bag[1].capacity[0]",0).
parent("root.frame[0].bag[1].capacity[0]", "root.frame[0].bag[1]").
% name("root.frame[0].bag[1].capacity[0]","capacity").

type("root.frame[0].bag[1].capacity[0].volume[0]","Capacity.volume").
index("root.frame[0].bag[1].capacity[0].volume[0]",0).
parent("root.frame[0].bag[1].capacity[0].volume[0]","root.frame[0].bag[1].capacity[0]").
% isnumeric("root.frame[0].bag[1].capacity[0].volume[0]").

type("root.frame[0].bag[1].capacity[0].weight[0]","Capacity.weight").
index("root.frame[0].bag[1].capacity[0].weight[0]",0).
parent("root.frame[0].bag[1].capacity[0].weight[0]","root.frame[0].bag[1].capacity[0]").
% isnumeric("root.frame[0].bag[1].capacity[0].weight[0]").

type("root.frame[0].bag[0].material[0]","Material").
index("root.frame[0].bag[0].material[0]",0).
parent("root.frame[0].bag[0].material[0]", "root.frame[0].bag[0]").
% name("root.frame[0].bag[0].material[0]","material").

type("root.frame[0].bag[1].material[0]","Material").
index("root.frame[0].bag[1].material[0]",0).
parent("root.frame[0].bag[1].material[0]", "root.frame[0].bag[1]").
% name("root.frame[0].bag[1].material[0]","material").

% Instantiated constraints
constraint(0,"count(root.carrier.bag)+count(root.frame.bag)<=4").
% require((0,"root"),"count(root.carrier.bag)+count(root.frame.bag)<=4").
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

constraint(1,"root.totalWeight[0]=root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
% imply("root.totalWeight[0]","root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("root.totalWeight[0]=root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","root.totalWeight[0]","=","root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
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

constraint(2,"root.totalWeight[0]<=root.maxWeight[0]*1000").
% require((2,"root"),"root.totalWeight[0]<=root.maxWeight[0]*1000").
binary("root.totalWeight[0]<=root.maxWeight[0]*1000","root.totalWeight[0]","<=","root.maxWeight[0]*1000").
binary("root.maxWeight[0]*1000","root.maxWeight[0]","*","1000").
number("1000",1000).

constraint(3,"root.totalVolume[0]=sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)").
% imply("root.totalVolume[0]","sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)").
binary("root.totalVolume[0]=sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)","root.totalVolume[0]","=","sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)").
binary("sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)","sum(root.carrier.bag.capacity.volume)","+","sum(root.frame.bag.capacity.volume)").
function("sum(root.carrier.bag.capacity.volume)","sum","root.carrier.bag.capacity.volume").
path("root.carrier.bag.capacity.volume","root.carrier[0].bag[0].capacity[0].volume[0]").
path("root.carrier.bag.capacity.volume","root.carrier[0].bag[1].capacity[0].volume[0]").
path("root.carrier.bag.capacity.volume","root.carrier[0].bag[2].capacity[0].volume[0]").
function("sum(root.frame.bag.capacity.volume)","sum","root.frame.bag.capacity.volume").
path("root.frame.bag.capacity.volume","root.frame[0].bag[0].capacity[0].volume[0]").
path("root.frame.bag.capacity.volume","root.frame[0].bag[1].capacity[0].volume[0]").

constraint(4,"root.totalVolume[0]>=root.requestedVolume[0]").
% require((4,"root"),"root.totalVolume[0]>=root.requestedVolume[0]").
binary("root.totalVolume[0]>=root.requestedVolume[0]","root.totalVolume[0]",">=","root.requestedVolume[0]").

constraint(5,"!root.color[0]=Red||root.frontWheel[0].size[0]=20").
binary("!root.color[0]=Red||root.frontWheel[0].size[0]=20","!root.color[0]=Red","||","root.frontWheel[0].size[0]=20").
unary("!root.color[0]=Red","!","root.color[0]=Red").
% condition(5).
% condition((5,"root"),"root.color[0]=Red").
binary("root.color[0]=Red","root.color[0]","=","Red").
constant("Red").
% require((5,"root"),"root.frontWheel[0].size[0]=20").
binary("root.frontWheel[0].size[0]=20","root.frontWheel[0].size[0]","=","20").
number("20",20).

constraint(6,"!root.carrier[0].bag[0].material[0]=Leather||root.carrier[0].bag[0].capacity[0]=B10").
binary("!root.carrier[0].bag[0].material[0]=Leather||root.carrier[0].bag[0].capacity[0]=B10","!root.carrier[0].bag[0].material[0]=Leather","||","root.carrier[0].bag[0].capacity[0]=B10").
unary("!root.carrier[0].bag[0].material[0]=Leather","!","root.carrier[0].bag[0].material[0]=Leather").
% condition(6).
% condition((6,"root.carrier[0].bag[0]"),"root.carrier[0].bag[0].material[0]=Leather").
binary("root.carrier[0].bag[0].material[0]=Leather","root.carrier[0].bag[0].material[0]","=","Leather").
% require((6,"root.carrier[0].bag[0]"),"root.carrier[0].bag[0].capacity[0]=B10").
binary("root.carrier[0].bag[0].capacity[0]=B10","root.carrier[0].bag[0].capacity[0]","=","B10").
constant("Leather").
constant("B10").

constraint(6,"!root.carrier[0].bag[1].material[0]=Leather||root.carrier[0].bag[1].capacity[0]=B10").
binary("!root.carrier[0].bag[1].material[0]=Leather||root.carrier[0].bag[1].capacity[0]=B10","!root.carrier[0].bag[1].material[0]=Leather","||","root.carrier[0].bag[1].capacity[0]=B10").
unary("!root.carrier[0].bag[1].material[0]=Leather","!","root.carrier[0].bag[1].material[0]=Leather").
% condition((6,"root.carrier[0].bag[1]"),"root.carrier[0].bag[1].material[0]=Leather").
binary("root.carrier[0].bag[1].material[0]=Leather","root.carrier[0].bag[1].material[0]","=","Leather").
% require((6,"root.carrier[0].bag[1]"),"root.carrier[0].bag[1].capacity[0]=B10").
binary("root.carrier[0].bag[1].capacity[0]=B10","root.carrier[0].bag[1].capacity[0]","=","B10").

constraint(6,"!root.carrier[0].bag[2].material[0]=Leather||root.carrier[0].bag[2].capacity[0]=B10").
binary("!root.carrier[0].bag[2].material[0]=Leather||root.carrier[0].bag[2].capacity[0]=B10","!root.carrier[0].bag[2].material[0]=Leather","||","root.carrier[0].bag[2].capacity[0]=B10").
unary("!root.carrier[0].bag[2].material[0]=Leather","!","root.carrier[0].bag[2].material[0]=Leather").
% condition((6,"root.carrier[0].bag[2]"),"root.carrier[0].bag[2].material[0]=Leather").
binary("root.carrier[0].bag[2].material[0]=Leather","root.carrier[0].bag[2].material[0]","=","Leather").
% require((6,"root.carrier[0].bag[2]"),"root.carrier[0].bag[2].capacity[0]=B10").
binary("root.carrier[0].bag[2].capacity[0]=B10","root.carrier[0].bag[2].capacity[0]","=","B10").

constraint(6,"!root.frame[0].bag[0].material[0]=Leather||root.frame[0].bag[0].capacity[0]=B10").
binary("!root.frame[0].bag[0].material[0]=Leather||root.frame[0].bag[0].capacity[0]=B10","!root.frame[0].bag[0].material[0]=Leather","||","root.frame[0].bag[0].capacity[0]=B10").
unary("!root.frame[0].bag[0].material[0]=Leather","!","root.frame[0].bag[0].material[0]=Leather").
% condition((6,"root.frame[0].bag[0]"),"root.frame[0].bag[0].material[0]=Leather").
binary("root.frame[0].bag[0].material[0]=Leather","root.frame[0].bag[0].material[0]","=","Leather").
% require((6,"root.frame[0].bag[0]"),"root.frame[0].bag[0].capacity[0]=B10").
binary("root.frame[0].bag[0].capacity[0]=B10","root.frame[0].bag[0].capacity[0]","=","B10").

constraint(6,"!root.frame[0].bag[1].material[0]=Leather||root.frame[0].bag[1].capacity[0]=B10").
binary("!root.frame[0].bag[1].material[0]=Leather||root.frame[0].bag[1].capacity[0]=B10","!root.frame[0].bag[1].material[0]=Leather","||","root.frame[0].bag[1].capacity[0]=B10").
unary("!root.frame[0].bag[1].material[0]=Leather","!","root.frame[0].bag[1].material[0]=Leather").
% condition((6,"root.frame[0].bag[1]"),"root.frame[0].bag[1].material[0]=Leather").
binary("root.frame[0].bag[1].material[0]=Leather","root.frame[0].bag[1].material[0]","=","Leather").
% require((6,"root.frame[0].bag[1]"),"root.frame[0].bag[1].capacity[0]=B10").
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

% Cardinality constraints
% only need to check for min, not possible to exceed max as all possible objects are instantiated before
cardinality("root","root.totalWeight",1).
path("root.totalWeight","root.totalWeight[0]").

cardinality("root","root.maxWeight",1).
path("root.maxWeight","root.maxWeight[0]").

cardinality("root","root.totalVolume",1).
path("root.totalVolume","root.totalVolume[0]").

cardinality("root","root.requestedVolume",1).
path("root.requestedVolume","root.requestedVolume[0]").

cardinality("root","root.frontWheel",1).
path("root.frontWheel","root.frontWheel[0]").

cardinality("root.frontWheel[0]","root.frontWheel[0].size",1).
path("root.frontWheel[0].size","root.frontWheel[0].size[0]").

cardinality("root.frontWheel[0]","root.frontWheel[0].weight",1).
path("root.frontWheel[0].weight","root.frontWheel[0].weight[0]").

cardinality("root","root.rearWheel",1).
path("root.rearWheel","root.rearWheel[0]").

cardinality("root.rearWheel[0]","root.rearWheel[0].size",1).
path("root.rearWheel[0].size","root.rearWheel[0].size[0]").

cardinality("root.rearWheel[0]","root.rearWheel[0].weight",1).
path("root.rearWheel[0].weight","root.rearWheel[0].weight[0]").

cardinality("root","root.carrier",1).
path("root.carrier","root.carrier[0]").

cardinality("root","root.frame",1).
path("root.frame","root.frame[0]").

cardinality("root","root.color",1).
path("root.color","root.color[0]").


cardinality("root.carrier[0]","root.carrier[0].bag",0).
path("root.carrier[0].bag","root.carrier[0].bag[0]").
path("root.carrier[0].bag","root.carrier[0].bag[1]").
path("root.carrier[0].bag","root.carrier[0].bag[2]").

cardinality("root.carrier[0].bag[0]","root.carrier[0].bag[0].capacity",1).
path("root.carrier[0].bag[0].capacity","root.carrier[0].bag[0].capacity[0]").

cardinality("root.carrier[0].bag[0].capacity[0]","root.carrier[0].bag[0].capacity[0].volume",1).
path("root.carrier[0].bag[0].capacity[0].volume","root.carrier[0].bag[0].capacity[0].volume[0]").

cardinality("root.carrier[0].bag[0].capacity[0]","root.carrier[0].bag[0].capacity[0].weight",1).
path("root.carrier[0].bag[0].capacity[0].weight","root.carrier[0].bag[0].capacity[0].weight[0]").

cardinality("root.carrier[0].bag[0]","root.carrier[0].bag[0].material",1).
path("root.carrier[0].bag[0].material","root.carrier[0].bag[0].material[0]").

cardinality("root.carrier[0].bag[1]","root.carrier[0].bag[1].capacity",1).
path("root.carrier[0].bag[1].capacity","root.carrier[0].bag[1].capacity[0]").

cardinality("root.carrier[0].bag[1].capacity[0]","root.carrier[0].bag[1].capacity[0].volume",1).
path("root.carrier[0].bag[1].capacity[0].volume","root.carrier[0].bag[1].capacity[0].volume[0]").

cardinality("root.carrier[0].bag[1].capacity[0]","root.carrier[0].bag[1].capacity[0].weight",1).
path("root.carrier[0].bag[1].capacity[0].weight","root.carrier[0].bag[1].capacity[0].weight[0]").

cardinality("root.carrier[0].bag[1]","root.carrier[0].bag[1].material",1).
path("root.carrier[0].bag[1].material","root.carrier[0].bag[1].material[0]").

cardinality("root.carrier[0].bag[2]","root.carrier[0].bag[2].capacity",1).
path("root.carrier[0].bag[2].capacity","root.carrier[0].bag[2].capacity[0]").

cardinality("root.carrier[0].bag[2].capacity[0]","root.carrier[0].bag[2].capacity[0].volume",1).
path("root.carrier[0].bag[2].capacity[0].volume","root.carrier[0].bag[2].capacity[0].volume[0]").

cardinality("root.carrier[0].bag[2].capacity[0]","root.carrier[0].bag[2].capacity[0].weight",1).
path("root.carrier[0].bag[2].capacity[0].weight","root.carrier[0].bag[2].capacity[0].weight[0]").

cardinality("root.carrier[0].bag[2]","root.carrier[0].bag[2].material",1).
path("root.carrier[0].bag[2].material","root.carrier[0].bag[2].material[0]").


cardinality("root.frame[0]","root.frame[0].bag",0).
path("root.frame[0].bag","root.frame[0].bag[0]").
path("root.frame[0].bag","root.frame[0].bag[1]").

cardinality("root.frame[0].bag[0]","root.frame[0].bag[0].capacity",1).
path("root.frame[0].bag[0].capacity","root.frame[0].bag[0].capacity[0]").

cardinality("root.frame[0].bag[0].capacity[0]","root.frame[0].bag[0].capacity[0].volume",1).
path("root.frame[0].bag[0].capacity[0].volume","root.frame[0].bag[0].capacity[0].volume[0]").

cardinality("root.frame[0].bag[0].capacity[0]","root.frame[0].bag[0].capacity[0].weight",1).
path("root.frame[0].bag[0].capacity[0].weight","root.frame[0].bag[0].capacity[0].weight[0]").

cardinality("root.frame[0].bag[0]","root.frame[0].bag[0].material",1).
path("root.frame[0].bag[0].material","root.frame[0].bag[0].material[0]").

cardinality("root.frame[0].bag[1]","root.frame[0].bag[1].capacity",1).
path("root.frame[0].bag[1].capacity","root.frame[0].bag[1].capacity[0]").

cardinality("root.frame[0].bag[1].capacity[0]","root.frame[0].bag[1].capacity[0].volume",1).
path("root.frame[0].bag[1].capacity[0].volume","root.frame[0].bag[1].capacity[0].volume[0]").

cardinality("root.frame[0].bag[1].capacity[0]","root.frame[0].bag[1].capacity[0].weight",1).
path("root.frame[0].bag[1].capacity[0].weight","root.frame[0].bag[1].capacity[0].weight[0]").

cardinality("root.frame[0].bag[1]","root.frame[0].bag[1].material",1).
path("root.frame[0].bag[1].material","root.frame[0].bag[1].material[0]").
