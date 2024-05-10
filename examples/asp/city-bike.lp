structure("").
feature("",color,"Color",1,1).
feature("",basket,"Basket",0,1).
feature("",saddle,"Saddle",1,1).
feature("",frontWheel,"Wheel",1,1).
feature("",rearWheel,"Wheel",1,1).
feature("",carrier,"Carrier",1,1).

structure("Basket").
feature("Basket",position,"Position",1,1).
feature("Basket",color,"Color",1,1).

structure("Carrier").
feature("Carrier",bag,"Bag",0,2).

structure("Bag").
feature("Bag",capacity,"Capacity",1,1).
feature("Bag",material,"Material",1,1).

enumeration("Color").
option("Color", "Silver").
option("Color", "White").
option("Color", "Black").
option("Color", "Blue").

enumeration("Position").
option("Position", "Front").
option("Position", "Back").

enumeration("Saddle").
option("Saddle", "Standard").
option("Saddle", "Comfort").
option("Saddle", "Vintage").

enumeration("Wheel").
attribute("Wheel",size,"num").
option("Wheel", "W26").
attr_value("Wheel","W26",size,26).
option("Wheel", "W27").
attr_value("Wheel","W27",size,27).
option("Wheel", "W28").
attr_value("Wheel","W28",size,28).
option("Wheel", "W29").
attr_value("Wheel","W29",size,29).

enumeration("Capacity").
attribute("Capacity",volume,"num").
option("Capacity", "B10").
attr_value("Capacity","B10",volume,10).
option("Capacity", "B20").
attr_value("Capacity","B20",volume,20).
option("Capacity", "B50").
attr_value("Capacity","B50",volume,50).
option("Capacity", "B100").
attr_value("Capacity","B100",volume,100).

enumeration("Material").
option("Material", "Cotton").
option("Material", "Leather").
option("Material", "Polyester").

behavior(0).
context(0,"").
require(0,"color=basket.color").
binary("","color=basket.color","color","=","basket.color").
path("color",0,color).
path("basket.color",0,basket).
path("basket.color",1,color).

behavior(1).
context(1,"").
condition(1,"basket.position=Front").
binary("","basket.position=Front","basket.position","=","Front").
path("basket.position",0,basket).
path("basket.position",1,position).
constant("Front").
require(1,"frontWheel.size<29").
binary("","frontWheel.size<29","frontWheel.size","<","29").
path("frontWheel.size",0,frontWheel).
path("frontWheel.size",1,size).
number("29",29).

behavior(2).
context(2,"").
condition(2,"carrier.bag.capacity.volume=100").
binary("","carrier.bag.capacity.volume=100","carrier.bag.capacity.volume","=","100").
path("carrier.bag.capacity.volume",0,carrier).
path("carrier.bag.capacity.volume",1,bag).
path("carrier.bag.capacity.volume",2,capacity).
path("carrier.bag.capacity.volume",3,volume).
number("100",100).
require(2,"rearWheel.size>=28").
binary("","rearWheel.size>=28","rearWheel.size",">=","28").
path("rearWheel.size",0,rearWheel).
path("rearWheel.size",1,size).
number("28",28).

behavior(3).
context(3,"").
condition(3,"saddle=Vintage").
binary("","saddle=Vintage","saddle","=","Vintage").
path("saddle",0,saddle).
constant("Vintage").
require(3,"carrier.bag.material=Leather").
binary("","carrier.bag.material=Leather","carrier.bag.material","=","Leather").
path("carrier.bag.material",0,carrier).
path("carrier.bag.material",1,bag).
path("carrier.bag.material",2,material).
constant("Leather").

behavior(4).
context(4,"").
require(4,"frontWheel.size=rearWheel.size").
binary("","frontWheel.size=rearWheel.size","frontWheel.size","=","rearWheel.size").
path("frontWheel.size",0,frontWheel).
path("frontWheel.size",1,size).
path("rearWheel.size",0,rearWheel).
path("rearWheel.size",1,size).

behavior(5).
context(5,"Bag").
combinations(5,0,"material").
combinations(5,1,"capacity").
path("material",0,material).
path("capacity",0,capacity).
allow(5,(0,0),"Leather").
allow(5,(1,0),"B10").
allow(5,(0,1),"Cotton").
allow(5,(1,1),"B20").
allow(5,(1,1),"B50").
allow(5,(0,2),"Polyester").
allow(5,(1,2),"B20").
allow(5,(1,2),"B50").
allow(5,(1,2),"B100").
