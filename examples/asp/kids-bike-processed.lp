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

instance("Kids Bike",":root").
instance("color[0]","Color").
instance("frontWheel[0]","Wheel").
instance("rearWheel[0]","Wheel").
attr_instance("frontWheel[0].size","frontWheel[0]").
attr_instance("rearWheel[0].size","rearWheel[0]").
instance("wheelSupport[0]","bool").

constraint(0).
condition(0,"color[0]=Yellow").
binary("color[0]=Yellow","color[0]","=","Yellow").
constant("Yellow").
require(0,"frontWheel[0].size>16").
binary("frontWheel[0].size>16","frontWheel[0].size",">","16").
number("16",16).

constraint(1).
combinations(1,0,"wheelSupport[0]").
combinations(1,1,"rearWheel[0]").
allow(1,(0,0),"True").
allow(1,(1,0),"W14").
allow(1,(1,0),"W16").
allow(1,(0,1),"False").
allow(1,(1,1),"W18").
allow(1,(1,1),"W20").

constraint(2).
require(2,"frontWheel[0].size=rearWheel[0].size").
binary("frontWheel[0].size=rearWheel[0].size","frontWheel[0].size","=","rearWheel[0].size").
