% Original "COOM" fact format describing the structure of the model
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

% Complete generated instance tree
structure_instance(":root",":root",0).

structure_instance("carrier[0]","Carrier",0).
parent("carrier[0]", ":root").
feature("carrier[0]",carrier).

structure_instance("basket[0]","Basket",0).
parent("basket[0]", ":root").
feature("basket[0]",basket).

structure_instance("carrier[0].bag[0]","Bag",0).
parent("carrier[0].bag[0]", "carrier[0]").
feature("carrier[0].bag[0]",bag).

structure_instance("carrier[0].bag[1]","Bag",1).
parent("carrier[0].bag[1]", "carrier[0]").
feature("carrier[0].bag[1]",bag).

enumeration_instance("color[0]","Color").
parent("color[0]", ":root").
feature("color[0]",color).


enumeration_instance("saddle[0]","Saddle").
parent("saddle[0]", ":root").
feature("saddle[0]",saddle).

enumeration_instance("frontWheel[0]","Wheel").
parent("frontWheel[0]", ":root").
feature("frontWheel[0]",frontWheel).
attr_instance("frontWheel[0].size","frontWheel[0]").

enumeration_instance("rearWheel[0]","Wheel").
parent("rearWheel[0]", ":root").
feature("rearWheel[0]",rearWheel).
attr_instance("rearWheel[0].size","rearWheel[0]").

enumeration_instance("basket[0].color[0]","Color").
parent("basket[0].color[0]","basket[0]").
feature("basket[0].color[0]",color).

enumeration_instance("basket[0].position[0]","Position").
parent("basket[0].position[0]","basket[0]").
feature("basket[0].position[0]",position).


enumeration_instance("carrier[0].bag[0].capacity[0]","Capacity").
parent("carrier[0].bag[0].capacity[0]", "carrier[0].bag[0]").
feature("carrier[0].bag[0].capacity[0]",capacity).
attr_instance("carrier[0].bag[0].capacity[0].volume","carrier[0].bag[0].capacity[0]").

enumeration_instance("carrier[0].bag[1].capacity[0]","Capacity").
parent("carrier[0].bag[1].capacity[0]", "carrier[0].bag[1]").
feature("carrier[0].bag[1].capacity[0]",capacity).
attr_instance("carrier[0].bag[1].capacity[0].volume","carrier[0].bag[1].capacity[0]").

enumeration_instance("carrier[0].bag[0].material[0]","Material").
parent("carrier[0].bag[0].material[0]", "carrier[0].bag[0]").
feature("carrier[0].bag[0].material[0]",material).

enumeration_instance("carrier[0].bag[1].material[0]","Material").
parent("carrier[0].bag[1].material[0]", "carrier[0].bag[1]").
feature("carrier[0].bag[1].material[0]",material).


% Instantiated constraints on complete instance tree
constraint(0).
require(0,"color[0]=basket[0].color[0]").
binary("color[0]=basket[0].color[0]","color[0]","=","basket[0].color[0]").

constraint(1).
condition(1,"basket[0].position[0]=Front").
binary("basket[0].position[0]=Front","basket[0].position[0]","=","Front").
constant("Front").
require(1,"frontWheel[0].size<29").
binary("frontWheel[0].size<29","frontWheel[0].size","<","29").
number("29",29).

constraint((2,0)).
condition((2,0),"carrier[0].bag[0].capacity[0].volume=100").
binary("carrier[0].bag[0].capacity[0].volume=100","carrier[0].bag[0].capacity[0].volume","=","100").
number("100",100).
require((2,0),"rearWheel[0].size>=28").
binary("rearWheel[0].size>=28","rearWheel[0].size",">=","28").
number("28",28).

constraint((2,1)).
condition((2,1),"carrier[0].bag[1].capacity[0].volume=100").
binary("carrier[0].bag[1].capacity[0].volume=100","carrier[0].bag[1].capacity[0].volume","=","100").
require((2,1),"rearWheel[0].size>=28").
binary("rearWheel[0].size>=28","rearWheel[0].size",">=","28").

constraint((3,0)).
condition((3,0),"saddle[0]=Vintage").
binary("saddle[0]=Vintage","saddle[0]","=","Vintage").
constant("Vintage").
require((3,0),"carrier[0].bag[0].material[0]=Leather").
binary("carrier[0].bag[0].material[0]=Leather","carrier[0].bag[0].material[0]","=","Leather").
constant("Leather").

constraint((3,1)).
condition((3,1),"saddle[0]=Vintage").
binary("saddle[0]=Vintage","saddle[0]","=","Vintage").
require((3,1),"carrier[0].bag[1].material[0]=Leather").
binary("carrier[0].bag[1].material[0]=Leather","carrier[0].bag[1].material[0]","=","Leather").

constraint(4).
require(4,"frontWheel[0].size=rearWheel[0].size").
binary("frontWheel[0].size=rearWheel[0].size","frontWheel[0].size","=","rearWheel[0].size").

constraint((5,0)).
combinations((5,0),0,"carrier[0].bag[0].material[0]").
combinations((5,0),1,"carrier[0].bag[0].capacity[0]").

constraint((5,1)).
combinations((5,1),0,"carrier[0].bag[1].material[0]").
combinations((5,1),1,"carrier[0].bag[1].capacity[0]").
allow(5,(0,0),"Leather").
allow(5,(1,0),"B10").
allow(5,(0,1),"Cotton").
allow(5,(1,1),"B20").
allow(5,(1,1),"B50").
allow(5,(0,2),"Polyester").
allow(5,(1,2),"B20").
allow(5,(1,2),"B50").
allow(5,(1,2),"B100").
