% Structure of the model
part("product").
% cardinality("product","color",1,1).
% cardinality("product","wheelSupport",1,1).
% cardinality("product","frontWheel",1,1).
% cardinality("product","rearWheel",1,1).
% Or use multiplicity? And one atom for each range?
% cardinality("frontWheel","size",1,1).
% cardinality("rearWheel","size",1,1).

% feature("product","color","Color",1,1).
% feature("product","wheelSupport","bool",1,1).
% feature("product","frontWheel","Wheel",1,1).
% feature("product","rearWheel","Wheel",1,1).

attribute("Color","discrete").
domain("Color","Red").
domain("Color","Green").
domain("Color","Yellow").
domain("Color","Blue").

attribute("Wheel","discrete").
domain("Wheel","W14").
% attribute("Wheel","W14","size",14).
domain("Wheel","W16").
% attribute("Wheel","W16","size",16).
domain("Wheel","W18").
% attribute("Wheel","W18","size",18).
domain("Wheel","W20").
% attribute("Wheel","W20","size",20).

attribute("size","numeric").
domain("size",14).
domain("size",16).
domain("size",18).
domain("size",20).

% Complete generated instance tree
type("root","product").

type("root.color[0]","Color").
parent("root.color[0]", "root").
feature("root.color[0]","color").

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

type("root.wheelSupport[0]","bool").
parent("root.wheelSupport[0]", "root").
feature("root.wheelSupport[0]","wheelSupport").

% Instantiated constraints on complete instance tree
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


constraint(("Wheel.size","root.frontWheel[0]")).
column(("Wheel.size","root.frontWheel[0]"),0,0,"root.frontWheel[0]").
column(("Wheel.size","root.frontWheel[0]"),0,1,"root.frontWheel[0].size[0]").

constraint(("Wheel.size","root.rearWheel[0]")).
column(("Wheel.size","root.rearWheel[0]"),0,0,"root.rearWheel[0]").
column(("Wheel.size","root.rearWheel[0]"),0,1,"root.rearWheel[0].size[0]").

allow("Wheel.size",(0,0),"W14").
allow("Wheel.size",(1,0),14).
allow("Wheel.size",(0,1),"W16").
allow("Wheel.size",(1,1),16).
allow("Wheel.size",(0,2),"W18").
allow("Wheel.size",(1,2),18).
allow("Wheel.size",(0,3),"W20").
allow("Wheel.size",(1,3),20).
