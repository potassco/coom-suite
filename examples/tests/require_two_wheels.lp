structure("").
feature("",frontWheel,"Wheel",1,1).
feature("",rearWheel,"Wheel",1,1).

enumeration("Wheel").
attribute("Wheel",size,"num").
option("Wheel", "W27").
attr_value("Wheel","W27",size,27).
option("Wheel", "W28").
attr_value("Wheel","W28",size,28).

behavior(0).
context(0,"").
require(0,"frontWheel.size=rearWheel.size").
binary("","frontWheel.size=rearWheel.size","frontWheel.size","=","rearWheel.size").
path("frontWheel.size",0,frontWheel).
path("frontWheel.size",1,size).
path("rearWheel.size",0,rearWheel).
path("rearWheel.size",1,size).
