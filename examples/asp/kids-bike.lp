% Parts of the model
part("root").

% Attributes of the model
discrete("Color").
domain("Color","Red").
domain("Color","Green").
domain("Color","Yellow").
domain("Color","Blue").

discrete("Wheel").
domain("Wheel","W14").
domain("Wheel","W16").
domain("Wheel","W18").
domain("Wheel","W20").

integer("Wheel.size").
range("Wheel.size",14,20).
% domain("Wheel.size",14).
% domain("Wheel.size",16).
% domain("Wheel.size",18).
% domain("Wheel.size",20).

% Complete instance tree
type("root","product").

type("root.color[0]","Color").
parent("root.color[0]","root").
index("root.color[0]",0).

type("root.frontWheel[0]","Wheel").
parent("root.frontWheel[0]","root").
index("root.frontWheel[0]",0).

type("root.frontWheel[0].size[0]","Wheel.size").
parent("root.frontWheel[0].size[0]","root.frontWheel[0]").
index("root.frontWheel[0].size[0]",0).

type("root.rearWheel[0]","Wheel").
parent("root.rearWheel[0]","root").
index("root.rearWheel[0]",0).

type("root.rearWheel[0].size[0]","Wheel.size").
parent("root.rearWheel[0].size[0]","root.rearWheel[0]").
index("root.rearWheel[0].size[0]",0).

type("root.wheelSupport[0]","bool").
parent("root.wheelSupport[0]", "root").
index("root.wheelSupport[0]",0).

% Instantiated constraints
constraint(0,"!root.color[0]=Yellow||root.frontWheel[0].size[0]>16").
binary("!root.color[0]=Yellow||root.frontWheel[0].size[0]>16","!root.color[0]=Yellow","||","root.frontWheel[0].size[0]>16").
unary("!root.color[0]=Yellow","!","root.color[0]=Yellow").
binary("root.color[0]=Yellow","root.color[0]","=","Yellow").
constant("Yellow").
binary("root.frontWheel[0].size[0]>16","root.frontWheel[0].size[0]",">","16").
number("16",16).

table((1,"root")).
column((1,"root"),0,0,"root.wheelSupport[0]").
column((1,"root"),0,1,"root.rearWheel[0]").
allow(1,(0,0),"True").
allow(1,(1,0),"W14").
allow(1,(1,0),"W16").
allow(1,(0,1),"False").
allow(1,(1,1),"W18").
allow(1,(1,1),"W20").

% binary("(root.wheelSupport[0]=True&&(root.rearWheel[0]=W14||root.rearWheel[0]=W16))||(root.wheelSupport[0]=False&&(root.rearWheel[0]=W18||root.rearWheel[0]=W20))","(root.wheelSupport[0]=True&&(root.rearWheel[0]=W14||root.rearWheel[0]=W16))","||","(root.wheelSupport[0]=False&&(root.rearWheel[0]=W18||root.rearWheel[0]=W20))").
% unary("(root.wheelSupport[0]=True&&(root.rearWheel[0]=W14||root.rearWheel[0]=W16))","()","root.wheelSupport[0]=True&&(root.rearWheel[0]=W14||root.rearWheel[0]=W16)").
% binary("root.wheelSupport[0]=True&&(root.rearWheel[0]=W14||root.rearWheel[0]=W16)","root.wheelSupport[0]=True","&&","(root.rearWheel[0]=W14||root.rearWheel[0]=W16)").
% unary("(root.rearWheel[0]=W14||root.rearWheel[0]=W16)","()","root.rearWheel[0]=W14||root.rearWheel[0]=W16").
% binary("root.rearWheel[0]=W14||root.rearWheel[0]=W16","root.rearWheel[0]=W14","||","root.rearWheel[0]=W16").
% binary("root.rearWheel[0]=W14","root.rearWheel[0]","=","W14")

% unary("(root.wheelSupport[0]=False&&(root.rearWheel[0]=W18||root.rearWheel[0]=W20))","()","root.wheelSupport[0]=False&&(root.rearWheel[0]=W18||root.rearWheel[0]=W20)")

constraint(2,"root.frontWheel[0].size[0]=root.rearWheel[0].size[0]").
binary("root.frontWheel[0].size[0]=root.rearWheel[0].size[0]","root.frontWheel[0].size[0]","=","root.rearWheel[0].size[0]").

% Attribute constraints
table(("Wheel","root.frontWheel[0]")).
column(("Wheel","root.frontWheel[0]"),0,0,"root.frontWheel[0]").
column(("Wheel","root.frontWheel[0]"),0,1,"root.frontWheel[0].size[0]").

table(("Wheel","root.rearWheel[0]")).
column(("Wheel","root.rearWheel[0]"),0,0,"root.rearWheel[0]").
column(("Wheel","root.rearWheel[0]"),0,1,"root.rearWheel[0].size[0]").

allow("Wheel",(0,0),"W14").
allow("Wheel",(1,0),14).
allow("Wheel",(0,1),"W16").
allow("Wheel",(1,1),16).
allow("Wheel",(0,2),"W18").
allow("Wheel",(1,2),18).
allow("Wheel",(0,3),"W20").
allow("Wheel",(1,3),20).

% Cardinality constraints
% only need to check for min, not possible to exceed max as all possible objects are instantiated before
cardinality("root","root.color",1).
path("root.color","root.color[0]").

cardinality("root","root.wheelSupport",1).
path("root.wheelSupport","root.wheelSupport[0]").

cardinality("root","root.frontWheel",1).
path("root.frontWheel","root.frontWheel[0]").

cardinality("root.frontWheel[0]","root.frontWheel[0].size",1).
path("root.frontWheel[0].size","root.frontWheel[0].size[0]").

cardinality("root","root.rearWheel",1).
path("root.rearWheel","root.rearWheel[0]").

cardinality("root.rearWheel[0]","root.rearWheel[0].size",1).
path("root.rearWheel[0].size","root.rearWheel[0].size[0]").


% constraint("Cardinality","count(root.color)>=1").
% binary("count(root.color)>=1","count(root.color)",">=","1").
% function("count(root.color)","count","root.color").
% path("root.color","root.color[0]").
% number("1",1).

% constraint("Cardinality","count(root.wheelSupport)>=1").
% binary("count(root.wheelSupport)>=1","count(root.wheelSupport)",">=","1").
% function("count(root.wheelSupport)","count","root.wheelSupport").
% path("root.wheelSupport","root.wheelSupport[0]").

% constraint("Cardinality","count(root.frontWheel)>=1").
% binary("count(root.frontWheel)>=1","count(root.frontWheel)",">=","1").
% function("count(root.frontWheel)","count","root.frontWheel").
% path("root.frontWheel","root.frontWheel[0]").

% constraint("Cardinality","count(root.rearWheel)>=1").
% binary("count(root.rearWheel)>=1","count(root.rearWheel)",">=","1").
% function("count(root.rearWheel)","count","root.rearWheel").
% path("root.rearWheel","root.rearWheel[0]").

% constraint("Cardinality","count(root.frontWheel[0].size)>=1").
% binary("count(root.frontWheel[0].size)>=1","count(root.frontWheel[0].size)",">=","1").
% function("count(root.frontWheel[0].size)","count","root.frontWheel[0].size").
% path("root.frontWheel[0].size","root.frontWheel[0].size[0]").

% constraint("Cardinality","count(root.rearWheel[0].size)>=1").
% binary("count(root.rearWheel[0].size)>=1","count(root.rearWheel[0].size)",">=","1").
% function("count(root.rearWheel[0].size)","count","root.rearWheel[0].size").
% path("root.rearWheel[0].size","root.rearWheel[0].size[0]").
