% Parts of the model
part("root").

% Attributes of the model
discrete("Color").
domain("Color","Red").
domain("Color","Green").
domain("Color","Yellow").
domain("Color","Blue").

discrete("Wheel").
domain("Wheel","W14").
domain("Wheel","W16").
domain("Wheel","W18").
domain("Wheel","W20").

discrete("Wheel.size").
domain("Wheel.size",14).
domain("Wheel.size",16).
domain("Wheel.size",18).
domain("Wheel.size",20).

discrete("Bool").
domain("Bool", "True").
domain("Bool", "False").

% Complete instance tree
type("root","product").

type("root.color[0]","Color").
parent("root.color[0]","root").
index("root.color[0]",0).

type("root.frontWheel[0]","Wheel").
parent("root.frontWheel[0]","root").
index("root.frontWheel[0]",0).

type("root.frontWheel[0].size[0]","Wheel.size").
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").
index("root.frontWheel[0].size[0]",0).

type("root.rearWheel[0]","Wheel").
parent("root.rearWheel[0]","root").
index("root.rearWheel[0]",0).

type("root.rearWheel[0].size[0]","Wheel.size").
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").
index("root.rearWheel[0].size[0]",0).

type("root.wheelSupport[0]","Bool").
parent("root.wheelSupport[0]", "root").
index("root.wheelSupport[0]",0).

% Instantiated constraints
explanation(0,"If the color is yellow, then the size of the front wheel must be greater than 16.").
constraint((0,"!root.color[0]=Yellow||root.frontWheel[0].size[0]>16"),"boolean").
binary("!root.color[0]=Yellow||root.frontWheel[0].size[0]>16","!root.color[0]=Yellow","||","root.frontWheel[0].size[0]>16").
unary("!root.color[0]=Yellow","!","root.color[0]=Yellow").
binary("root.color[0]=Yellow","root.color[0]","=","Yellow").
constant("Yellow").
binary("root.frontWheel[0].size[0]>16","root.frontWheel[0].size[0]",">","16").
number("16",16).

explanation(1,"A wheel support can only be used with rear wheels of type W14 or W16.").
constraint((1,"root"),"table").
column((1,"root"),0,0,"root.wheelSupport[0]").
column((1,"root"),0,1,"root.rearWheel[0]").
allow(1,(0,0),"True").
allow(1,(1,0),"W14").
allow(1,(1,0),"W16").
allow(1,(0,1),"False").
allow(1,(1,1),"W18").
allow(1,(1,1),"W20").

explanation(2,"The size of the front wheel must be equal to the size of the rear wheel.").
constraint((2,"root.frontWheel[0].size[0]=root.rearWheel[0].size[0]"),"boolean").
binary("root.frontWheel[0].size[0]=root.rearWheel[0].size[0]","root.frontWheel[0].size[0]","=","root.rearWheel[0].size[0]").

% Attribute constraints
constraint(("Wheel","root.frontWheel[0]"),"table").
column(("Wheel","root.frontWheel[0]"),0,0,"root.frontWheel[0]").
column(("Wheel","root.frontWheel[0]"),0,1,"root.frontWheel[0].size[0]").

constraint(("Wheel","root.rearWheel[0]"),"table").
column(("Wheel","root.rearWheel[0]"),0,0,"root.rearWheel[0]").
column(("Wheel","root.rearWheel[0]"),0,1,"root.rearWheel[0].size[0]").

allow("Wheel",(0,0),"W14").
allow("Wheel",(1,0),14).
allow("Wheel",(0,1),"W16").
allow("Wheel",(1,1),16).
allow("Wheel",(0,2),"W18").
allow("Wheel",(1,2),18).
allow("Wheel",(0,3),"W20").
allow("Wheel",(1,3),20).

% Cardinality constraints
% only need to check for min, not possible to exceed max as all possible objects are instantiated before
constraint(("root.color",1),"lowerbound").
set("root.color","root.color[0]").

constraint(("root.wheelSupport",1),"lowerbound").
set("root.wheelSupport","root.wheelSupport[0]").

constraint(("root.frontWheel",1),"lowerbound").
set("root.frontWheel","root.frontWheel[0]").

constraint(("root.frontWheel[0].size",1),"lowerbound").
set("root.frontWheel[0].size","root.frontWheel[0].size[0]").

constraint(("root.rearWheel",1),"lowerbound").
set("root.rearWheel","root.rearWheel[0]").

constraint(("root.rearWheel[0].size",1),"lowerbound").
set("root.rearWheel[0].size","root.rearWheel[0].size[0]").
