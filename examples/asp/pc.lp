structure(":root").
feature(":root",usage,"Usage",1,1).
feature(":root",efficiency,"Efficiency",1,1).
feature(":root",maxPrice,"num",1,1).
range(":root",maxPrice,0,2500).
feature(":root",price,"num",1,1).
range(":root",price,0,2500).
feature(":root",internetConn,"bool",1,1).
feature(":root",hdunit,"HDUnit",1,2).
feature(":root",motherboard,"Motherboard",1,1).
feature(":root",screen,"Screen",1,2).
feature(":root",os,"OS",1,1).
feature(":root",applications,"Application",1,5).

enumeration("Usage").
option("Usage", "Internet").
option("Usage", "Scientific").
option("Usage", "Multimedia").

enumeration("Efficiency").
option("Efficiency", "A").
option("Efficiency", "B").
option("Efficiency", "C").

structure("HDUnit").
feature("HDUnit",price,"num",1,1).
range("HDUnit",price,0,1000).
feature("HDUnit",hdisk,"HDisk",1,4).
feature("HDUnit",hdcontroller,"HDController",1,2).

enumeration("HDisk").
attribute("HDisk",capacity,"num").
attribute("HDisk",price,"num").
option("HDisk", "MedStoreDisk").
attr_value("HDisk","MedStoreDisk",capacity,200).
attr_value("HDisk","MedStoreDisk",price,200).
option("HDisk", "MaxStoreDisk").
attr_value("HDisk","MaxStoreDisk",capacity,1000).
attr_value("HDisk","MaxStoreDisk",price,500).

enumeration("HDController").
attribute("HDController",price,"num").
option("HDController", "MedStoreC").
attr_value("HDController","MedStoreC",price,500).
option("HDController", "MaxStoreC").
attr_value("HDController","MaxStoreC",price,500).

structure("Motherboard").
feature("Motherboard",price,"num",1,1).
range("Motherboard",price,0,350).
feature("Motherboard",mbtype,"MBType",1,1).
feature("Motherboard",cpu,"CPU",1,1).

enumeration("MBType").
attribute("MBType",efficiency,"str").
attribute("MBType",price,"num").
option("MBType", "MBSilver").
attr_value("MBType","MBSilver",efficiency,"B").
attr_value("MBType","MBSilver",price,250).
option("MBType", "MBDiamond").
attr_value("MBType","MBDiamond",efficiency,"A").
attr_value("MBType","MBDiamond",price,350).

enumeration("CPU").
attribute("CPU",clockrate,"str").
attribute("CPU",price,"num").
option("CPU", "CPUD").
attr_value("CPU","CPUD",clockrate,"fast").
attr_value("CPU","CPUD",price,150).
option("CPU", "CPUS").
attr_value("CPU","CPUS",clockrate,"medium").
attr_value("CPU","CPUS",price,100).

enumeration("Screen").
attribute("Screen",efficiency,"str").
attribute("Screen",price,"num").
option("Screen", "ScreenA").
attr_value("Screen","ScreenA",efficiency,"A").
attr_value("Screen","ScreenA",price,200).
option("Screen", "ScreenB").
attr_value("Screen","ScreenB",efficiency,"B").
attr_value("Screen","ScreenB",price,150).
option("Screen", "ScreenC").
attr_value("Screen","ScreenC",efficiency,"C").
attr_value("Screen","ScreenC",price,100).

enumeration("OS").
attribute("OS",hdcapacity,"num").
attribute("OS",price,"num").
option("OS", "OSBeta").
attr_value("OS","OSBeta",hdcapacity,13).
attr_value("OS","OSBeta",price,500).
option("OS", "OSAlpha").
attr_value("OS","OSAlpha",hdcapacity,6).
attr_value("OS","OSAlpha",price,100).

structure("Application").
feature("Application",hdcapacity,"num",1,1).
range("Application",hdcapacity,200,200).
feature("Application",price,"num",1,1).
range("Application",price,50,50).

behavior(0).
context(0,":root").
imply(0,price,"sum(hdunit.price)+motherboard.price+sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)").
path("price",0,price).
binary(":root","sum(hdunit.price)+motherboard.price+sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)","sum(hdunit.price)","+","motherboard.price+sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)").
binary(":root","motherboard.price+sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)","motherboard.price","+","sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)").
binary(":root","sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)","sum(motherboard.cpu.price)","+","os.price+sum(screen.price)+sum(applications.price)").
binary(":root","os.price+sum(screen.price)+sum(applications.price)","os.price","+","sum(screen.price)+sum(applications.price)").
binary(":root","sum(screen.price)+sum(applications.price)","sum(screen.price)","+","sum(applications.price)").
function(":root","sum(hdunit.price)","sum","hdunit.price").
path("hdunit.price",0,hdunit).
path("hdunit.price",1,price).
path("motherboard.price",0,motherboard).
path("motherboard.price",1,price).
function(":root","sum(motherboard.cpu.price)","sum","motherboard.cpu.price").
path("motherboard.cpu.price",0,motherboard).
path("motherboard.cpu.price",1,cpu).
path("motherboard.cpu.price",2,price).
path("os.price",0,os).
path("os.price",1,price).
function(":root","sum(screen.price)","sum","screen.price").
path("screen.price",0,screen).
path("screen.price",1,price).
function(":root","sum(applications.price)","sum","applications.price").
path("applications.price",0,applications).
path("applications.price",1,price).

behavior(1).
context(1,":root").
require(1,"price<=maxPrice").
binary(":root","price<=maxPrice","price","<=","maxPrice").
path("price",0,price).
path("maxPrice",0,maxPrice).

behavior(2).
context(2,":root").
require(2,"os.hdcapacity+sum(applications.hdcapacity)<=sum(hdunit.hdisk.capacity)").
binary(":root","os.hdcapacity+sum(applications.hdcapacity)<=sum(hdunit.hdisk.capacity)","os.hdcapacity+sum(applications.hdcapacity)","<=","sum(hdunit.hdisk.capacity)").
binary(":root","os.hdcapacity+sum(applications.hdcapacity)","os.hdcapacity","+","sum(applications.hdcapacity)").
path("os.hdcapacity",0,os).
path("os.hdcapacity",1,hdcapacity).
function(":root","sum(applications.hdcapacity)","sum","applications.hdcapacity").
path("applications.hdcapacity",0,applications).
path("applications.hdcapacity",1,hdcapacity).
function(":root","sum(hdunit.hdisk.capacity)","sum","hdunit.hdisk.capacity").
path("hdunit.hdisk.capacity",0,hdunit).
path("hdunit.hdisk.capacity",1,hdisk).
path("hdunit.hdisk.capacity",2,capacity).

behavior(3).
context(3,":root").
condition(3,"usage=Internet").
binary(":root","usage=Internet","usage","=","Internet").
path("usage",0,usage).
constant("Internet").
require(3,"internetConn=True").
binary(":root","internetConn=True","internetConn","=","True").
path("internetConn",0,internetConn).
constant("True").

behavior(4).
context(4,":root").
condition(4,"usage=Multimedia").
binary(":root","usage=Multimedia","usage","=","Multimedia").
path("usage",0,usage).
constant("Multimedia").
require(4,"internetConn=True").
binary(":root","internetConn=True","internetConn","=","True").
path("internetConn",0,internetConn).
constant("True").

behavior(5).
context(5,":root").
combinations(5,0,"efficiency").
combinations(5,1,"motherboard.mbtype.efficiency").
combinations(5,2,"screen.efficiency").
path("efficiency",0,efficiency).
path("motherboard.mbtype.efficiency",0,motherboard).
path("motherboard.mbtype.efficiency",1,mbtype).
path("motherboard.mbtype.efficiency",2,efficiency).
path("screen.efficiency",0,screen).
path("screen.efficiency",1,efficiency).
allow(5,(0,0),"A").
allow(5,(1,0),"A").
allow(5,(2,0),"A").
allow(5,(0,1),"B").
allow(5,(1,1),"A").
allow(5,(1,1),"B").
allow(5,(2,1),"A").
allow(5,(2,1),"B").
allow(5,(0,2),"C").
allow(5,(1,2),"A").
allow(5,(1,2),"B").
allow(5,(1,2),"C").
allow(5,(2,2),"A").
allow(5,(2,2),"B").
allow(5,(2,2),"C").

behavior(6).
context(6,":root").
condition(6,"os=OSAlpha").
binary(":root","os=OSAlpha","os","=","OSAlpha").
path("os",0,os).
constant("OSAlpha").
require(6,"motherboard.cpu=CPUD").
binary(":root","motherboard.cpu=CPUD","motherboard.cpu","=","CPUD").
path("motherboard.cpu",0,motherboard).
path("motherboard.cpu",1,cpu).
constant("CPUD").

behavior(7).
context(7,"HDUnit").
imply(7,price,"sum(hdisk.price)+sum(hdcontroller.price)").
path("price",0,price).
binary("HDUnit","sum(hdisk.price)+sum(hdcontroller.price)","sum(hdisk.price)","+","sum(hdcontroller.price)").
function("HDUnit","sum(hdisk.price)","sum","hdisk.price").
path("hdisk.price",0,hdisk).
path("hdisk.price",1,price).
function("HDUnit","sum(hdcontroller.price)","sum","hdcontroller.price").
path("hdcontroller.price",0,hdcontroller).
path("hdcontroller.price",1,price).

behavior(8).
context(8,"Motherboard").
imply(8,price,"mbtype.price").
path("price",0,price).
path("mbtype.price",0,mbtype).
path("mbtype.price",1,price).

behavior(9).
context(9,"Motherboard").
condition(9,"mbtype=MBSilver").
binary("Motherboard","mbtype=MBSilver","mbtype","=","MBSilver").
path("mbtype",0,mbtype).
constant("MBSilver").
require(9,"cpu!=CPUD").
binary("Motherboard","cpu!=CPUD","cpu","!=","CPUD").
path("cpu",0,cpu).
constant("CPUD").

behavior(10).
context(10,"Motherboard").
condition(10,"mbtype=MBDiamond").
binary("Motherboard","mbtype=MBDiamond","mbtype","=","MBDiamond").
path("mbtype",0,mbtype).
constant("MBDiamond").
require(10,"cpu!=CPUS").
binary("Motherboard","cpu!=CPUS","cpu","!=","CPUS").
path("cpu",0,cpu).
constant("CPUS").
