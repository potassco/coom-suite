structure(":root").
feature(":root",wheelSupport,"bool",1,1).
feature(":root",wheel,"Wheel",1,1).

enumeration("Wheel").
option("Wheel", "W14").
option("Wheel", "W16").
option("Wheel", "W18").
option("Wheel", "W20").

behavior((":root",0)).
combinations((":root",0),0,"wheelSupport").
combinations((":root",0),1,"Wheel").
path("wheelSupport",0,wheelSupport).
path("Wheel",0,wheel).
allow((":root",0),(0,0),"True").
allow((":root",0),(1,0),"W14").
allow((":root",0),(1,0),"W16").
allow((":root",0),(0,1),"False").
allow((":root",0),(1,1),"W18").
allow((":root",0),(1,1),"W20").
