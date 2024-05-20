% Original "COOM" fact format describing the structure of the model
structure("product").
feature("product","color","Color",1,1).
feature("product","basket","Basket",0,1).
feature("product","saddle","Saddle",1,1).
feature("product","frontWheel","Wheel",1,1).
feature("product","rearWheel","Wheel",1,1).
feature("product","carrier","Carrier",1,1).

structure("Basket").
feature("Basket","position","Position",1,1).
feature("Basket","color","Color",1,1).

structure("Carrier").
feature("Carrier","bag","Bag",0,2).

structure("Bag").
feature("Bag","capacity","Capacity",1,1).
feature("Bag","material","Material",1,1).

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
attribute("Wheel","size","num").
option("Wheel", "W26").
attribute_value("Wheel","W26","size",26).
option("Wheel", "W27").
attribute_value("Wheel","W27","size",27).
option("Wheel", "W28").
attribute_value("Wheel","W28","size",28).
option("Wheel", "W29").
attribute_value("Wheel","W29","size",29).

enumeration("Capacity").
attribute("Capacity","volume","num").
option("Capacity", "B10").
attribute_value("Capacity","B10","volume",10).
option("Capacity", "B20").
attribute_value("Capacity","B20","volume",20).
option("Capacity", "B50").
attribute_value("Capacity","B50","volume",50).
option("Capacity", "B100").
attribute_value("Capacity","B100","volume",100).

enumeration("Material").
option("Material", "Cotton").
option("Material", "Leather").
option("Material", "Polyester").

% Complete generated instance tree
type("root","product").

type("root.carrier[0]","Carrier").
index("root.carrier[0]",0).
parent("root.carrier[0]", "root").
feature("root.carrier[0]","carrier").

type("root.basket[0]","Basket").
index("root.basket[0]",0).
parent("root.basket[0]", "root").
feature("root.basket[0]","basket").

type("root.carrier[0].bag[0]","Bag").
index("root.carrier[0].bag[0]",0).
parent("root.carrier[0].bag[0]", "root.carrier[0]").
feature("root.carrier[0].bag[0]","bag").

type("root.carrier[0].bag[1]","Bag").
index("root.carrier[0].bag[1]",1).
parent("root.carrier[0].bag[1]", "root.carrier[0]").
feature("root.carrier[0].bag[1]","bag").

type("root.color[0]","Color").
parent("root.color[0]", "root").
feature("root.color[0]","color").

type("root.saddle[0]","Saddle").
parent("root.saddle[0]", "root").
feature("root.saddle[0]","saddle").

type("root.frontWheel[0]","Wheel").
parent("root.frontWheel[0]", "root").
feature("root.frontWheel[0]","frontWheel").

type("root.frontWheel[0].size[0]","size").
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").
isnumeric("root.frontWheel[0].size[0]").

type("root.rearWheel[0]","Wheel").
parent("root.rearWheel[0]", "root").
feature("root.rearWheel[0]","rearWheel").

type("root.rearWheel[0].size[0]","size").
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").
isnumeric("root.rearWheel[0].size[0]").

type("root.basket[0].root.color[0]","Color").
parent("root.basket[0].root.color[0]","root.basket[0]").
feature("root.basket[0].root.color[0]","color").

type("root.basket[0].position[0]","Position").
parent("root.basket[0].position[0]","root.basket[0]").
feature("root.basket[0].position[0]","position").

type("root.carrier[0].bag[0].capacity[0]","Capacity").
parent("root.carrier[0].bag[0].capacity[0]", "root.carrier[0].bag[0]").
feature("root.carrier[0].bag[0].capacity[0]","capacity").

type("root.carrier[0].bag[0].capacity[0].volume[0]","volume").
parent("root.carrier[0].bag[0].capacity[0].volume[0]","root.carrier[0].bag[0].capacity[0]").
isnumeric("root.carrier[0].bag[0].capacity[0].volume[0]").

type("root.carrier[0].bag[1].capacity[0]","Capacity").
parent("root.carrier[0].bag[1].capacity[0]", "root.carrier[0].bag[1]").
feature("root.carrier[0].bag[1].capacity[0]","capacity").

type("root.carrier[0].bag[1].capacity[0].volume[0]","volume").
parent("root.carrier[0].bag[1].capacity[0].volume[0]","root.carrier[0].bag[1].capacity[0]").
isnumeric("root.carrier[0].bag[1].capacity[0].volume[0]").

type("root.carrier[0].bag[0].material[0]","Material").
parent("root.carrier[0].bag[0].material[0]", "root.carrier[0].bag[0]").
feature("root.carrier[0].bag[0].material[0]","material").

type("root.carrier[0].bag[1].material[0]","Material").
parent("root.carrier[0].bag[1].material[0]", "root.carrier[0].bag[1]").
feature("root.carrier[0].bag[1].material[0]","material").


% Instantiated constraints on complete instance tree
constraint((0,"root")).
require((0,"root"),"root.color[0]=root.basket[0].root.color[0]").
binary("root.color[0]=root.basket[0].root.color[0]","root.color[0]","=","root.basket[0].root.color[0]").


constraint((1,"root")).
condition(1).
condition((1,"root"),"root.basket[0].position[0]=Front").
binary("root.basket[0].position[0]=Front","root.basket[0].position[0]","=","Front").
constant("Front").
require((1,"root"),"root.frontWheel[0].size[0]<29").
binary("root.frontWheel[0].size[0]<29","root.frontWheel[0].size[0]","<","29").
number("29",29).


constraint((2,"root")).
condition(2).
condition((2,"root"),"root.carrier[0].bag[0].capacity[0].volume[0]=100").
binary("root.carrier[0].bag[0].capacity[0].volume[0]=100","root.carrier[0].bag[0].capacity[0].volume[0]","=","100").
require((2,"root"),"root.rearWheel[0].size[0]>=28").
binary("root.rearWheel[0].size[0]>=28","root.rearWheel[0].size[0]",">=","28").


condition((2,"root"),"root.carrier[0].bag[1].capacity[0].volume[0]=100").
binary("root.carrier[0].bag[1].capacity[0].volume[0]=100","root.carrier[0].bag[1].capacity[0].volume[0]","=","100").
require((2,"root"),"root.rearWheel[0].size[0]>=28").
binary("root.rearWheel[0].size[0]>=28","root.rearWheel[0].size[0]",">=","28").

number("100",100).
number("28",28).


constraint((3,"root")).
condition(3).
condition((3,"root"),"root.saddle[0]=Vintage").
binary("root.saddle[0]=Vintage","root.saddle[0]","=","Vintage").
require((3,"root"),"root.carrier[0].bag[0].material[0]=Leather").
binary("root.carrier[0].bag[0].material[0]=Leather","root.carrier[0].bag[0].material[0]","=","Leather").

condition((3,"root"),"root.saddle[0]=Vintage").
binary("root.saddle[0]=Vintage","root.saddle[0]","=","Vintage").
require((3,"root"),"root.carrier[0].bag[1].material[0]=Leather").
binary("root.carrier[0].bag[1].material[0]=Leather","root.carrier[0].bag[1].material[0]","=","Leather").

constant("Vintage").
constant("Leather").


constraint((4,"root")).
require((4,"root"),"root.frontWheel[0].size[0]=root.rearWheel[0].size[0]").
binary("root.frontWheel[0].size[0]=root.rearWheel[0].size[0]","root.frontWheel[0].size[0]","=","root.rearWheel[0].size[0]").


constraint((5,"root.carrier[0].bag[0]")).
combinations((5,"root.carrier[0].bag[0]"),0,0,"root.carrier[0].bag[0].material[0]").
combinations((5,"root.carrier[0].bag[0]"),0,1,"root.carrier[0].bag[0].capacity[0]").

constraint((5,"root.carrier[0].bag[1]")).
combinations((5,"root.carrier[0].bag[1]"),0,0,"root.carrier[0].bag[1].material[0]").
combinations((5,"root.carrier[0].bag[1]"),0,1,"root.carrier[0].bag[1].capacity[0]").

allow(5,(0,0),"Leather").
allow(5,(1,0),"B10").
allow(5,(0,1),"Cotton").
allow(5,(1,1),"B20").
allow(5,(1,1),"B50").
allow(5,(0,2),"Polyester").
allow(5,(1,2),"B20").
allow(5,(1,2),"B50").
allow(5,(1,2),"B100").
