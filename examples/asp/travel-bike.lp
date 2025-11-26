% Parts of the model
part("root").
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
domain("Capacity.volume",10).
domain("Capacity.volume",20).
domain("Capacity.volume",50).
domain("Capacity.volume",100).

discrete("Capacity.weight").
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
domain("Wheel.size",20).
domain("Wheel.size",22).
domain("Wheel.size",24).
domain("Wheel.size",26).
domain("Wheel.size",28).

discrete("Wheel.weight").
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

type("root.maxWeight[0]","product.maxWeight").
index("root.maxWeight[0]",0).
parent("root.maxWeight[0]","root").

type("root.totalVolume[0]","product.totalVolume").
index("root.totalVolume[0]",0).
parent("root.totalVolume[0]","root").

type("root.requestedVolume[0]","product.requestedVolume").
index("root.requestedVolume[0]",0).
parent("root.requestedVolume[0]","root").

type("root.carrier[0]","Carrier").
index("root.carrier[0]",0).
parent("root.carrier[0]", "root").

type("root.frame[0]","Frame").
index("root.frame[0]",0).
parent("root.frame[0]", "root").

type("root.carrier[0].bag[0]","Bag").
index("root.carrier[0].bag[0]",0).
parent("root.carrier[0].bag[0]", "root.carrier[0]").

type("root.carrier[0].bag[1]","Bag").
index("root.carrier[0].bag[1]",1).
parent("root.carrier[0].bag[1]", "root.carrier[0]").

type("root.carrier[0].bag[2]","Bag").
index("root.carrier[0].bag[2]",2).
parent("root.carrier[0].bag[2]", "root.carrier[0]").

type("root.frame[0].bag[0]","Bag").
index("root.frame[0].bag[0]",0).
parent("root.frame[0].bag[0]", "root.frame[0]").

type("root.frame[0].bag[1]","Bag").
index("root.frame[0].bag[1]",1).
parent("root.frame[0].bag[1]", "root.frame[0]").

type("root.frontWheel[0]","Wheel").
index("root.frontWheel[0]",0).
parent("root.frontWheel[0]", "root").

type("root.frontWheel[0].size[0]","Wheel.size").
index("root.frontWheel[0].size[0]",0).
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").

type("root.frontWheel[0].weight[0]","Wheel.weight").
index("root.frontWheel[0].weight[0]",0).
parent("root.frontWheel[0].weight[0]","root.frontWheel[0]").

type("root.rearWheel[0]","Wheel").
index("root.rearWheel[0]",0).
parent("root.rearWheel[0]", "root").

type("root.rearWheel[0].size[0]","Wheel.size").
index("root.rearWheel[0].size[0]",0).
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").

type("root.rearWheel[0].weight[0]","Wheel.weight").
index("root.rearWheel[0].weight[0]",0).
parent("root.rearWheel[0].weight[0]","root.rearWheel[0]").

type("root.color[0]","Color").
index("root.color[0]",0).
parent("root.color[0]", "root").

type("root.carrier[0].bag[0].capacity[0]","Capacity").
index("root.carrier[0].bag[0].capacity[0]",0).
parent("root.carrier[0].bag[0].capacity[0]", "root.carrier[0].bag[0]").

type("root.carrier[0].bag[0].capacity[0].volume[0]","Capacity.volume").
index("root.carrier[0].bag[0].capacity[0].volume[0]",0).
parent("root.carrier[0].bag[0].capacity[0].volume[0]","root.carrier[0].bag[0].capacity[0]").

type("root.carrier[0].bag[0].capacity[0].weight[0]","Capacity.weight").
index("root.carrier[0].bag[0].capacity[0].weight[0]",0).
parent("root.carrier[0].bag[0].capacity[0].weight[0]","root.carrier[0].bag[0].capacity[0]").

type("root.carrier[0].bag[1].capacity[0]","Capacity").
index("root.carrier[0].bag[1].capacity[0]",0).
parent("root.carrier[0].bag[1].capacity[0]", "root.carrier[0].bag[1]").

type("root.carrier[0].bag[1].capacity[0].volume[0]","Capacity.volume").
index("root.carrier[0].bag[1].capacity[0].volume[0]",0).
parent("root.carrier[0].bag[1].capacity[0].volume[0]","root.carrier[0].bag[1].capacity[0]").

type("root.carrier[0].bag[1].capacity[0].weight[0]","Capacity.weight").
index("root.carrier[0].bag[1].capacity[0].weight[0]",0).
parent("root.carrier[0].bag[1].capacity[0].weight[0]","root.carrier[0].bag[1].capacity[0]").

type("root.carrier[0].bag[2].capacity[0]","Capacity").
index("root.carrier[0].bag[2].capacity[0]",0).
parent("root.carrier[0].bag[2].capacity[0]", "root.carrier[0].bag[2]").

type("root.carrier[0].bag[2].capacity[0].volume[0]","Capacity.volume").
index("root.carrier[0].bag[2].capacity[0].volume[0]",0).
parent("root.carrier[0].bag[2].capacity[0].volume[0]","root.carrier[0].bag[2].capacity[0]").

type("root.carrier[0].bag[2].capacity[0].weight[0]","Capacity.weight").
index("root.carrier[0].bag[2].capacity[0].weight[0]",0).
parent("root.carrier[0].bag[2].capacity[0].weight[0]","root.carrier[0].bag[2].capacity[0]").

type("root.carrier[0].bag[0].material[0]","Material").
index("root.carrier[0].bag[0].material[0]",0).
parent("root.carrier[0].bag[0].material[0]", "root.carrier[0].bag[0]").

type("root.carrier[0].bag[1].material[0]","Material").
index("root.carrier[0].bag[1].material[0]",0).
parent("root.carrier[0].bag[1].material[0]", "root.carrier[0].bag[1]").

type("root.carrier[0].bag[2].material[0]","Material").
index("root.carrier[0].bag[2].material[0]",0).
parent("root.carrier[0].bag[2].material[0]", "root.carrier[0].bag[2]").

type("root.frame[0].bag[0].capacity[0]","Capacity").
index("root.frame[0].bag[0].capacity[0]",0).
parent("root.frame[0].bag[0].capacity[0]", "root.frame[0].bag[0]").

type("root.frame[0].bag[0].capacity[0].volume[0]","Capacity.volume").
index("root.frame[0].bag[0].capacity[0].volume[0]",0).
parent("root.frame[0].bag[0].capacity[0].volume[0]","root.frame[0].bag[0].capacity[0]").

type("root.frame[0].bag[0].capacity[0].weight[0]","Capacity.weight").
index("root.frame[0].bag[0].capacity[0].weight[0]",0).
parent("root.frame[0].bag[0].capacity[0].weight[0]","root.frame[0].bag[0].capacity[0]").

type("root.frame[0].bag[1].capacity[0]","Capacity").
index("root.frame[0].bag[1].capacity[0]",0).
parent("root.frame[0].bag[1].capacity[0]", "root.frame[0].bag[1]").

type("root.frame[0].bag[1].capacity[0].volume[0]","Capacity.volume").
index("root.frame[0].bag[1].capacity[0].volume[0]",0).
parent("root.frame[0].bag[1].capacity[0].volume[0]","root.frame[0].bag[1].capacity[0]").

type("root.frame[0].bag[1].capacity[0].weight[0]","Capacity.weight").
index("root.frame[0].bag[1].capacity[0].weight[0]",0).
parent("root.frame[0].bag[1].capacity[0].weight[0]","root.frame[0].bag[1].capacity[0]").

type("root.frame[0].bag[0].material[0]","Material").
index("root.frame[0].bag[0].material[0]",0).
parent("root.frame[0].bag[0].material[0]", "root.frame[0].bag[0]").

type("root.frame[0].bag[1].material[0]","Material").
index("root.frame[0].bag[1].material[0]",0).
parent("root.frame[0].bag[1].material[0]", "root.frame[0].bag[1]").

% Instantiated constraints
explanation(0,"The bike can have a maximum of 4 bags.").
constraint((0,"count(root.carrier.bag)+count(root.frame.bag)<=4"),"boolean").
binary("count(root.carrier.bag)+count(root.frame.bag)<=4","count(root.carrier.bag)+count(root.frame.bag)","<=","4").
binary("count(root.carrier.bag)+count(root.frame.bag)","count(root.carrier.bag)","+","count(root.frame.bag)").
function("count(root.carrier.bag)","count","root.carrier.bag").
set("root.carrier.bag","root.carrier[0].bag[0]").
set("root.carrier.bag","root.carrier[0].bag[1]").
set("root.carrier.bag","root.carrier[0].bag[2]").
function("count(root.frame.bag)","count","root.frame.bag").
set("root.frame.bag","root.frame[0].bag[0]").
set("root.frame.bag","root.frame[0].bag[1]").
number("4",4).


explanation(1,"The total weight is equal to the weight of the front wheel plus the weight of the rear wheel plus the sum of the weights of all bags on the carrier and the frame.").
constraint((1,"root.totalWeight[0]=root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)"),"boolean").
binary("root.totalWeight[0]=root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","root.totalWeight[0]","=","root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("root.frontWheel[0].weight[0]+root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","root.frontWheel[0].weight[0]","+","root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("root.rearWheel[0].weight[0]+sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","root.rearWheel[0].weight[0]","+","sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)").
binary("sum(root.carrier.bag.capacity.weight)+sum(root.frame.bag.capacity.weight)","sum(root.carrier.bag.capacity.weight)","+","sum(root.frame.bag.capacity.weight)").
function("sum(root.carrier.bag.capacity.weight)","sum","root.carrier.bag.capacity.weight").
set("root.carrier.bag.capacity.weight","root.carrier[0].bag[0].capacity[0].weight[0]").
set("root.carrier.bag.capacity.weight","root.carrier[0].bag[1].capacity[0].weight[0]").
set("root.carrier.bag.capacity.weight","root.carrier[0].bag[2].capacity[0].weight[0]").
function("sum(root.frame.bag.capacity.weight)","sum","root.frame.bag.capacity.weight").
set("root.frame.bag.capacity.weight","root.frame[0].bag[0].capacity[0].weight[0]").
set("root.frame.bag.capacity.weight","root.frame[0].bag[1].capacity[0].weight[0]").

explanation(2,"The total weight must not exceed the maximum weight.").
constraint((2,"root.totalWeight[0]<=root.maxWeight[0]*1000"),"boolean").
binary("root.totalWeight[0]<=root.maxWeight[0]*1000","root.totalWeight[0]","<=","root.maxWeight[0]*1000").
binary("root.maxWeight[0]*1000","root.maxWeight[0]","*","1000").
number("1000",1000).

explanation(3,"The total volume is equal to the sum of the volumes of all bags on the carrier and the frame.").
constraint((3,"root.totalVolume[0]=sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)"),"boolean").
binary("root.totalVolume[0]=sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)","root.totalVolume[0]","=","sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)").
binary("sum(root.carrier.bag.capacity.volume)+sum(root.frame.bag.capacity.volume)","sum(root.carrier.bag.capacity.volume)","+","sum(root.frame.bag.capacity.volume)").
function("sum(root.carrier.bag.capacity.volume)","sum","root.carrier.bag.capacity.volume").
set("root.carrier.bag.capacity.volume","root.carrier[0].bag[0].capacity[0].volume[0]").
set("root.carrier.bag.capacity.volume","root.carrier[0].bag[1].capacity[0].volume[0]").
set("root.carrier.bag.capacity.volume","root.carrier[0].bag[2].capacity[0].volume[0]").
function("sum(root.frame.bag.capacity.volume)","sum","root.frame.bag.capacity.volume").
set("root.frame.bag.capacity.volume","root.frame[0].bag[0].capacity[0].volume[0]").
set("root.frame.bag.capacity.volume","root.frame[0].bag[1].capacity[0].volume[0]").

explanation(4,"The total volume must be greater than or equal to the requested volume.").
constraint((4,"root.totalVolume[0]>=root.requestedVolume[0]"),"boolean").
binary("root.totalVolume[0]>=root.requestedVolume[0]","root.totalVolume[0]",">=","root.requestedVolume[0]").

explanation(5,"If the color is red, then the size of the front wheel must be 20.").
constraint((5,"!root.color[0]=Red||root.frontWheel[0].size[0]=20"),"boolean").
binary("!root.color[0]=Red||root.frontWheel[0].size[0]=20","!root.color[0]=Red","||","root.frontWheel[0].size[0]=20").
unary("!root.color[0]=Red","!","root.color[0]=Red").
binary("root.color[0]=Red","root.color[0]","=","Red").
constant("Red").
binary("root.frontWheel[0].size[0]=20","root.frontWheel[0].size[0]","=","20").
number("20",20).

explanation(6,"If the material of the bag is leather, then the capacity must be B10.").
constraint((6,"!root.carrier[0].bag[0].material[0]=Leather||root.carrier[0].bag[0].capacity[0]=B10"),"boolean").
binary("!root.carrier[0].bag[0].material[0]=Leather||root.carrier[0].bag[0].capacity[0]=B10","!root.carrier[0].bag[0].material[0]=Leather","||","root.carrier[0].bag[0].capacity[0]=B10").
unary("!root.carrier[0].bag[0].material[0]=Leather","!","root.carrier[0].bag[0].material[0]=Leather").
binary("root.carrier[0].bag[0].material[0]=Leather","root.carrier[0].bag[0].material[0]","=","Leather").
binary("root.carrier[0].bag[0].capacity[0]=B10","root.carrier[0].bag[0].capacity[0]","=","B10").
constant("Leather").
constant("B10").

constraint((6,"!root.carrier[0].bag[1].material[0]=Leather||root.carrier[0].bag[1].capacity[0]=B10"),"boolean").
binary("!root.carrier[0].bag[1].material[0]=Leather||root.carrier[0].bag[1].capacity[0]=B10","!root.carrier[0].bag[1].material[0]=Leather","||","root.carrier[0].bag[1].capacity[0]=B10").
unary("!root.carrier[0].bag[1].material[0]=Leather","!","root.carrier[0].bag[1].material[0]=Leather").
binary("root.carrier[0].bag[1].material[0]=Leather","root.carrier[0].bag[1].material[0]","=","Leather").
binary("root.carrier[0].bag[1].capacity[0]=B10","root.carrier[0].bag[1].capacity[0]","=","B10").

constraint((6,"!root.carrier[0].bag[2].material[0]=Leather||root.carrier[0].bag[2].capacity[0]=B10"),"boolean").
binary("!root.carrier[0].bag[2].material[0]=Leather||root.carrier[0].bag[2].capacity[0]=B10","!root.carrier[0].bag[2].material[0]=Leather","||","root.carrier[0].bag[2].capacity[0]=B10").
unary("!root.carrier[0].bag[2].material[0]=Leather","!","root.carrier[0].bag[2].material[0]=Leather").
binary("root.carrier[0].bag[2].material[0]=Leather","root.carrier[0].bag[2].material[0]","=","Leather").
binary("root.carrier[0].bag[2].capacity[0]=B10","root.carrier[0].bag[2].capacity[0]","=","B10").

constraint((6,"!root.frame[0].bag[0].material[0]=Leather||root.frame[0].bag[0].capacity[0]=B10"),"boolean").
binary("!root.frame[0].bag[0].material[0]=Leather||root.frame[0].bag[0].capacity[0]=B10","!root.frame[0].bag[0].material[0]=Leather","||","root.frame[0].bag[0].capacity[0]=B10").
unary("!root.frame[0].bag[0].material[0]=Leather","!","root.frame[0].bag[0].material[0]=Leather").
binary("root.frame[0].bag[0].material[0]=Leather","root.frame[0].bag[0].material[0]","=","Leather").
binary("root.frame[0].bag[0].capacity[0]=B10","root.frame[0].bag[0].capacity[0]","=","B10").

constraint((6,"!root.frame[0].bag[1].material[0]=Leather||root.frame[0].bag[1].capacity[0]=B10"),"boolean").
binary("!root.frame[0].bag[1].material[0]=Leather||root.frame[0].bag[1].capacity[0]=B10","!root.frame[0].bag[1].material[0]=Leather","||","root.frame[0].bag[1].capacity[0]=B10").
unary("!root.frame[0].bag[1].material[0]=Leather","!","root.frame[0].bag[1].material[0]=Leather").
binary("root.frame[0].bag[1].material[0]=Leather","root.frame[0].bag[1].material[0]","=","Leather").
binary("root.frame[0].bag[1].capacity[0]=B10","root.frame[0].bag[1].capacity[0]","=","B10").


% Attribute constraints
constraint(("Wheel","root.frontWheel[0]"),"table").
column(("Wheel","root.frontWheel[0]"),0,0,"root.frontWheel[0]").
column(("Wheel","root.frontWheel[0]"),0,1,"root.frontWheel[0].size[0]").
column(("Wheel","root.frontWheel[0]"),0,2,"root.frontWheel[0].weight[0]").

constraint(("Wheel","root.rearWheel[0]"),"table").
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


constraint(("Capacity","root.carrier[0].bag[0]"),"table").
column(("Capacity","root.carrier[0].bag[0]"),0,0,"root.carrier[0].bag[0].capacity[0]").
column(("Capacity","root.carrier[0].bag[0]"),0,1,"root.carrier[0].bag[0].capacity[0].volume[0]").
column(("Capacity","root.carrier[0].bag[0]"),0,2,"root.carrier[0].bag[0].capacity[0].weight[0]").

constraint(("Capacity","root.carrier[0].bag[1]"),"table").
column(("Capacity","root.carrier[0].bag[1]"),0,0,"root.carrier[0].bag[1].capacity[0]").
column(("Capacity","root.carrier[0].bag[1]"),0,1,"root.carrier[0].bag[1].capacity[0].volume[0]").
column(("Capacity","root.carrier[0].bag[1]"),0,2,"root.carrier[0].bag[1].capacity[0].weight[0]").

constraint(("Capacity","root.carrier[0].bag[2]"),"table").
column(("Capacity","root.carrier[0].bag[2]"),0,0,"root.carrier[0].bag[2].capacity[0]").
column(("Capacity","root.carrier[0].bag[2]"),0,1,"root.carrier[0].bag[2].capacity[0].volume[0]").
column(("Capacity","root.carrier[0].bag[2]"),0,2,"root.carrier[0].bag[2].capacity[0].weight[0]").

constraint(("Capacity","root.frame[0].bag[0]"),"table").
column(("Capacity","root.frame[0].bag[0]"),0,0,"root.frame[0].bag[0].capacity[0]").
column(("Capacity","root.frame[0].bag[0]"),0,1,"root.frame[0].bag[0].capacity[0].volume[0]").
column(("Capacity","root.frame[0].bag[0]"),0,2,"root.frame[0].bag[0].capacity[0].weight[0]").

constraint(("Capacity","root.frame[0].bag[1]"),"table").
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
constraint(("root.totalWeight",1),"lowerbound").
set("root.totalWeight","root.totalWeight[0]").

constraint(("root.maxWeight",1),"lowerbound").
set("root.maxWeight","root.maxWeight[0]").

constraint(("root.totalVolume",1),"lowerbound").
set("root.totalVolume","root.totalVolume[0]").

constraint(("root.requestedVolume",1),"lowerbound").
set("root.requestedVolume","root.requestedVolume[0]").

constraint(("root.frontWheel",1),"lowerbound").
set("root.frontWheel","root.frontWheel[0]").

constraint(("root.frontWheel[0].size",1),"lowerbound").
set("root.frontWheel[0].size","root.frontWheel[0].size[0]").

constraint(("root.frontWheel[0].weight",1),"lowerbound").
set("root.frontWheel[0].weight","root.frontWheel[0].weight[0]").

constraint(("root.rearWheel",1),"lowerbound").
set("root.rearWheel","root.rearWheel[0]").

constraint(("root.rearWheel[0].size",1),"lowerbound").
set("root.rearWheel[0].size","root.rearWheel[0].size[0]").

constraint(("root.rearWheel[0].weight",1),"lowerbound").
set("root.rearWheel[0].weight","root.rearWheel[0].weight[0]").

constraint(("root.carrier",1),"lowerbound").
set("root.carrier","root.carrier[0]").

constraint(("root.frame",1),"lowerbound").
set("root.frame","root.frame[0]").

constraint(("root.color",1),"lowerbound").
set("root.color","root.color[0]").


constraint(("root.carrier[0].bag",0),"lowerbound").
set("root.carrier[0].bag","root.carrier[0].bag[0]").
set("root.carrier[0].bag","root.carrier[0].bag[1]").
set("root.carrier[0].bag","root.carrier[0].bag[2]").

constraint(("root.carrier[0].bag[0].capacity",1),"lowerbound").
set("root.carrier[0].bag[0].capacity","root.carrier[0].bag[0].capacity[0]").

constraint(("root.carrier[0].bag[0].capacity[0].volume",1),"lowerbound").
set("root.carrier[0].bag[0].capacity[0].volume","root.carrier[0].bag[0].capacity[0].volume[0]").

constraint(("root.carrier[0].bag[0].capacity[0].weight",1),"lowerbound").
set("root.carrier[0].bag[0].capacity[0].weight","root.carrier[0].bag[0].capacity[0].weight[0]").

constraint(("root.carrier[0].bag[0].material",1),"lowerbound").
set("root.carrier[0].bag[0].material","root.carrier[0].bag[0].material[0]").

constraint(("root.carrier[0].bag[1].capacity",1),"lowerbound").
set("root.carrier[0].bag[1].capacity","root.carrier[0].bag[1].capacity[0]").

constraint(("root.carrier[0].bag[1].capacity[0].volume",1),"lowerbound").
set("root.carrier[0].bag[1].capacity[0].volume","root.carrier[0].bag[1].capacity[0].volume[0]").

constraint(("root.carrier[0].bag[1].capacity[0].weight",1),"lowerbound").
set("root.carrier[0].bag[1].capacity[0].weight","root.carrier[0].bag[1].capacity[0].weight[0]").

constraint(("root.carrier[0].bag[1].material",1),"lowerbound").
set("root.carrier[0].bag[1].material","root.carrier[0].bag[1].material[0]").

constraint(("root.carrier[0].bag[2].capacity",1),"lowerbound").
set("root.carrier[0].bag[2].capacity","root.carrier[0].bag[2].capacity[0]").

constraint(("root.carrier[0].bag[2].capacity[0].volume",1),"lowerbound").
set("root.carrier[0].bag[2].capacity[0].volume","root.carrier[0].bag[2].capacity[0].volume[0]").

constraint(("root.carrier[0].bag[2].capacity[0].weight",1),"lowerbound").
set("root.carrier[0].bag[2].capacity[0].weight","root.carrier[0].bag[2].capacity[0].weight[0]").

constraint(("root.carrier[0].bag[2].material",1),"lowerbound").
set("root.carrier[0].bag[2].material","root.carrier[0].bag[2].material[0]").


constraint(("root.frame[0].bag",0),"lowerbound").
set("root.frame[0].bag","root.frame[0].bag[0]").
set("root.frame[0].bag","root.frame[0].bag[1]").

constraint(("root.frame[0].bag[0].capacity",1),"lowerbound").
set("root.frame[0].bag[0].capacity","root.frame[0].bag[0].capacity[0]").

constraint(("root.frame[0].bag[0].capacity[0].volume",1),"lowerbound").
set("root.frame[0].bag[0].capacity[0].volume","root.frame[0].bag[0].capacity[0].volume[0]").

constraint(("root.frame[0].bag[0].capacity[0].weight",1),"lowerbound").
set("root.frame[0].bag[0].capacity[0].weight","root.frame[0].bag[0].capacity[0].weight[0]").

constraint(("root.frame[0].bag[0].material",1),"lowerbound").
set("root.frame[0].bag[0].material","root.frame[0].bag[0].material[0]").

constraint(("root.frame[0].bag[1].capacity",1),"lowerbound").
set("root.frame[0].bag[1].capacity","root.frame[0].bag[1].capacity[0]").

constraint(("root.frame[0].bag[1].capacity[0].volume",1),"lowerbound").
set("root.frame[0].bag[1].capacity[0].volume","root.frame[0].bag[1].capacity[0].volume[0]").

constraint(("root.frame[0].bag[1].capacity[0].weight",1),"lowerbound").
set("root.frame[0].bag[1].capacity[0].weight","root.frame[0].bag[1].capacity[0].weight[0]").

constraint(("root.frame[0].bag[1].material",1),"lowerbound").
set("root.frame[0].bag[1].material","root.frame[0].bag[1].material[0]").
