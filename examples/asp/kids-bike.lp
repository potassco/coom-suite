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

behavior((":root",0)).
condition((":root",0),"color=Yellow").
binary(":root","color=Yellow","color","=","Yellow").
path("color",0,color).
constant("Yellow").
require((":root",0),"frontWheel.size>16").
binary(":root","frontWheel.size>16","frontWheel.size",">","16").
path("frontWheel.size",0,frontWheel).
path("frontWheel.size",1,size).
number("16",16).

behavior((":root",1)).
combinations((":root",1),0,"wheelSupport").
combinations((":root",1),1,"rearWheel").
path("wheelSupport",0,wheelSupport).
path("rearWheel",0,rearWheel).
allow((":root",1),(0,0),"True").
allow((":root",1),(1,0),"W14").
allow((":root",1),(1,0),"W16").
allow((":root",1),(0,1),"False").
allow((":root",1),(1,1),"W18").
allow((":root",1),(1,1),"W20").

behavior((":root",2)).
require((":root",2),"frontWheel.size=rearWheel.size").
binary(":root","frontWheel.size=rearWheel.size","frontWheel.size","=","rearWheel.size").
path("frontWheel.size",0,frontWheel).
path("frontWheel.size",1,size).
path("rearWheel.size",0,rearWheel).
path("rearWheel.size",1,size).
