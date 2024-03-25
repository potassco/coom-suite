structure(":root").
feature(":root",wheel,"Wheel",1,1).

enumeration("Wheel").
attribute("Wheel",size,"num").
option("Wheel", "W27").
attr_value("Wheel","W27",size,27).
option("Wheel", "W28").
attr_value("Wheel","W28",size,28).

behavior((":root",0)).
require((":root",0),"wheel.size>=28").
binary(":root","wheel.size>=28","wheel.size",">=","28").
path("wheel.size",0,wheel).
path("wheel.size",1,size).
number("28",28).
