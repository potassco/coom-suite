% Original "COOM" fact format describing the structure of the model
structure("").
feature("",color,"Color",1,1).
feature("",basket,"Basket",0,1).
feature("",saddle,"Saddle",1,1).
feature("",frontWheel,"Wheel",1,1).
feature("",rearWheel,"Wheel",1,1).
feature("",carrier,"Carrier",1,1).

structure("Basket").
feature("Basket",position,"Position",1,1).
feature("Basket",color,"Color",1,1).

structure("Carrier").
feature("Carrier",bag,"Bag",0,2).

structure("Bag").
feature("Bag",capacity,"Capacity",1,1).
feature("Bag",material,"Material",1,1).

enumeration("Color").
option("Color", "Silver").
option("Color", "White").
option("Color", "Black").
option("Color", "Blue").

enumeration("Position").
option("Position", "Front").
option("Position", "Back").

enumeration("Saddle").
option("Saddle", "Standard").
option("Saddle", "Comfort").
option("Saddle", "Vintage").

enumeration("Wheel").
attribute("Wheel",size,"num").
option("Wheel", "W26").
attr_value("Wheel","W26",size,26).
option("Wheel", "W27").
attr_value("Wheel","W27",size,27).
option("Wheel", "W28").
attr_value("Wheel","W28",size,28).
option("Wheel", "W29").
attr_value("Wheel","W29",size,29).

enumeration("Capacity").
attribute("Capacity",volume,"num").
option("Capacity", "B10").
attr_value("Capacity","B10",volume,10).
option("Capacity", "B20").
attr_value("Capacity","B20",volume,20).
option("Capacity", "B50").
attr_value("Capacity","B50",volume,50).
option("Capacity", "B100").
attr_value("Capacity","B100",volume,100).

enumeration("Material").
option("Material", "Cotton").
option("Material", "Leather").
option("Material", "Polyester").

% Complete generated instance tree
struct_type("","").

struct_type("carrier[0]","Carrier").
index("carrier[0]",0).
parent("carrier[0]", "").
feature("carrier[0]",carrier).

struct_type("basket[0]","Basket").
index("basket[0]",0).
parent("basket[0]", "").
feature("basket[0]",basket).

struct_type("carrier[0].bag[0]","Bag").
index("carrier[0].bag[0]",0).
parent("carrier[0].bag[0]", "carrier[0]").
feature("carrier[0].bag[0]",bag).

struct_type("carrier[0].bag[1]","Bag").
index("carrier[0].bag[1]",1).
parent("carrier[0].bag[1]", "carrier[0]").
feature("carrier[0].bag[1]",bag).

enum_type("color[0]","Color").
parent("color[0]", "").
feature("color[0]",color).

enum_type("saddle[0]","Saddle").
parent("saddle[0]", "").
feature("saddle[0]",saddle).

enum_type("frontWheel[0]","Wheel").
parent("frontWheel[0]", "").
feature("frontWheel[0]",frontWheel).
attr_enum("frontWheel[0].size[0]","frontWheel[0]").
attr_name("frontWheel[0].size[0]",size).
isnumeric("frontWheel[0].size[0]").

enum_type("rearWheel[0]","Wheel").
parent("rearWheel[0]", "").
feature("rearWheel[0]",rearWheel).
attr_enum("rearWheel[0].size[0]","rearWheel[0]").
attr_name("rearWheel[0].size[0]",size).
isnumeric("rearWheel[0].size[0]").

enum_type("basket[0].color[0]","Color").
parent("basket[0].color[0]","basket[0]").
feature("basket[0].color[0]",color).

enum_type("basket[0].position[0]","Position").
parent("basket[0].position[0]","basket[0]").
feature("basket[0].position[0]",position).

enum_type("carrier[0].bag[0].capacity[0]","Capacity").
parent("carrier[0].bag[0].capacity[0]", "carrier[0].bag[0]").
feature("carrier[0].bag[0].capacity[0]",capacity).
attr_enum("carrier[0].bag[0].capacity[0].volume[0]","carrier[0].bag[0].capacity[0]").
attr_name("carrier[0].bag[0].capacity[0].volume[0]",volume).
isnumeric("carrier[0].bag[0].capacity[0].volume[0]").

enum_type("carrier[0].bag[1].capacity[0]","Capacity").
parent("carrier[0].bag[1].capacity[0]", "carrier[0].bag[1]").
feature("carrier[0].bag[1].capacity[0]",capacity).
attr_enum("carrier[0].bag[1].capacity[0].volume[0]","carrier[0].bag[1].capacity[0]").
attr_name("carrier[0].bag[1].capacity[0].volume[0]",volume).
isnumeric("carrier[0].bag[1].capacity[0].volume[0]").

enum_type("carrier[0].bag[0].material[0]","Material").
parent("carrier[0].bag[0].material[0]", "carrier[0].bag[0]").
feature("carrier[0].bag[0].material[0]",material).

enum_type("carrier[0].bag[1].material[0]","Material").
parent("carrier[0].bag[1].material[0]", "carrier[0].bag[1]").
feature("carrier[0].bag[1].material[0]",material).


% Instantiated constraints on complete instance tree
constraint((0,"")).
require_instance((0,""),"color[0]=basket[0].color[0]").
binary("color[0]=basket[0].color[0]","color[0]","=","basket[0].color[0]").

constraint((1,"")).
condition_instance((1,""),"basket[0].position[0]=Front").
binary("basket[0].position[0]=Front","basket[0].position[0]","=","Front").
constant("Front").
require_instance((1,""),"frontWheel[0].size[0]<29").
binary("frontWheel[0].size[0]<29","frontWheel[0].size[0]","<","29").
number("29",29).

constraint((2,"")).
condition_instance((2,""),"carrier[0].bag[0].capacity[0].volume[0]=100").
binary("carrier[0].bag[0].capacity[0].volume[0]=100","carrier[0].bag[0].capacity[0].volume[0]","=","100").
require_instance((2,""),"rearWheel[0].size[0]>=28").
binary("rearWheel[0].size[0]>=28","rearWheel[0].size[0]",">=","28").


condition_instance((2,""),"carrier[0].bag[1].capacity[0].volume[0]=100").
binary("carrier[0].bag[1].capacity[0].volume[0]=100","carrier[0].bag[1].capacity[0].volume[0]","=","100").
require_instance((2,""),"rearWheel[0].size[0]>=28").
binary("rearWheel[0].size[0]>=28","rearWheel[0].size[0]",">=","28").

number("100",100).
number("28",28).


constraint((3,"")).
condition_instance((3,""),"saddle[0]=Vintage").
binary("saddle[0]=Vintage","saddle[0]","=","Vintage").
require_instance((3,""),"carrier[0].bag[0].material[0]=Leather").
binary("carrier[0].bag[0].material[0]=Leather","carrier[0].bag[0].material[0]","=","Leather").

condition_instance((3,""),"saddle[0]=Vintage").
binary("saddle[0]=Vintage","saddle[0]","=","Vintage").
require_instance((3,""),"carrier[0].bag[1].material[0]=Leather").
binary("carrier[0].bag[1].material[0]=Leather","carrier[0].bag[1].material[0]","=","Leather").

constant("Vintage").
constant("Leather").

constraint((4,"")).
require_instance((4,""),"frontWheel[0].size[0]=rearWheel[0].size[0]").
binary("frontWheel[0].size[0]=rearWheel[0].size[0]","frontWheel[0].size[0]","=","rearWheel[0].size[0]").

constraint((5,"carrier[0].bag[0]")).
combinations_instance((5,"carrier[0].bag[0]"),0,0,"carrier[0].bag[0].material[0]").
combinations_instance((5,"carrier[0].bag[0]"),0,1,"carrier[0].bag[0].capacity[0]").

constraint((5,"carrier[0].bag[1]")).
combinations_instance((5,"carrier[0].bag[1]"),0,0,"carrier[0].bag[1].material[0]").
combinations_instance((5,"carrier[0].bag[1]"),0,1,"carrier[0].bag[1].capacity[0]").
allow(5,(0,0),"Leather").
allow(5,(1,0),"B10").
allow(5,(0,1),"Cotton").
allow(5,(1,1),"B20").
allow(5,(1,1),"B50").
allow(5,(0,2),"Polyester").
allow(5,(1,2),"B20").
allow(5,(1,2),"B50").
allow(5,(1,2),"B100").
