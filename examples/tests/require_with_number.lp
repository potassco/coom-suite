structure(":root").
feature(":root",wheel,"Wheel",1,1).

enumeration("Wheel").
attribute("Wheel",size,"num").
option("Wheel", "W27").
attr_value("Wheel","W27",size,27).
option("Wheel", "W28").
attr_value("Wheel","W28",size,28).

behavior(0).
context(0,":root").
require(0,"wheel.size=27").
binary(":root","wheel.size=27","wheel.size","=","27").
path("wheel.size",0,wheel).
path("wheel.size",1,size).
number("27",27).
