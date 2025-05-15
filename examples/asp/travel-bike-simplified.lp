part("product").
part("Carrier").
part("Frame").

integer("product.totalVolume").
range("product.totalVolume",0,200).

integer("product.requestedVolume").
range("product.requestedVolume",200,200).

discrete("Bag").
domain("Bag","B20").
domain("Bag","B50").
domain("Bag","B100").

discrete("Bag.volume").
domain("Bag.volume",20).
domain("Bag.volume",50).
domain("Bag.volume",100).

type("root","product").
type("root.totalVolume[0]","product.totalVolume").
type("root.requestedVolume[0]","product.requestedVolume").
type("root.carrier[0]","Carrier").
type("root.frame[0]","Frame").
type("root.frame[0].bag[0]","Bag").
type("root.frame[0].bag[1]","Bag").
type("root.carrier[0].bag[0]","Bag").
type("root.carrier[0].bag[1]","Bag").
type("root.carrier[0].bag[2]","Bag").
type("root.frame[0].bag[0].volume[0]","Bag.volume").
type("root.frame[0].bag[1].volume[0]","Bag.volume").
type("root.carrier[0].bag[0].volume[0]","Bag.volume").
type("root.carrier[0].bag[1].volume[0]","Bag.volume").
type("root.carrier[0].bag[2].volume[0]","Bag.volume").

index("root.totalVolume[0]",0).
index("root.requestedVolume[0]",0).
index("root.carrier[0]",0).
index("root.frame[0]",0).
index("root.frame[0].bag[0]",0).
index("root.frame[0].bag[1]",1).
index("root.carrier[0].bag[0]",0).
index("root.carrier[0].bag[1]",1).
index("root.carrier[0].bag[2]",2).
index("root.carrier[0].bag[2].volume[0]",0).
index("root.carrier[0].bag[1].volume[0]",0).
index("root.carrier[0].bag[0].volume[0]",0).
index("root.frame[0].bag[1].volume[0]",0).
index("root.frame[0].bag[0].volume[0]",0).

parent("root.totalVolume[0]","root").
parent("root.requestedVolume[0]","root").
parent("root.carrier[0]","root").
parent("root.frame[0]","root").
parent("root.frame[0].bag[0]","root.frame[0]").
parent("root.frame[0].bag[1]","root.frame[0]").
parent("root.carrier[0].bag[0]","root.carrier[0]").
parent("root.carrier[0].bag[1]","root.carrier[0]").
parent("root.carrier[0].bag[2]","root.carrier[0]").
parent("root.carrier[0].bag[2].volume[0]","root.carrier[0].bag[2]").
parent("root.carrier[0].bag[1].volume[0]","root.carrier[0].bag[1]").
parent("root.carrier[0].bag[0].volume[0]","root.carrier[0].bag[0]").
parent("root.frame[0].bag[1].volume[0]","root.frame[0].bag[1]").
parent("root.frame[0].bag[0].volume[0]","root.frame[0].bag[0]").

explanation(0,"The bike can have a maximum of 4 bags.").
constraint((0,"count(root.carrier.bag)+count(root.frame.bag)<=4"),"boolean").
binary("count(root.carrier.bag)+count(root.frame.bag)<=4","count(root.carrier.bag)+count(root.frame.bag)","<=","4").
binary("count(root.carrier.bag)+count(root.frame.bag)","count(root.carrier.bag)","+","count(root.frame.bag)").
function("count(root.carrier.bag)","count","root.carrier.bag").
set("root.carrier[0].bag[0]","root.carrier.bag").
set("root.carrier[0].bag[1]","root.carrier.bag").
set("root.carrier[0].bag[2]","root.carrier.bag").
function("count(root.frame.bag)","count","root.frame.bag").
set("root.frame[0].bag[0]","root.frame.bag").
set("root.frame[0].bag[1]","root.frame.bag").
number("4",4).

explanation(1,"The total volume is equal to the sum of the volumes of all bags on the carrier and the frame.").
constraint((1,"root.totalVolume[0]=sum(root.carrier.bag.volume)+sum(root.frame.bag.volume)"),"boolean").
binary("root.totalVolume[0]=sum(root.carrier.bag.volume)+sum(root.frame.bag.volume)","root.totalVolume[0]","=","sum(root.carrier.bag.volume)+sum(root.frame.bag.volume)").
binary("sum(root.carrier.bag.volume)+sum(root.frame.bag.volume)","sum(root.carrier.bag.volume)","+","sum(root.frame.bag.volume)").
function("sum(root.carrier.bag.volume)","sum","root.carrier.bag.volume").
set("root.carrier[0].bag[2].volume[0]","root.carrier.bag.volume").
set("root.carrier[0].bag[1].volume[0]","root.carrier.bag.volume").
set("root.carrier[0].bag[0].volume[0]","root.carrier.bag.volume").
function("sum(root.frame.bag.volume)","sum","root.frame.bag.volume").
set("root.frame[0].bag[1].volume[0]","root.frame.bag.volume").
set("root.frame[0].bag[0].volume[0]","root.frame.bag.volume").

explanation(2,"The total volume must be greater than or equal to the requested volume.").
constraint((2,"root.totalVolume[0]>=root.requestedVolume[0]"),"boolean").
binary("root.totalVolume[0]>=root.requestedVolume[0]","root.totalVolume[0]",">=","root.requestedVolume[0]").

constraint(("Bag","root.frame[0].bag[0]"),"table").
constraint(("Bag","root.frame[0].bag[1]"),"table").
constraint(("Bag","root.carrier[0].bag[0]"),"table").
constraint(("Bag","root.carrier[0].bag[1]"),"table").
constraint(("Bag","root.carrier[0].bag[2]"),"table").
column(("Bag","root.frame[0].bag[0]"),0,1,"root.frame[0].bag[0].volume[0]").
column(("Bag","root.frame[0].bag[1]"),0,1,"root.frame[0].bag[1].volume[0]").
column(("Bag","root.carrier[0].bag[0]"),0,1,"root.carrier[0].bag[0].volume[0]").
column(("Bag","root.carrier[0].bag[1]"),0,1,"root.carrier[0].bag[1].volume[0]").
column(("Bag","root.carrier[0].bag[2]"),0,1,"root.carrier[0].bag[2].volume[0]").
column(("Bag","root.frame[0].bag[0]"),0,0,"root.frame[0].bag[0]").
column(("Bag","root.frame[0].bag[1]"),0,0,"root.frame[0].bag[1]").
column(("Bag","root.carrier[0].bag[0]"),0,0,"root.carrier[0].bag[0]").
column(("Bag","root.carrier[0].bag[1]"),0,0,"root.carrier[0].bag[1]").
column(("Bag","root.carrier[0].bag[2]"),0,0,"root.carrier[0].bag[2]").
allow("Bag",(0,1),"B20").
allow("Bag",(0,2),"B50").
allow("Bag",(0,0),"B100").
allow("Bag",(1,0),100).
allow("Bag",(1,2),50).
allow("Bag",(1,1),20).

constraint(("root.totalVolume",1),"lowerbound").
constraint(("root.requestedVolume",1),"lowerbound").
constraint(("root.carrier",1),"lowerbound").
constraint(("root.frame",1),"lowerbound").
constraint(("root.carrier[0].bag",0),"lowerbound").
constraint(("root.frame[0].bag",0),"lowerbound").
constraint(("root.frame[0].bag[0].volume",1),"lowerbound").
constraint(("root.frame[0].bag[1].volume",1),"lowerbound").
constraint(("root.carrier[0].bag[0].volume",1),"lowerbound").
constraint(("root.carrier[0].bag[1].volume",1),"lowerbound").
constraint(("root.carrier[0].bag[2].volume",1),"lowerbound").
set("root.totalVolume[0]","root.totalVolume").
set("root.requestedVolume[0]","root.requestedVolume").
set("root.carrier[0]","root.carrier").
set("root.frame[0]","root.frame").
set("root.carrier[0].bag[0]","root.carrier[0].bag").
set("root.carrier[0].bag[1]","root.carrier[0].bag").
set("root.carrier[0].bag[2]","root.carrier[0].bag").
set("root.frame[0].bag[0]","root.frame[0].bag").
set("root.frame[0].bag[1]","root.frame[0].bag").
set("root.frame[0].bag[0].volume[0]","root.frame[0].bag[0].volume").
set("root.frame[0].bag[1].volume[0]","root.frame[0].bag[1].volume").
set("root.carrier[0].bag[0].volume[0]","root.carrier[0].bag[0].volume").
set("root.carrier[0].bag[1].volume[0]","root.carrier[0].bag[1].volume").
set("root.carrier[0].bag[2].volume[0]","root.carrier[0].bag[2].volume").
