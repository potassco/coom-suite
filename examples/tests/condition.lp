structure("").
feature("",wheel,"Wheel",1,1).
feature("",wheelSupport,"bool",1,1).

enumeration("Wheel").
option("Wheel", "Small").
option("Wheel", "Large").

behavior(0).
context(0,"").
condition(0,"wheelSupport=True").
binary("","wheelSupport=True","wheelSupport","=","True").
path("wheelSupport",0,wheelSupport).
constant("True").
require(0,"Wheel=Small").
binary("","Wheel=Small","Wheel","=","Small").
path("Wheel",0,wheel).
constant("Small").
