structure("product").
feature("product","bag","Bag",2,2).

structure("Bag").
feature("Bag","capacity","Capacity",1,1).

enumeration("Capacity").
attribute("Capacity","volume","num").
option("Capacity", "B50").
attribute_value("Capacity","B50","volume",50).
option("Capacity", "B100").
attribute_value("Capacity","B100","volume",100).

binary("product","bag.capacity.volume=100","bag.capacity.volume","=","100").
path("bag.capacity.volume",0,"bag").
path("bag.capacity.volume",1,"capacity").
path("bag.capacity.volume",2,"volume").
