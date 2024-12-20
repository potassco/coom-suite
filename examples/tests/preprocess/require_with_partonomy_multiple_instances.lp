coom_structure("product").
coom_feature("product","compartment","Compartment",2,2).

coom_structure("Compartment").
coom_feature("Compartment","bag","Bag",2,2).

coom_structure("Bag").
coom_feature("Bag","color","Color",1,1).

coom_enumeration("Color").
coom_option("Color","Red").
coom_option("Color","Yellow").
coom_option("Color","Green").

coom_behavior(0).
coom_context(0,"Compartment").
coom_require(0,"bag.color=Red").
coom_binary("bag.color=Red","bag.color","=","Red").
coom_path("bag.color",0,"bag").
coom_path("bag.color",1,"color").
coom_constant("Red").
