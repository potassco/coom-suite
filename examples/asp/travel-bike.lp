structure("").
feature("",totalWeight,"num",1,1).
range("",totalWeight,1,10000).
feature("",maxWeight,"num",1,1).
range("",maxWeight,1,10).
feature("",totalVolume,"num",1,1).
range("",totalVolume,0,200).
feature("",requestedVolume,"num",1,1).
range("",requestedVolume,0,200).
feature("",frontWheel,"Wheel",1,1).
feature("",rearWheel,"Wheel",1,1).
feature("",frame,"Frame",1,1).
feature("",carrier,"Carrier",1,1).
feature("",color,"Color",1,1).

structure("Carrier").
feature("Carrier",bags,"Bag",0,3).

structure("Frame").
feature("Frame",bags,"Bag",0,2).

structure("Bag").
feature("Bag",capacity,"Capacity",1,1).
feature("Bag",material,"Material",1,1).

enumeration("Capacity").
attribute("Capacity",volume,"num").
attribute("Capacity",weight,"num").
option("Capacity", "B10").
attr_value("Capacity","B10",volume,10).
attr_value("Capacity","B10",weight,100).
option("Capacity", "B20").
attr_value("Capacity","B20",volume,20).
attr_value("Capacity","B20",weight,250).
option("Capacity", "B50").
attr_value("Capacity","B50",volume,50).
attr_value("Capacity","B50",weight,600).
option("Capacity", "B100").
attr_value("Capacity","B100",volume,100).
attr_value("Capacity","B100",weight,1200).

enumeration("Material").
option("Material", "Cotton").
option("Material", "Leather").
option("Material", "Polyester").

enumeration("Wheel").
attribute("Wheel",size,"num").
attribute("Wheel",weight,"num").
option("Wheel", "W20").
attr_value("Wheel","W20",size,20).
attr_value("Wheel","W20",weight,650).
option("Wheel", "W22").
attr_value("Wheel","W22",size,22).
attr_value("Wheel","W22",weight,700).
option("Wheel", "W24").
attr_value("Wheel","W24",size,24).
attr_value("Wheel","W24",weight,800).
option("Wheel", "W26").
attr_value("Wheel","W26",size,26).
attr_value("Wheel","W26",weight,900).
option("Wheel", "W28").
attr_value("Wheel","W28",size,28).
attr_value("Wheel","W28",weight,1000).

enumeration("Color").
option("Color", "Red").
option("Color", "Green").
option("Color", "Yellow").
option("Color", "Blue").

behavior(0).
context(0,"").
require(0,"count(carrier.bags)+count(frame.bags)<=4").
binary("","count(carrier.bags)+count(frame.bags)<=4","count(carrier.bags)+count(frame.bags)","<=","4").
binary("","count(carrier.bags)+count(frame.bags)","count(carrier.bags)","+","count(frame.bags)").
function("","count(carrier.bags)","count","carrier.bags").
path("carrier.bags",0,carrier).
path("carrier.bags",1,bags).
function("","count(frame.bags)","count","frame.bags").
path("frame.bags",0,frame).
path("frame.bags",1,bags).
number("4",4).

behavior(1).
context(1,"").
imply(1,totalWeight,"frontWheel.weight+rearWheel.weight+sum(carrier.bags.capacity.weight)+sum(frame.bags.capacity.weight)").
path("totalWeight",0,totalWeight).
binary("","frontWheel.weight+rearWheel.weight+sum(carrier.bags.capacity.weight)+sum(frame.bags.capacity.weight)","frontWheel.weight","+","rearWheel.weight+sum(carrier.bags.capacity.weight)+sum(frame.bags.capacity.weight)").
binary("","rearWheel.weight+sum(carrier.bags.capacity.weight)+sum(frame.bags.capacity.weight)","rearWheel.weight","+","sum(carrier.bags.capacity.weight)+sum(frame.bags.capacity.weight)").
binary("","sum(carrier.bags.capacity.weight)+sum(frame.bags.capacity.weight)","sum(carrier.bags.capacity.weight)","+","sum(frame.bags.capacity.weight)").
path("frontWheel.weight",0,frontWheel).
path("frontWheel.weight",1,weight).
path("rearWheel.weight",0,rearWheel).
path("rearWheel.weight",1,weight).
function("","sum(carrier.bags.capacity.weight)","sum","carrier.bags.capacity.weight").
path("carrier.bags.capacity.weight",0,carrier).
path("carrier.bags.capacity.weight",1,bags).
path("carrier.bags.capacity.weight",2,capacity).
path("carrier.bags.capacity.weight",3,weight).
function("","sum(frame.bags.capacity.weight)","sum","frame.bags.capacity.weight").
path("frame.bags.capacity.weight",0,frame).
path("frame.bags.capacity.weight",1,bags).
path("frame.bags.capacity.weight",2,capacity).
path("frame.bags.capacity.weight",3,weight).

behavior(2).
context(2,"").
require(2,"totalWeight<=maxWeight*1000").
binary("","totalWeight<=maxWeight*1000","totalWeight","<=","maxWeight*1000").
path("totalWeight",0,totalWeight).
binary("","maxWeight*1000","maxWeight","*","1000").
path("maxWeight",0,maxWeight).
number("1000",1000).

behavior(3).
context(3,"").
imply(3,totalVolume,"sum(carrier.bags.capacity.volume)+sum(frame.bags.capacity.volume)").
path("totalVolume",0,totalVolume).
binary("","sum(carrier.bags.capacity.volume)+sum(frame.bags.capacity.volume)","sum(carrier.bags.capacity.volume)","+","sum(frame.bags.capacity.volume)").
function("","sum(carrier.bags.capacity.volume)","sum","carrier.bags.capacity.volume").
path("carrier.bags.capacity.volume",0,carrier).
path("carrier.bags.capacity.volume",1,bags).
path("carrier.bags.capacity.volume",2,capacity).
path("carrier.bags.capacity.volume",3,volume).
function("","sum(frame.bags.capacity.volume)","sum","frame.bags.capacity.volume").
path("frame.bags.capacity.volume",0,frame).
path("frame.bags.capacity.volume",1,bags).
path("frame.bags.capacity.volume",2,capacity).
path("frame.bags.capacity.volume",3,volume).

behavior(4).
context(4,"").
require(4,"totalVolume>=requestedVolume").
binary("","totalVolume>=requestedVolume","totalVolume",">=","requestedVolume").
path("totalVolume",0,totalVolume).
path("requestedVolume",0,requestedVolume).

behavior(5).
context(5,"").
condition(5,"color=Red").
binary("","color=Red","color","=","Red").
path("color",0,color).
constant("Red").
require(5,"frontWheel.size=20").
binary("","frontWheel.size=20","frontWheel.size","=","20").
path("frontWheel.size",0,frontWheel).
path("frontWheel.size",1,size).
number("20",20).

behavior(6).
context(6,"Bag").
condition(6,"material=Leather").
binary("Bag","material=Leather","material","=","Leather").
path("material",0,material).
constant("Leather").
require(6,"capacity=B10").
binary("Bag","capacity=B10","capacity","=","B10").
path("capacity",0,capacity).
constant("B10").
