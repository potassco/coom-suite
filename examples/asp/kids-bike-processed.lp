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

behavior(0).
context(0,":root").
condition(0,"color[0]=Yellow").
binary("color[0]=Yellow","color[0]","=","Yellow").
path("color[0]",0,color,0).
constant("Yellow").
require(0,"frontWheel[0].size[0]>16").
binary("frontWheel[0].size[0]>16","frontWheel[0].size[0]",">","16").
path("frontWheel[0].size[0]",0,frontWheel,0).
path("frontWheel[0].size[0]",1,size,0).
number("16",16).

behavior(1).
context(1,":root").
combinations(1,0,"wheelSupport").
combinations(1,1,"rearWheel").
path("wheelSupport",0,wheelSupport).
path("rearWheel",0,rearWheel).
allow(1,(0,0),"True").
allow(1,(1,0),"W14").
allow(1,(1,0),"W16").
allow(1,(0,1),"False").
allow(1,(1,1),"W18").
allow(1,(1,1),"W20").

behavior(2).
context(2,":root")
require(2,"frontWheel.size=rearWheel.size").
binary("frontWheel.size=rearWheel.size","frontWheel.size","=","rearWheel.size").
path("frontWheel.size",0,frontWheel).
path("frontWheel.size",1,size).
path("rearWheel.size",0,rearWheel).
path("rearWheel.size",1,size).
