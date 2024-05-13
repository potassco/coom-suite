% Original "COOM" fact format describing the structure of the model
structure("").
feature("",totalWeight,"num",1,1).
range("",totalWeight,1,10000).
feature("",maxWeight,"num",1,1).
range("",maxWeight,10,10).
feature("",totalVolume,"num",1,1).
range("",totalVolume,0,200).
feature("",requestedVolume,"num",1,1).
range("",requestedVolume,100,100).
feature("",frontWheel,"Wheel",1,1).
feature("",rearWheel,"Wheel",1,1).
feature("",frame,"Frame",1,1).
feature("",carrier,"Carrier",1,1).
feature("",color,"Color",1,1).

structure("Carrier").
feature("Carrier",bag,"Bag",0,3).

structure("Frame").
feature("Frame",bag,"Bag",0,2).

structure("Bag").
feature("Bag",capacity,"Capacity",1,1).
feature("Bag",material,"Material",1,1).

enumeration("Capacity").
attribute("Capacity",volume,"num").
attribute("Capacity",weight,"num").
option("Capacity", "B10").
attr_value("Capacity","B10",volume,10).
attr_value("Capacity","B10",weight,100).
option("Capacity", "B20").
attr_value("Capacity","B20",volume,20).
attr_value("Capacity","B20",weight,250).
option("Capacity", "B50").
attr_value("Capacity","B50",volume,50).
attr_value("Capacity","B50",weight,600).
option("Capacity", "B100").
attr_value("Capacity","B100",volume,100).
attr_value("Capacity","B100",weight,1200).

enumeration("Material").
option("Material", "Cotton").
option("Material", "Leather").
option("Material", "Polyester").

enumeration("Wheel").
attribute("Wheel",size,"num").
attribute("Wheel",weight,"num").
option("Wheel", "W20").
attr_value("Wheel","W20",size,20).
attr_value("Wheel","W20",weight,650).
option("Wheel", "W22").
attr_value("Wheel","W22",size,22).
attr_value("Wheel","W22",weight,700).
option("Wheel", "W24").
attr_value("Wheel","W24",size,24).
attr_value("Wheel","W24",weight,800).
option("Wheel", "W26").
attr_value("Wheel","W26",size,26).
attr_value("Wheel","W26",weight,900).
option("Wheel", "W28").
attr_value("Wheel","W28",size,28).
attr_value("Wheel","W28",weight,1000).

enumeration("Color").
option("Color", "Red").
option("Color", "Green").
option("Color", "Yellow").
option("Color", "Blue").

% Complete generated instance tree
struct_type("","").

num("totalWeight[0]").
parent("totalWeight[0]","").
feature("totalWeight[0]",totalWeight).

num("maxWeight[0]").
parent("maxWeight[0]","").
feature("maxWeight[0]",maxWeight).

num("totalVolume[0]").
parent("totalVolume[0]","").
feature("totalVolume[0]",totalVolume).

num("requestedVolume[0]").
parent("requestedVolume[0]","").
feature("requestedVolume[0]",requestedVolume).

struct_type("carrier[0]","Carrier").
index("carrier[0]",0).
parent("carrier[0]", "").
feature("carrier[0]",carrier).

struct_type("frame[0]","Frame").
index("frame[0]",0).
parent("frame[0]", "").
feature("frame[0]",frame).

struct_type("carrier[0].bag[0]","Bag").
index("carrier[0].bag[0]",0).
parent("carrier[0].bag[0]", "carrier[0]").
feature("carrier[0].bag[0]",bag).

struct_type("carrier[0].bag[1]","Bag").
index("carrier[0].bag[1]",1).
parent("carrier[0].bag[1]", "carrier[0]").
feature("carrier[0].bag[1]",bag).

struct_type("carrier[0].bag[2]","Bag").
index("carrier[0].bag[2]",2).
parent("carrier[0].bag[2]", "carrier[0]").
feature("carrier[0].bag[2]",bag).

struct_type("frame[0].bag[0]","Bag").
index("frame[0].bag[0]",0).
parent("frame[0].bag[0]", "frame[0]").
feature("frame[0].bag[0]",bag).

struct_type("frame[0].bag[1]","Bag").
index("frame[0].bag[1]",1).
parent("frame[0].bag[1]", "frame[0]").
feature("frame[0].bag[1]",bag).

enum_type("frontWheel[0]","Wheel").
parent("frontWheel[0]", "").
feature("frontWheel[0]",frontWheel).
attr_enum("frontWheel[0].size[0]","frontWheel[0]").
attr_name("frontWheel[0].size[0]",size).
isnumeric("frontWheel[0].size[0]").
attr_enum("frontWheel[0].weight[0]","frontWheel[0]").
attr_name("frontWheel[0].weight[0]",weight).
isnumeric("frontWheel[0].weight[0]").

enum_type("rearWheel[0]","Wheel").
parent("rearWheel[0]", "").
feature("rearWheel[0]",rearWheel).
attr_enum("rearWheel[0].size[0]","rearWheel[0]").
attr_name("rearWheel[0].size[0]",size).
isnumeric("rearWheel[0].size[0]").
attr_enum("rearWheel[0].weight[0]","rearWheel[0]").
attr_name("rearWheel[0].weight[0]",weight).
isnumeric("rearWheel[0].weight[0]").

enum_type("color[0]","Color").
parent("color[0]", "").
feature("color[0]",color).

enum_type("carrier[0].bag[0].capacity[0]","Capacity").
parent("carrier[0].bag[0].capacity[0]", "carrier[0].bag[0]").
feature("carrier[0].bag[0].capacity[0]",capacity).
attr_enum("carrier[0].bag[0].capacity[0].volume[0]","carrier[0].bag[0].capacity[0]").
attr_name("carrier[0].bag[0].capacity[0].volume[0]",volume).
isnumeric("carrier[0].bag[0].capacity[0].volume[0]").
attr_enum("carrier[0].bag[0].capacity[0].weight[0]","carrier[0].bag[0].capacity[0]").
attr_name("carrier[0].bag[0].capacity[0].weight[0]",weight).
isnumeric("carrier[0].bag[0].capacity[0].weight[0]").

enum_type("carrier[0].bag[1].capacity[0]","Capacity").
parent("carrier[0].bag[1].capacity[0]", "carrier[0].bag[1]").
feature("carrier[0].bag[1].capacity[0]",capacity).
attr_enum("carrier[0].bag[1].capacity[0].volume[0]","carrier[0].bag[1].capacity[0]").
attr_name("carrier[0].bag[1].capacity[0].volume[0]",volume).
isnumeric("carrier[0].bag[1].capacity[0].volume[0]").
attr_enum("carrier[0].bag[1].capacity[0].weight[0]","carrier[0].bag[1].capacity[0]").
attr_name("carrier[0].bag[1].capacity[0].weight[0]",weight).
isnumeric("carrier[0].bag[1].capacity[0].weight[0]").

enum_type("carrier[0].bag[2].capacity[0]","Capacity").
parent("carrier[0].bag[2].capacity[0]", "carrier[0].bag[2]").
feature("carrier[0].bag[2].capacity[0]",capacity).
attr_enum("carrier[0].bag[2].capacity[0].volume[0]","carrier[0].bag[2].capacity[0]").
attr_name("carrier[0].bag[2].capacity[0].volume[0]",volume).
isnumeric("carrier[0].bag[2].capacity[0].volume[0]").
attr_enum("carrier[0].bag[2].capacity[0].weight[0]","carrier[0].bag[2].capacity[0]").
attr_name("carrier[0].bag[2].capacity[0].weight[0]",weight).
isnumeric("carrier[0].bag[2].capacity[0].weight[0]").

enum_type("carrier[0].bag[0].material[0]","Material").
parent("carrier[0].bag[0].material[0]", "carrier[0].bag[0]").
feature("carrier[0].bag[0].material[0]",material).

enum_type("carrier[0].bag[1].material[0]","Material").
parent("carrier[0].bag[1].material[0]", "carrier[0].bag[1]").
feature("carrier[0].bag[1].material[0]",material).

enum_type("carrier[0].bag[2].material[0]","Material").
parent("carrier[0].bag[2].material[0]", "carrier[0].bag[2]").
feature("carrier[0].bag[2].material[0]",material).

enum_type("frame[0].bag[0].capacity[0]","Capacity").
parent("frame[0].bag[0].capacity[0]", "frame[0].bag[0]").
feature("frame[0].bag[0].capacity[0]",capacity).
attr_enum("frame[0].bag[0].capacity[0].volume[0]","frame[0].bag[0].capacity[0]").
attr_name("frame[0].bag[0].capacity[0].volume[0]",volume).
isnumeric("frame[0].bag[0].capacity[0].volume[0]").
attr_enum("frame[0].bag[0].capacity[0].weight[0]","frame[0].bag[0].capacity[0]").
attr_name("frame[0].bag[0].capacity[0].weight[0]",weight).
isnumeric("frame[0].bag[0].capacity[0].weight[0]").

enum_type("frame[0].bag[1].capacity[0]","Capacity").
parent("frame[0].bag[1].capacity[0]", "frame[0].bag[1]").
feature("frame[0].bag[1].capacity[0]",capacity).
attr_enum("frame[0].bag[1].capacity[0].volume[0]","frame[0].bag[1].capacity[0]").
attr_name("frame[0].bag[1].capacity[0].volume[0]",volume).
isnumeric("frame[0].bag[1].capacity[0].volume[0]").
attr_enum("frame[0].bag[1].capacity[0].weight[0]","frame[0].bag[1].capacity[0]").
attr_name("frame[0].bag[1].capacity[0].weight[0]",weight).
isnumeric("frame[0].bag[1].capacity[0].weight[0]").

enum_type("frame[0].bag[0].material[0]","Material").
parent("frame[0].bag[0].material[0]", "frame[0].bag[0]").
feature("frame[0].bag[0].material[0]",material).

enum_type("frame[0].bag[1].material[0]","Material").
parent("frame[0].bag[1].material[0]", "frame[0].bag[1]").
feature("frame[0].bag[1].material[0]",material).

% Instantiated constraints on complete instance tree
constraint((0,"")).
require_instance((0,""),"count(carrier.bag)+count(frame.bag)<=4").
binary("count(carrier.bag)+count(frame.bag)<=4","count(carrier.bag)+count(frame.bag)","<=","4").
binary("count(carrier.bag)+count(frame.bag)","count(carrier.bag)","+","count(frame.bag)").
function_instance("count(carrier.bag)","count","carrier.bag").
function_path("carrier.bag","carrier[0].bag[0]").
function_path("carrier.bag","carrier[0].bag[1]").
function_path("carrier.bag","carrier[0].bag[2]").
function_instance("count(frame.bag)","count","frame.bag").
function_path("frame.bag","frame[0].bag[0]").
function_path("frame.bag","frame[0].bag[1]").
number("4",4).

constraint((1,"")).
imply_instance((1,""),"totalWeight[0]","frontWheel[0].weight[0]+rearWheel[0].weight[0]+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
binary("frontWheel[0].weight[0]+rearWheel[0].weight[0]+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","frontWheel[0].weight[0]","+","rearWheel[0].weight[0]+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
binary("rearWheel[0].weight[0]+sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","rearWheel[0].weight[0]","+","sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)").
binary("sum(carrier.bag.capacity.weight)+sum(frame.bag.capacity.weight)","sum(carrier.bag.capacity.weight)","+","sum(frame.bag.capacity.weight)").
function_instance("sum(carrier.bag.capacity.weight)","sum","carrier.bag.capacity.weight").
function_path("carrier.bag.capacity.weight","carrier[0].bag[0].capacity[0].weight[0]").
function_path("carrier.bag.capacity.weight","carrier[0].bag[1].capacity[0].weight[0]").
function_path("carrier.bag.capacity.weight","carrier[0].bag[2].capacity[0].weight[0]").
function_instance("sum(frame.bag.capacity.weight)","sum","frame.bag.capacity.weight").
function_path("frame.bag.capacity.weight","frame[0].bag[0].capacity[0].weight[0]").
function_path("frame.bag.capacity.weight","frame[0].bag[1].capacity[0].weight[0]").

constraint((2,"")).
require_instance((2,""),"totalWeight[0]<=maxWeight[0]*1000").
binary("totalWeight[0]<=maxWeight[0]*1000","totalWeight[0]","<=","maxWeight[0]*1000").
binary("maxWeight[0]*1000","maxWeight[0]","*","1000").
number("1000",1000).

constraint((3,"")).
imply_instance((3,""),"totalVolume[0]","sum(carrier.bag.capacity.volume)+sum(frame.bag.capacity.volume)").
binary("sum(carrier.bag.capacity.volume)+sum(frame.bag.capacity.volume)","sum(carrier.bag.capacity.volume)","+","sum(frame.bag.capacity.volume)").
function_instance("sum(carrier.bag.capacity.volume)","sum","carrier.bag.capacity.volume").
function_path("carrier.bag.capacity.volume","carrier[0].bag[0].capacity[0].volume[0]").
function_path("carrier.bag.capacity.volume","carrier[0].bag[1].capacity[0].volume[0]").
function_path("carrier.bag.capacity.volume","carrier[0].bag[2].capacity[0].volume[0]").
function_instance("sum(frame.bag.capacity.volume)","sum","frame.bag.capacity.volume").
function_path("frame.bag.capacity.volume","frame[0].bag[0].capacity[0].volume[0]").
function_path("frame.bag.capacity.volume","frame[0].bag[1].capacity[0].volume[0]").

constraint((4,"")).
require_instance((4,""),"totalVolume[0]>=requestedVolume[0]").
binary("totalVolume[0]>=requestedVolume[0]","totalVolume[0]",">=","requestedVolume[0]").

constraint((5,"")).
condition_instance((5,""),"color[0]=Red").
binary("color[0]=Red","color[0]","=","Red").
constant("Red").
require_instance((5,""),"frontWheel[0].size[0]=20").
binary("frontWheel[0].size[0]=20","frontWheel[0].size[0]","=","20").
number("20",20).

constraint((6,"carrier[0].bag[0]")).
condition_instance((6,"carrier[0].bag[0]"),"carrier[0].bag[0].material[0]=Leather").
binary("carrier[0].bag[0].material[0]=Leather","carrier[0].bag[0].material[0]","=","Leather").
require_instance((6,"carrier[0].bag[0]"),"carrier[0].bag[0].capacity[0]=B10").
binary("carrier[0].bag[0].capacity[0]=B10","carrier[0].bag[0].capacity[0]","=","B10").
constant("Leather").
constant("B10").

constraint((6,"carrier[0].bag[1]")).
condition_instance((6,"carrier[0].bag[1]"),"carrier[0].bag[1].material[0]=Leather").
binary("carrier[0].bag[1].material[0]=Leather","carrier[0].bag[1].material[0]","=","Leather").
require_instance((6,"carrier[0].bag[1]"),"carrier[0].bag[1].capacity[0]=B10").
binary("carrier[0].bag[1].capacity[0]=B10","carrier[0].bag[1].capacity[0]","=","B10").

constraint((6,"carrier[0].bag[2]")).
condition_instance((6,"carrier[0].bag[2]"),"carrier[0].bag[2].material[0]=Leather").
binary("carrier[0].bag[2].material[0]=Leather","carrier[0].bag[2].material[0]","=","Leather").
require_instance((6,"carrier[0].bag[2]"),"carrier[0].bag[2].capacity[0]=B10").
binary("carrier[0].bag[2].capacity[0]=B10","carrier[0].bag[2].capacity[0]","=","B10").

constraint((6,"frame[0].bag[0]")).
condition_instance((6,"frame[0].bag[0]"),"frame[0].bag[0].material[0]=Leather").
binary("frame[0].bag[0].material[0]=Leather","frame[0].bag[0].material[0]","=","Leather").
require_instance((6,"frame[0].bag[0]"),"frame[0].bag[0].capacity[0]=B10").
binary("frame[0].bag[0].capacity[0]=B10","frame[0].bag[0].capacity[0]","=","B10").

constraint((6,"frame[0].bag[1]")).
condition_instance((6,"frame[0].bag[1]"),"frame[0].bag[1].material[0]=Leather").
binary("frame[0].bag[1].material[0]=Leather","frame[0].bag[1].material[0]","=","Leather").
require_instance((6,"frame[0].bag[1]"),"frame[0].bag[1].capacity[0]=B10").
binary("frame[0].bag[1].capacity[0]=B10","frame[0].bag[1].capacity[0]","=","B10").
