coom_structure("product").
coom_feature("product","a","num",1,1).
coom_range("product","a",-5,5).
coom_feature("product","c","num",1,1).
coom_range("product","c",0,2).
coom_feature("product","d","num",1,1).
coom_range("product","d",0,9).
coom_feature("product","bike","Bike",1,1).

coom_structure("Bike").
coom_feature("Bike","w","num",1,1).
coom_range("Bike","w",0,9).

coom_behavior(0).
coom_context(0,"product").
coom_default(0,"a","-3").
coom_path("a",0,"a").
coom_unary("-3","-","3").
coom_number("3",3).

coom_behavior(1).
coom_context(1,"product").
coom_default(1,"d","c+1").
coom_path("d",0,"d").
coom_binary("c+1","c","+","1").
coom_path("c",0,"c").
coom_number("1",1).

coom_behavior(2).
coom_context(2,"product").
coom_default(2,"bike.w","4").
coom_path("bike.w",0,"bike").
coom_path("bike.w",1,"w").
coom_number("4",4).
