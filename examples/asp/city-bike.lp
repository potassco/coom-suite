% Parts of the model
part("root").
part("Basket").
part("Carrier").
part("Bag").

% Attributes of the model
discrete("Color").
domain("Color", "Silver").
domain("Color", "White").
domain("Color", "Black").
domain("Color", "Blue").

discrete("Position").
domain("Position", "Front").
domain("Position", "Back").

discrete("Saddle").
domain("Saddle", "Standard").
domain("Saddle", "Comfort").
domain("Saddle", "Vintage").

discrete("Wheel").
domain("Wheel", "W26").
domain("Wheel", "W27").
domain("Wheel", "W28").
domain("Wheel", "W29").

integer("Wheel.size").
range("Wheel.size",26,29).
% domain("Wheel.size",26).
% domain("Wheel.size",27).
% domain("Wheel.size",28).
% domain("Wheel.size",29).

discrete("Capacity").
domain("Capacity", "B10").
domain("Capacity", "B20").
domain("Capacity", "B50").
domain("Capacity", "B100").

integer("Capacity.volume").
range("Capacity.volume",10,100).
% domain("Capacity.volume",10).
% domain("Capacity.volume",20).
% domain("Capacity.volume",50).
% domain("Capacity.volume",100).

discrete("Material").
domain("Material", "Cotton").
domain("Material", "Leather").
domain("Material", "Polyester").

% Complete instance tree
type("root","product").

type("root.carrier[0]","Carrier").
index("root.carrier[0]",0).
parent("root.carrier[0]", "root").

type("root.basket[0]","Basket").
index("root.basket[0]",0).
parent("root.basket[0]", "root").

type("root.carrier[0].bag[0]","Bag").
index("root.carrier[0].bag[0]",0).
parent("root.carrier[0].bag[0]", "root.carrier[0]").

type("root.carrier[0].bag[1]","Bag").
index("root.carrier[0].bag[1]",1).
parent("root.carrier[0].bag[1]", "root.carrier[0]").

type("root.color[0]","Color").
index("root.color[0]",0).
parent("root.color[0]", "root").

type("root.saddle[0]","Saddle").
index("root.saddle[0]",0).
parent("root.saddle[0]", "root").

type("root.frontWheel[0]","Wheel").
index("root.frontWheel[0]",0).
parent("root.frontWheel[0]", "root").

type("root.frontWheel[0].size[0]","Wheel.size").
index("root.frontWheel[0].size[0]",0).
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").

type("root.rearWheel[0]","Wheel").
index("root.rearWheel[0]",0).
parent("root.rearWheel[0]", "root").

type("root.rearWheel[0].size[0]","Wheel.size").
index("root.rearWheel[0].size[0]",0).
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").

type("root.basket[0].color[0]","Color").
index("root.basket[0].color[0]",0).
parent("root.basket[0].color[0]","root.basket[0]").

type("root.basket[0].position[0]","Position").
index("root.basket[0].position[0]",0).
parent("root.basket[0].position[0]","root.basket[0]").

type("root.carrier[0].bag[0].capacity[0]","Capacity").
index("root.carrier[0].bag[0].capacity[0]",0).
parent("root.carrier[0].bag[0].capacity[0]", "root.carrier[0].bag[0]").

type("root.carrier[0].bag[0].capacity[0].volume[0]","Capacity.volume").
index("root.carrier[0].bag[0].capacity[0].volume[0]",0).
parent("root.carrier[0].bag[0].capacity[0].volume[0]","root.carrier[0].bag[0].capacity[0]").

type("root.carrier[0].bag[1].capacity[0]","Capacity").
index("root.carrier[0].bag[1].capacity[0]",0).
parent("root.carrier[0].bag[1].capacity[0]", "root.carrier[0].bag[1]").

type("root.carrier[0].bag[1].capacity[0].volume[0]","Capacity.volume").
index("root.carrier[0].bag[1].capacity[0].volume[0]",0).
parent("root.carrier[0].bag[1].capacity[0].volume[0]","root.carrier[0].bag[1].capacity[0]").

type("root.carrier[0].bag[0].material[0]","Material").
index("root.carrier[0].bag[0].material[0]",0).
parent("root.carrier[0].bag[0].material[0]", "root.carrier[0].bag[0]").

type("root.carrier[0].bag[1].material[0]","Material").
index("root.carrier[0].bag[1].material[0]",0).
parent("root.carrier[0].bag[1].material[0]", "root.carrier[0].bag[1]").


% Instantiated constraints
constraint((0,"root.color[0]=root.basket[0].color[0]"),"boolean").
binary("root.color[0]=root.basket[0].color[0]","root.color[0]","=","root.basket[0].color[0]").


constraint((1,"!root.basket[0].position[0]=Front||root.frontWheel[0].size[0]<29"),"boolean").
binary("!root.basket[0].position[0]=Front||root.frontWheel[0].size[0]<29","!root.basket[0].position[0]=Front","||","root.frontWheel[0].size[0]<29").
unary("!root.basket[0].position[0]=Front","!","root.basket[0].position[0]=Front").
binary("root.basket[0].position[0]=Front","root.basket[0].position[0]","=","Front").
constant("Front").
binary("root.frontWheel[0].size[0]<29","root.frontWheel[0].size[0]","<","29").
number("29",29).


constraint((2,"!root.carrier[0].bag[0].capacity[0].volume[0]=100||root.rearWheel[0].size[0]>=28"),"boolean").
binary("!root.carrier[0].bag[0].capacity[0].volume[0]=100||root.rearWheel[0].size[0]>=28","!root.carrier[0].bag[0].capacity[0].volume[0]=100","||","root.rearWheel[0].size[0]>=28").
unary("!root.carrier[0].bag[0].capacity[0].volume[0]=100","!","root.carrier[0].bag[0].capacity[0].volume[0]=100").
binary("root.carrier[0].bag[0].capacity[0].volume[0]=100","root.carrier[0].bag[0].capacity[0].volume[0]","=","100").
binary("root.rearWheel[0].size[0]>=28","root.rearWheel[0].size[0]",">=","28").

constraint((2,"!root.carrier[0].bag[1].capacity[0].volume[0]=100||root.rearWheel[0].size[0]>=28"),"boolean").
binary("!root.carrier[0].bag[1].capacity[0].volume[0]=100||root.rearWheel[0].size[0]>=28","!root.carrier[0].bag[1].capacity[0].volume[0]=100","||","root.rearWheel[0].size[0]>=28").
unary("!root.carrier[0].bag[1].capacity[0].volume[0]=100","!","root.carrier[0].bag[1].capacity[0].volume[0]=100").
binary("root.carrier[0].bag[1].capacity[0].volume[0]=100","root.carrier[0].bag[1].capacity[0].volume[0]","=","100").
binary("root.rearWheel[0].size[0]>=28","root.rearWheel[0].size[0]",">=","28").

number("100",100).
number("28",28).


constraint((3,"!root.saddle[0]=Vintage||root.carrier[0].bag[0].material[0]=Leather"),"boolean").
binary("!root.saddle[0]=Vintage||root.carrier[0].bag[0].material[0]=Leather","!root.saddle[0]=Vintage","||","root.carrier[0].bag[0].material[0]=Leather").
unary("!root.saddle[0]=Vintage","!","root.saddle[0]=Vintage").
binary("root.saddle[0]=Vintage","root.saddle[0]","=","Vintage").
binary("root.carrier[0].bag[0].material[0]=Leather","root.carrier[0].bag[0].material[0]","=","Leather").

constraint((3,"!root.saddle[0]=Vintage||root.carrier[0].bag[1].material[0]=Leather"),"boolean").
binary("!root.saddle[0]=Vintage||root.carrier[0].bag[1].material[0]=Leather","!root.saddle[0]=Vintage","||","root.carrier[0].bag[1].material[0]=Leather").
unary("!root.saddle[0]=Vintage","!","root.saddle[0]=Vintage").
binary("root.saddle[0]=Vintage","root.saddle[0]","=","Vintage").
binary("root.carrier[0].bag[1].material[0]=Leather","root.carrier[0].bag[1].material[0]","=","Leather").

constant("Vintage").
constant("Leather").


constraint((4,"root.frontWheel[0].size[0]=root.rearWheel[0].size[0]"),"boolean").
binary("root.frontWheel[0].size[0]=root.rearWheel[0].size[0]","root.frontWheel[0].size[0]","=","root.rearWheel[0].size[0]").


constraint((5,"root.carrier[0].bag[0]"),"table").
column((5,"root.carrier[0].bag[0]"),0,0,"root.carrier[0].bag[0].material[0]").
column((5,"root.carrier[0].bag[0]"),0,1,"root.carrier[0].bag[0].capacity[0]").

constraint((5,"root.carrier[0].bag[1]"),"table").
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
constraint(("Wheel","root.frontWheel[0]"),"table").
column(("Wheel","root.frontWheel[0]"),0,0,"root.frontWheel[0]").
column(("Wheel","root.frontWheel[0]"),0,1,"root.frontWheel[0].size[0]").

constraint(("Wheel","root.rearWheel[0]"),"table").
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


constraint(("Capacity","root.carrier[0].bag[0]"),"table").
column(("Capacity","root.carrier[0].bag[0]"),0,0,"root.carrier[0].bag[0].capacity[0]").
column(("Capacity","root.carrier[0].bag[0]"),0,1,"root.carrier[0].bag[0].capacity[0].volume[0]").

constraint(("Capacity","root.carrier[0].bag[1]"),"table").
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


% Cardinality constraints
% only need to check for min, not possible to exceed max as all possible objects are instantiated before
constraint(("root.color",1),"lowerbound").
path("root.color[0]","root.color").

constraint(("root.basket",0),"lowerbound").
path("root.basket[0]","root.basket").

constraint(("root.saddle",1),"lowerbound").
path("root.saddle[0]","root.saddle").

constraint(("root.frontWheel",1),"lowerbound").
path("root.frontWheel[0]","root.frontWheel").

constraint(("root.frontWheel[0].size",1),"lowerbound").
path("root.frontWheel[0].size[0]","root.frontWheel[0].size").

constraint(("root.rearWheel",1),"lowerbound").
path("root.rearWheel[0]","root.rearWheel").

constraint(("root.rearWheel[0].size",1),"lowerbound").
path("root.rearWheel[0].size[0]","root.rearWheel[0].size").

constraint(("root.carrier",1),"lowerbound").
path("root.carrier[0]","root.carrier").

constraint(("root.basket[0].position",1),"lowerbound").
path("root.basket[0].position[0]","root.basket[0].position").

constraint(("root.basket[0].color",1),"lowerbound").
path("root.basket[0].color[0]","root.basket[0].color").

constraint(("root.carrier[0].bag",0),"lowerbound").
path("root.carrier[0].bag[0]","root.carrier[0].bag").
path("root.carrier[0].bag[1]","root.carrier[0].bag").

constraint(("root.carrier[0].bag[0].capacity",1),"lowerbound").
path("root.carrier[0].bag[0].capacity[0]","root.carrier[0].bag[0].capacity").

constraint(("root.carrier[0].bag[0].capacity[0].volume",1),"lowerbound").
path("root.carrier[0].bag[0].capacity[0].volume[0]","root.carrier[0].bag[0].capacity[0].volume").

constraint(("root.carrier[0].bag[0].material",1),"lowerbound").
path("root.carrier[0].bag[0].material[0]","root.carrier[0].bag[0].material").

constraint(("root.carrier[0].bag[1].capacity",1),"lowerbound").
path("root.carrier[0].bag[1].capacity[0]","root.carrier[0].bag[1].capacity").

constraint(("root.carrier[0].bag[1].capacity[0].volume",1),"lowerbound").
path("root.carrier[0].bag[1].capacity[0].volume[0]","root.carrier[0].bag[1].capacity[0].volume").

constraint(("root.carrier[0].bag[1].material",1),"lowerbound").
path("root.carrier[0].bag[1].material[0]","root.carrier[0].bag[1].material").
