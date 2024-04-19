% Original "COOM" fact format describing the structure of the model
structure(":root").
feature(":root",color,"Color",1,1).
feature(":root",wheelSupport,"bool",1,1).
feature(":root",frontWheel,"Wheel",1,1).
feature(":root",rearWheel,"Wheel",1,1).

enumeration("Color").
option("Color", "Red").
option("Color", "Green").
option("Color", "Yellow").
option("Color", "Blue").

enumeration("Wheel").
attribute("Wheel",size,"num").
option("Wheel", "W14").
attr_value("Wheel","W14",size,14).
option("Wheel", "W16").
attr_value("Wheel","W16",size,16).
option("Wheel", "W18").
attr_value("Wheel","W18",size,18).
option("Wheel", "W20").
attr_value("Wheel","W20",size,20).

% Complete generated instance tree
structure_instance(":root",":root",0).

enumeration_instance("color[0]","Color").
parent("color[0]", ":root").
feature("color[0]",color).

enumeration_instance("frontWheel[0]","Wheel").
parent("frontWheel[0]", ":root").
feature("frontWheel[0]",frontWheel).
attr_instance("frontWheel[0].size","frontWheel[0]").

enumeration_instance("rearWheel[0]","Wheel").
parent("rearWheel[0]", ":root").
feature("rearWheel[0]",rearWheel).
attr_instance("rearWheel[0].size","rearWheel[0]").

enumeration_instance("wheelSupport[0]","bool").
parent("wheelSupport[0]", ":root").
feature("wheelSupport[0]",wheelSupport).

% Instantiated constraints on complete instance tree
constraint((0,":root")).
condition_instance((0,":root"),"color[0]=Yellow").
binary("color[0]=Yellow","color[0]","=","Yellow").
constant("Yellow").
require_instance((0,":root"),"frontWheel[0].size>16").
binary("frontWheel[0].size>16","frontWheel[0].size",">","16").
number("16",16).

constraint((1,":root")).
combinations_instance((1,":root"),0,0,"wheelSupport[0]").
combinations_instance((1,":root"),0,1,"rearWheel[0]").
allow(1,(0,0),"True").
allow(1,(1,0),"W14").
allow(1,(1,0),"W16").
allow(1,(0,1),"False").
allow(1,(1,1),"W18").
allow(1,(1,1),"W20").

constraint((2,":root")).
require_instance((2,":root"),"frontWheel[0].size=rearWheel[0].size").
binary("frontWheel[0].size=rearWheel[0].size","frontWheel[0].size","=","rearWheel[0].size").
