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
feature("Carrier",bag,"Bag",0,3).

structure("Frame").
feature("Frame",bag,"Bag",0,2).

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
require(0,"count(carrier.bag)+count(frame.bag)<=4").
binary("","count(carrier.bag)+count(frame.bag)<=4","count(carrier.bag)+count(frame.bag)","<=","4").
binary("","count(carrier.bag)+count(frame.bag)","count(carrier.bag)","+","count(frame.bag)").
function("","count(carrier.bag)","count","carrier.bag").
path("carrier.bag",0,carrier).
path("carrier.bag",1,bag).
function("","count(frame.bag)","count","frame.bag").
path("frame.bag",0,frame).
path("frame.bag",1,bag).
number("4",4).

behavior(1).
context(1,"").
imply(1,totalWeight,"frontWheel.weight+rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
path("totalWeight",0,totalWeight).
binary("","frontWheel.weight+rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","frontWheel.weight","+","rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
binary("","rearWheel.weight+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","rearWheel.weight","+","sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
binary("","sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","sum(carrier.bag.capacity.weight)","+","sum(frame.bag.capacity.weight)").
path("frontWheel.weight",0,frontWheel).
path("frontWheel.weight",1,weight).
path("rearWheel.weight",0,rearWheel).
path("rearWheel.weight",1,weight).
function("","sum(carrier.bag.capacity.weight)","sum","carrier.bag.capacity.weight").
path("carrier.bag.capacity.weight",0,carrier).
path("carrier.bag.capacity.weight",1,bag).
path("carrier.bag.capacity.weight",2,capacity).
path("carrier.bag.capacity.weight",3,weight).
function("","sum(frame.bag.capacity.weight)","sum","frame.bag.capacity.weight").
path("frame.bag.capacity.weight",0,frame).
path("frame.bag.capacity.weight",1,bag).
path("frame.bag.capacity.weight",2,capacity).
path("frame.bag.capacity.weight",3,weight).

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
imply(3,totalVolume,"sum(carrier.bag.capacity.volume)+sum(frame.bag.capacity.volume)").
path("totalVolume",0,totalVolume).
binary("","sum(carrier.bag.capacity.volume)+sum(frame.bag.capacity.volume)","sum(carrier.bag.capacity.volume)","+","sum(frame.bag.capacity.volume)").
function("","sum(carrier.bag.capacity.volume)","sum","carrier.bag.capacity.volume").
path("carrier.bag.capacity.volume",0,carrier).
path("carrier.bag.capacity.volume",1,bag).
path("carrier.bag.capacity.volume",2,capacity).
path("carrier.bag.capacity.volume",3,volume).
function("","sum(frame.bag.capacity.volume)","sum","frame.bag.capacity.volume").
path("frame.bag.capacity.volume",0,frame).
path("frame.bag.capacity.volume",1,bag).
path("frame.bag.capacity.volume",2,capacity).
path("frame.bag.capacity.volume",3,volume).

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
