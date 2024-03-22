structure(":root").
feature(":root",color,"Color",1,1).
feature(":root",basket,"Basket",0,1).
feature(":root",saddle,"Saddle",1,1).
feature(":root",frontWheel,"Wheel",1,1).
feature(":root",rearWheel,"Wheel",1,1).
feature(":root",carrier,"Carrier",1,1).

structure("Basket").
feature("Basket",position,"Position",1,1).
feature("Basket",color,"Color",1,1).

structure("Carrier").
feature("Carrier",bag,"Bag",2,2).

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

behavior((":root",0)).
require((":root",0),"color=basket.color").
binary(":root","color=basket.color","color","=","basket.color").
path("color",0,color).
path("basket.color",0,basket).
path("basket.color",1,color).

behavior((":root",1)).
condition((":root",1),"basket.position=Front").
binary(":root","basket.position=Front","basket.position","=","Front").
path("basket.position",0,basket).
path("basket.position",1,position).
constant("Front").
require((":root",1),"frontWheel.size<29").
binary(":root","frontWheel.size<29","frontWheel.size","<","29").
path("frontWheel.size",0,frontWheel).
path("frontWheel.size",1,size).
number("29",29).

behavior((":root",2)).
condition((":root",2),"carrier.bag.capacity.volume=100").
binary(":root","carrier.bag.capacity.volume=100","carrier.bag.capacity.volume","=","100").
path("carrier.bag.capacity.volume",0,carrier).
path("carrier.bag.capacity.volume",1,bag).
path("carrier.bag.capacity.volume",2,capacity).
path("carrier.bag.capacity.volume",3,volume).
number("100",100).
require((":root",2),"rearWheel.size>=28").
binary(":root","rearWheel.size>=28","rearWheel.size",">=","28").
path("rearWheel.size",0,rearWheel).
path("rearWheel.size",1,size).
number("28",28).

behavior((":root",3)).
condition((":root",3),"saddle=Vintage").
binary(":root","saddle=Vintage","saddle","=","Vintage").
path("saddle",0,saddle).
constant("Vintage").
require((":root",3),"carrier.bag.material=Leather").
binary(":root","carrier.bag.material=Leather","carrier.bag.material","=","Leather").
path("carrier.bag.material",0,carrier).
path("carrier.bag.material",1,bag).
path("carrier.bag.material",2,material).
constant("Leather").

behavior((":root",4)).
require((":root",4),"frontWheel.size=rearWheel.size").
binary(":root","frontWheel.size=rearWheel.size","frontWheel.size","=","rearWheel.size").
path("frontWheel.size",0,frontWheel).
path("frontWheel.size",1,size).
path("rearWheel.size",0,rearWheel).
path("rearWheel.size",1,size).

behavior(("Bag",5)).
combinations(("Bag",5),0,"material").
combinations(("Bag",5),1,"capacity").
path("material",0,material).
path("capacity",0,capacity).
allow(("Bag",5),(0,0),"Leather").
allow(("Bag",5),(1,0),"B10").
allow(("Bag",5),(0,1),"Cotton").
allow(("Bag",5),(1,1),"B20").
allow(("Bag",5),(1,1),"B50").
allow(("Bag",5),(0,2),"Polyester").
allow(("Bag",5),(1,2),"B20").
allow(("Bag",5),(1,2),"B50").
allow(("Bag",5),(1,2),"B100").
