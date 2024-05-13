structure(":root").
feature(":root",wheel,"Wheel",1,1).

enumeration("Wheel").
option("Wheel", "W27").
option("Wheel", "W28").

behavior(0).
context(0,":root").
require(0,"wheel=W28").
binary(":root","wheel=W28","wheel","=","W28").
path("wheel",0,wheel).
constant("W28").
