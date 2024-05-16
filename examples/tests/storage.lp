structure("product").
feature("product","storageNeeded","bool",1,1).
feature("product","bag","Bag",0,1).

structure("Bag").
feature("Bag","capacity","Capacity",1,1).

enumeration("Capacity").
attribute("Capacity","volume","num").
option("Capacity", "B10").
attribute_value("Capacity","B10","volume",10).
option("Capacity", "B20").
attribute_value("Capacity","B20","volume",20).
option("Capacity", "B50").
attribute_value("Capacity","B50","volume",50).
option("Capacity", "B100").
attribute_value("Capacity","B100","volume",100).

behavior(0).
context(0,"product").
condition(0,"storageNeeded=True").
binary("product","storageNeeded=True","storageNeeded","=","True").
path("storageNeeded",0,"storageNeeded").
constant("True").
require(0,"bag.capacity.volume>=50").
binary("product","bag.capacity.volume>=50","bag.capacity.volume",">=","50").
path("bag.capacity.volume",0,"bag").
path("bag.capacity.volume",1,"capacity").
path("bag.capacity.volume",2,"volume").
number("50",50).
