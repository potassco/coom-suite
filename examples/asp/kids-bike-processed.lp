% Original "COOM" fact format describing the structure of the model
structure("product").
feature("product","color","Color",1,1).
feature("product","wheelSupport","bool",1,1).
feature("product","frontWheel","Wheel",1,1).
feature("product","rearWheel","Wheel",1,1).

enumeration("Color").
option("Color", "Red").
option("Color", "Green").
option("Color", "Yellow").
option("Color", "Blue").

enumeration("Wheel").
attribute("Wheel","size","num").
option("Wheel", "W14").
attribute_value("Wheel","W14","size",14).
option("Wheel", "W16").
attribute_value("Wheel","W16","size",16).
option("Wheel", "W18").
attribute_value("Wheel","W18","size",18).
option("Wheel", "W20").
attribute_value("Wheel","W20","size",20).

% Complete generated instance tree
structure_type("root","product").

enumeration_type("root.color[0]","Color").
parent("root.color[0]", "root").
feature("root.color[0]","color").

enumeration_type("root.frontWheel[0]","Wheel").
parent("root.frontWheel[0]", "root").
feature("root.frontWheel[0]","frontWheel").
attribute_enumeration("root.frontWheel[0].size[0]","root.frontWheel[0]").
attribute_name("root.frontWheel[0].size[0]","size").
isnumeric("root.frontWheel[0].size[0]").

enumeration_type("root.rearWheel[0]","Wheel").
parent("root.rearWheel[0]", "root").
feature("root.rearWheel[0]","rearWheel").
attribute_enumeration("root.rearWheel[0].size[0]","root.rearWheel[0]").
attribute_name("root.rearWheel[0].size[0]","size").
isnumeric("root.rearWheel[0].size[0]").

enumeration_type("root.wheelSupport[0]","bool").
parent("root.wheelSupport[0]", "root").
feature("root.wheelSupport[0]","wheelSupport").

% Instantiated constraints on complete instance tree
constraint((0,"root")).
condition((0,"root"),"root.color[0]=Yellow").
binary("root.color[0]=Yellow","root.color[0]","=","Yellow").
constant("Yellow").
require((0,"root"),"root.frontWheel[0].size[0]>16").
binary("root.frontWheel[0].size[0]>16","root.frontWheel[0].size[0]",">","16").
number("16",16).

constraint((1,"root")).
combinations((1,"root"),0,0,"root.wheelSupport[0]").
combinations((1,"root"),0,1,"root.rearWheel[0]").
allow(1,(0,0),"True").
allow(1,(1,0),"W14").
allow(1,(1,0),"W16").
allow(1,(0,1),"False").
allow(1,(1,1),"W18").
allow(1,(1,1),"W20").

constraint((2,"root")).
require((2,"root"),"root.frontWheel[0].size[0]=root.rearWheel[0].size[0]").
binary("root.frontWheel[0].size[0]=root.rearWheel[0].size[0]","root.frontWheel[0].size[0]","=","root.rearWheel[0].size[0]").
