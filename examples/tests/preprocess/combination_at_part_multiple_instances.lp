coom_structure("product").
coom_feature("product","bike","Bike",2,2).

coom_structure("Bike").
coom_feature("Bike","wheel","Wheel",2,2).
coom_feature("Bike","material","Material",1,1).

coom_enumeration("Wheel").
coom_option("Wheel", "W28").
coom_option("Wheel", "W30").

coom_enumeration("Material").
coom_option("Material", "Carbon").
coom_option("Material", "Aluminum").

coom_behavior(0).
coom_context(0,"Bike").
coom_combinations(0,0,"wheel").
coom_combinations(0,1,"material").
coom_path("wheel",0,"wheel").
coom_path("material",0,"material").
coom_allow(0,(0,0),"W28").
coom_allow(0,(1,0),"Carbon").
coom_allow(0,(0,1),"W30").
coom_allow(0,(1,1),"Aluminum").

% coom_behavior(1).
% coom_context(1,"Bike").
% coom_require(1,"wheel=wheel").
% coom_binary("wheel=wheel","wheel","=","wheel").
% coom_path("wheel",0,"wheel").
% coom_path("wheel",0,"wheel").
