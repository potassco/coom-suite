% Attributes of the model
attribute("Color","discrete").
domain("Color","Red").
domain("Color","Green").
domain("Color","Yellow").
domain("Color","Blue").

attribute("Wheel","discrete").
domain("Wheel","W14").
domain("Wheel","W16").
domain("Wheel","W18").
domain("Wheel","W20").

attribute("Wheel.size","numeric").
domain("Wheel.size",14).
domain("Wheel.size",16).
domain("Wheel.size",18).
domain("Wheel.size",20).

% Complete instance tree
type("root","product").

type("root.color[0]","Color").
parent("root.color[0]", "root").
feature("root.color[0]","color").

type("root.frontWheel[0]","Wheel").
parent("root.frontWheel[0]", "root").
feature("root.frontWheel[0]","frontWheel").

type("root.frontWheel[0].size[0]","Wheel.size").
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").
isnumeric("root.frontWheel[0].size[0]").

type("root.rearWheel[0]","Wheel").
parent("root.rearWheel[0]", "root").
feature("root.rearWheel[0]","rearWheel").

type("root.rearWheel[0].size[0]","Wheel.size").
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").
isnumeric("root.rearWheel[0].size[0]").

type("root.wheelSupport[0]","bool").
parent("root.wheelSupport[0]", "root").
feature("root.wheelSupport[0]","wheelSupport").

% Instantiated constraints
constraint((0,"root")).
condition(0).
condition((0,"root"),"root.color[0]=Yellow").
binary("root.color[0]=Yellow","root.color[0]","=","Yellow").
constant("Yellow").
require((0,"root"),"root.frontWheel[0].size[0]>16").
binary("root.frontWheel[0].size[0]>16","root.frontWheel[0].size[0]",">","16").
number("16",16).


constraint((1,"root")).
column((1,"root"),0,0,"root.wheelSupport[0]").
column((1,"root"),0,1,"root.rearWheel[0]").
allow(1,(0,0),"True").
allow(1,(1,0),"W14").
allow(1,(1,0),"W16").
allow(1,(0,1),"False").
allow(1,(1,1),"W18").
allow(1,(1,1),"W20").


constraint((2,"root")).
require((2,"root"),"root.frontWheel[0].size[0]=root.rearWheel[0].size[0]").
binary("root.frontWheel[0].size[0]=root.rearWheel[0].size[0]","root.frontWheel[0].size[0]","=","root.rearWheel[0].size[0]").

% Attribute constraints
constraint(("Wheel","root.frontWheel[0]")).
column(("Wheel","root.frontWheel[0]"),0,0,"root.frontWheel[0]").
column(("Wheel","root.frontWheel[0]"),0,1,"root.frontWheel[0].size[0]").

constraint(("Wheel","root.rearWheel[0]")).
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
