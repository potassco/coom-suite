coom_structure("product").
coom_feature("product","color","Color",1,1).
coom_feature("product","bag","Bag",1,1).

coom_structure("Bag").
coom_feature("Bag","color","Color",1,1).

coom_enumeration("Color").
coom_option("Color", "Red").
coom_option("Color", "White").
coom_option("Color", "Blue").

coom_behavior(0).
coom_context(0,"Bag").
coom_require(0,"color=_parent.color").
coom_binary("color=_parent.color","color","=","_parent.color").
coom_path("color",0,"color").
coom_path("_parent.color",0,"_parent").
coom_path("_parent.color",1,"color").
