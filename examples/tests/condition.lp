structure(":root").
feature(":root",wheel,"Wheel",1,1).
feature(":root",wheelSupport,"bool",1,1).

enumeration("Wheel").
option("Wheel", "Small").
option("Wheel", "Large").

behavior(0).
context(0,":root").
condition(0,"wheelSupport=True").
binary(":root","wheelSupport=True","wheelSupport","=","True").
path("wheelSupport",0,wheelSupport).
constant("True").
require(0,"Wheel=Small").
binary(":root","Wheel=Small","Wheel","=","Small").
path("Wheel",0,wheel).
constant("Small").
