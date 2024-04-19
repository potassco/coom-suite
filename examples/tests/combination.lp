structure(":root").
feature(":root",wheelSupport,"bool",1,1).
feature(":root",wheel,"Wheel",1,1).

enumeration("Wheel").
option("Wheel", "W14").
option("Wheel", "W16").
option("Wheel", "W18").
option("Wheel", "W20").

behavior(0).
context(0,":root").
combinations(0,0,"wheelSupport").
combinations(0,1,"Wheel").
path("wheelSupport",0,wheelSupport).
path("Wheel",0,wheel).
allow(0,(0,0),"True").
allow(0,(1,0),"W14").
allow(0,(1,0),"W16").
allow(0,(0,1),"False").
allow(0,(1,1),"W18").
allow(0,(1,1),"W20").
