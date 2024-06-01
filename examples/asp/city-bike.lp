% Partonomy of the model
cardinality("product","color",1,1).
cardinality("product","basket",0,1).
cardinality("product","saddle",1,1).
cardinality("product","frontWheel",1,1).
cardinality("product","rearWheel",1,1).
cardinality("product","carrier",1,1).

part("Basket").
cardinality("Basket","position",1,1).
cardinality("Basket","color",1,1).

part("Carrier").
cardinality("Carrier","bag",0,2).

part("Bag").
cardinality("Bag","capacity",1,1).
cardinality("Bag","material",1,1).

% Attributes of the model
attribute("Color","discrete").
domain("Color", "Silver").
domain("Color", "White").
domain("Color", "Black").
domain("Color", "Blue").

attribute("Position","discrete").
domain("Position", "Front").
domain("Position", "Back").

attribute("Saddle","discrete").
domain("Saddle", "Standard").
domain("Saddle", "Comfort").
domain("Saddle", "Vintage").

attribute("Wheel","discrete").
domain("Wheel", "W26").
domain("Wheel", "W27").
domain("Wheel", "W28").
domain("Wheel", "W29").

attribute("Wheel.size","numeric").
domain("Wheel.size",26).
domain("Wheel.size",27).
domain("Wheel.size",28).
domain("Wheel.size",29).

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

attribute("Material","discrete").
domain("Material", "Cotton").
domain("Material", "Leather").
domain("Material", "Polyester").

% Complete instance tree
type("root","product").

type("root.carrier[0]","Carrier").
index("root.carrier[0]",0).
parent("root.carrier[0]", "root").
name("root.carrier[0]","carrier").

type("root.basket[0]","Basket").
index("root.basket[0]",0).
parent("root.basket[0]", "root").
name("root.basket[0]","basket").

type("root.carrier[0].bag[0]","Bag").
index("root.carrier[0].bag[0]",0).
parent("root.carrier[0].bag[0]", "root.carrier[0]").
name("root.carrier[0].bag[0]","bag").

type("root.carrier[0].bag[1]","Bag").
index("root.carrier[0].bag[1]",1).
parent("root.carrier[0].bag[1]", "root.carrier[0]").
name("root.carrier[0].bag[1]","bag").

type("root.color[0]","Color").
parent("root.color[0]", "root").
name("root.color[0]","color").

type("root.saddle[0]","Saddle").
parent("root.saddle[0]", "root").
name("root.saddle[0]","saddle").

type("root.frontWheel[0]","Wheel").
parent("root.frontWheel[0]", "root").
name("root.frontWheel[0]","frontWheel").

type("root.frontWheel[0].size[0]","Wheel.size").
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").
isnumeric("root.frontWheel[0].size[0]").

type("root.rearWheel[0]","Wheel").
parent("root.rearWheel[0]", "root").
name("root.rearWheel[0]","rearWheel").

type("root.rearWheel[0].size[0]","Wheel.size").
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").
isnumeric("root.rearWheel[0].size[0]").

type("root.basket[0].root.color[0]","Color").
parent("root.basket[0].root.color[0]","root.basket[0]").
name("root.basket[0].root.color[0]","color").

type("root.basket[0].position[0]","Position").
parent("root.basket[0].position[0]","root.basket[0]").
name("root.basket[0].position[0]","position").

type("root.carrier[0].bag[0].capacity[0]","Capacity").
parent("root.carrier[0].bag[0].capacity[0]", "root.carrier[0].bag[0]").
name("root.carrier[0].bag[0].capacity[0]","capacity").

type("root.carrier[0].bag[0].capacity[0].volume[0]","Capacity.volume").
parent("root.carrier[0].bag[0].capacity[0].volume[0]","root.carrier[0].bag[0].capacity[0]").
isnumeric("root.carrier[0].bag[0].capacity[0].volume[0]").

type("root.carrier[0].bag[1].capacity[0]","Capacity").
parent("root.carrier[0].bag[1].capacity[0]", "root.carrier[0].bag[1]").
name("root.carrier[0].bag[1].capacity[0]","capacity").

type("root.carrier[0].bag[1].capacity[0].volume[0]","Capacity.volume").
parent("root.carrier[0].bag[1].capacity[0].volume[0]","root.carrier[0].bag[1].capacity[0]").
isnumeric("root.carrier[0].bag[1].capacity[0].volume[0]").

type("root.carrier[0].bag[0].material[0]","Material").
parent("root.carrier[0].bag[0].material[0]", "root.carrier[0].bag[0]").
name("root.carrier[0].bag[0].material[0]","material").

type("root.carrier[0].bag[1].material[0]","Material").
parent("root.carrier[0].bag[1].material[0]", "root.carrier[0].bag[1]").
name("root.carrier[0].bag[1].material[0]","material").


% Instantiated constraints
constraint(0,"root.color[0]=root.basket[0].root.color[0]").
binary("root.color[0]=root.basket[0].root.color[0]","root.color[0]","=","root.basket[0].root.color[0]").



constraint(1,"!root.basket[0].position[0]=Front||root.frontWheel[0].size[0]<29").
binary("!root.basket[0].position[0]=Front||root.frontWheel[0].size[0]<29","!root.basket[0].position[0]=Front","||","root.frontWheel[0].size[0]<29").
unary("!root.basket[0].position[0]=Front","!","root.basket[0].position[0]=Front").
binary("root.basket[0].position[0]=Front","root.basket[0].position[0]","=","Front").
constant("Front").
binary("root.frontWheel[0].size[0]<29","root.frontWheel[0].size[0]","<","29").
number("29",29).


constraint(2,"!root.carrier[0].bag[0].capacity[0].volume[0]=100||root.rearWheel[0].size[0]>=28").
binary("!root.carrier[0].bag[0].capacity[0].volume[0]=100||root.rearWheel[0].size[0]>=28","!root.carrier[0].bag[0].capacity[0].volume[0]=100","||","root.rearWheel[0].size[0]>=28").
unary("!root.carrier[0].bag[0].capacity[0].volume[0]=100","!","root.carrier[0].bag[0].capacity[0].volume[0]=100").
binary("root.carrier[0].bag[0].capacity[0].volume[0]=100","root.carrier[0].bag[0].capacity[0].volume[0]","=","100").
binary("root.rearWheel[0].size[0]>=28","root.rearWheel[0].size[0]",">=","28").

constraint(2,"!root.carrier[0].bag[1].capacity[0].volume[0]=100||root.rearWheel[0].size[0]>=28").
binary("!root.carrier[0].bag[1].capacity[0].volume[0]=100||root.rearWheel[0].size[0]>=28","!root.carrier[0].bag[1].capacity[0].volume[0]=100","||","root.rearWheel[0].size[0]>=28").
unary("!root.carrier[0].bag[1].capacity[0].volume[0]=100","!","root.carrier[0].bag[1].capacity[0].volume[0]=100").
binary("root.carrier[0].bag[1].capacity[0].volume[0]=100","root.carrier[0].bag[1].capacity[0].volume[0]","=","100").
binary("root.rearWheel[0].size[0]>=28","root.rearWheel[0].size[0]",">=","28").

number("100",100).
number("28",28).


constraint(3,"!root.saddle[0]=Vintage||root.carrier[0].bag[0].material[0]=Leather").
binary("!root.saddle[0]=Vintage||root.carrier[0].bag[0].material[0]=Leather","!root.saddle[0]=Vintage","||","root.carrier[0].bag[0].material[0]=Leather").
unary("!root.saddle[0]=Vintage","!","root.saddle[0]=Vintage").
binary("root.saddle[0]=Vintage","root.saddle[0]","=","Vintage").
binary("root.carrier[0].bag[0].material[0]=Leather","root.carrier[0].bag[0].material[0]","=","Leather").

constraint(3,"!root.saddle[0]=Vintage||root.carrier[0].bag[1].material[0]=Leather").
binary("!root.saddle[0]=Vintage||root.carrier[0].bag[1].material[0]=Leather","!root.saddle[0]=Vintage","||","root.carrier[0].bag[1].material[0]=Leather").
unary("!root.saddle[0]=Vintage","!","root.saddle[0]=Vintage").
binary("root.saddle[0]=Vintage","root.saddle[0]","=","Vintage").
binary("root.carrier[0].bag[1].material[0]=Leather","root.carrier[0].bag[1].material[0]","=","Leather").

constant("Vintage").
constant("Leather").


constraint(4,"root.frontWheel[0].size[0]=root.rearWheel[0].size[0]").
binary("root.frontWheel[0].size[0]=root.rearWheel[0].size[0]","root.frontWheel[0].size[0]","=","root.rearWheel[0].size[0]").


constraint((5,"root.carrier[0].bag[0]")).
column((5,"root.carrier[0].bag[0]"),0,0,"root.carrier[0].bag[0].material[0]").
column((5,"root.carrier[0].bag[0]"),0,1,"root.carrier[0].bag[0].capacity[0]").

constraint((5,"root.carrier[0].bag[1]")).
column((5,"root.carrier[0].bag[1]"),0,0,"root.carrier[0].bag[1].material[0]").
column((5,"root.carrier[0].bag[1]"),0,1,"root.carrier[0].bag[1].capacity[0]").

allow(5,(0,0),"Leather").
allow(5,(1,0),"B10").
allow(5,(0,1),"Cotton").
allow(5,(1,1),"B20").
allow(5,(1,1),"B50").
allow(5,(0,2),"Polyester").
allow(5,(1,2),"B20").
allow(5,(1,2),"B50").
allow(5,(1,2),"B100").

% Attribute constraints
constraint(("Wheel","root.frontWheel[0]")).
column(("Wheel","root.frontWheel[0]"),0,0,"root.frontWheel[0]").
column(("Wheel","root.frontWheel[0]"),0,1,"root.frontWheel[0].size[0]").

constraint(("Wheel","root.rearWheel[0]")).
column(("Wheel","root.rearWheel[0]"),0,0,"root.rearWheel[0]").
column(("Wheel","root.rearWheel[0]"),0,1,"root.rearWheel[0].size[0]").

allow("Wheel",(0,0),"W26").
allow("Wheel",(1,0),26).
allow("Wheel",(0,1),"W27").
allow("Wheel",(1,1),27).
allow("Wheel",(0,2),"W28").
allow("Wheel",(1,2),28).
allow("Wheel",(0,3),"W29").
allow("Wheel",(1,3),29).


constraint(("Capacity","root.carrier[0].bag[0]")).
column(("Capacity","root.carrier[0].bag[0]"),0,0,"root.carrier[0].bag[0].capacity[0]").
column(("Capacity","root.carrier[0].bag[0]"),0,1,"root.carrier[0].bag[0].capacity[0].volume[0]").

constraint(("Capacity","root.carrier[0].bag[1]")).
column(("Capacity","root.carrier[0].bag[1]"),0,0,"root.carrier[0].bag[1].capacity[0]").
column(("Capacity","root.carrier[0].bag[1]"),0,1,"root.carrier[0].bag[1].capacity[0].volume[0]").

allow("Capacity",(0,0),"B10").
allow("Capacity",(1,0),10).
allow("Capacity",(0,1),"B20").
allow("Capacity",(1,1),20).
allow("Capacity",(0,2),"B50").
allow("Capacity",(1,2),50).
allow("Capacity",(0,3),"B100").
allow("Capacity",(1,3),100).
