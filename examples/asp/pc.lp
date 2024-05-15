coom_structure("product").
coom_feature("product","usage","Usage",1,1).
coom_feature("product","efficiency","Efficiency",1,1).
coom_feature("product","maxPrice","num",1,1).
coom_range("product","maxPrice",0,2500).
coom_feature("product","price","num",1,1).
coom_range("product","price",0,2500).
coom_feature("product","internetConn","bool",1,1).
coom_feature("product","hdunit","HDUnit",1,2).
coom_feature("product","motherboard","Motherboard",1,1).
coom_feature("product","screen","Screen",1,2).
coom_feature("product","os","OS",1,1).
coom_feature("product","applications","Application",1,5).

coom_enumeration("Usage").
coom_option("Usage", "Internet").
coom_option("Usage", "Scientific").
coom_option("Usage", "Multimedia").

coom_enumeration("Efficiency").
coom_option("Efficiency", "A").
coom_option("Efficiency", "B").
coom_option("Efficiency", "C").

coom_structure("HDUnit").
coom_feature("HDUnit","price","num",1,1).
coom_range("HDUnit","price",0,1000).
coom_feature("HDUnit","hdisk","HDisk",1,4).
coom_feature("HDUnit","hdcontroller","HDController",1,2).

coom_enumeration("HDisk").
coom_attribute("HDisk","capacity","num").
coom_attribute("HDisk","price","num").
coom_option("HDisk", "MedStoreDisk").
coom_attribute_value("HDisk","MedStoreDisk","capacity",200).
coom_attribute_value("HDisk","MedStoreDisk","price",200).
coom_option("HDisk", "MaxStoreDisk").
coom_attribute_value("HDisk","MaxStoreDisk","capacity",1000).
coom_attribute_value("HDisk","MaxStoreDisk","price",500).

coom_enumeration("HDController").
coom_attribute("HDController","price","num").
coom_option("HDController", "MedStoreC").
coom_attribute_value("HDController","MedStoreC","price",500).
coom_option("HDController", "MaxStoreC").
coom_attribute_value("HDController","MaxStoreC","price",500).

coom_structure("Motherboard").
coom_feature("Motherboard","price","num",1,1).
coom_range("Motherboard","price",0,350).
coom_feature("Motherboard","mbtype","MBType",1,1).
coom_feature("Motherboard","cpu","CPU",1,1).

coom_enumeration("MBType").
coom_attribute("MBType","efficiency","str").
coom_attribute("MBType","price","num").
coom_option("MBType", "MBSilver").
coom_attribute_value("MBType","MBSilver","efficiency","B").
coom_attribute_value("MBType","MBSilver","price",250).
coom_option("MBType", "MBDiamond").
coom_attribute_value("MBType","MBDiamond","efficiency","A").
coom_attribute_value("MBType","MBDiamond","price",350).

coom_enumeration("CPU").
coom_attribute("CPU","clockrate","str").
coom_attribute("CPU","price","num").
coom_option("CPU", "CPUD").
coom_attribute_value("CPU","CPUD","clockrate","fast").
coom_attribute_value("CPU","CPUD","price",150).
coom_option("CPU", "CPUS").
coom_attribute_value("CPU","CPUS","clockrate","medium").
coom_attribute_value("CPU","CPUS","price",100).

coom_enumeration("Screen").
coom_attribute("Screen","efficiency","str").
coom_attribute("Screen","price","num").
coom_option("Screen", "ScreenA").
coom_attribute_value("Screen","ScreenA","efficiency","A").
coom_attribute_value("Screen","ScreenA","price",200).
coom_option("Screen", "ScreenB").
coom_attribute_value("Screen","ScreenB","efficiency","B").
coom_attribute_value("Screen","ScreenB","price",150).
coom_option("Screen", "ScreenC").
coom_attribute_value("Screen","ScreenC","efficiency","C").
coom_attribute_value("Screen","ScreenC","price",100).

coom_enumeration("OS").
coom_attribute("OS","hdcapacity","num").
coom_attribute("OS","price","num").
coom_option("OS", "OSBeta").
coom_attribute_value("OS","OSBeta","hdcapacity",13).
coom_attribute_value("OS","OSBeta","price",500).
coom_option("OS", "OSAlpha").
coom_attribute_value("OS","OSAlpha","hdcapacity",6).
coom_attribute_value("OS","OSAlpha","price",100).

coom_structure("Application").
coom_feature("Application","hdcapacity","num",1,1).
coom_range("Application","hdcapacity",200,200).
coom_feature("Application","price","num",1,1).
coom_range("Application","price",50,50).

coom_behavior(0).
coom_context(0,"product").
coom_imply("product","price","sum(hdunit.price)+motherboard.price+sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)").
coom_path("price",0,"price").
coom_binary("product","sum(hdunit.price)+motherboard.price+sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)","sum(hdunit.price)","+","motherboard.price+sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)").
coom_binary("product","motherboard.price+sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)","motherboard.price","+","sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)").
coom_binary("product","sum(motherboard.cpu.price)+os.price+sum(screen.price)+sum(applications.price)","sum(motherboard.cpu.price)","+","os.price+sum(screen.price)+sum(applications.price)").
coom_binary("product","os.price+sum(screen.price)+sum(applications.price)","os.price","+","sum(screen.price)+sum(applications.price)").
coom_binary("product","sum(screen.price)+sum(applications.price)","sum(screen.price)","+","sum(applications.price)").
coom_function("product","sum(hdunit.price)","sum","hdunit.price").
coom_path("hdunit.price",0,"hdunit").
coom_path("hdunit.price",1,"price").
coom_path("motherboard.price",0,"motherboard").
coom_path("motherboard.price",1,"price").
coom_function("product","sum(motherboard.cpu.price)","sum","motherboard.cpu.price").
coom_path("motherboard.cpu.price",0,"motherboard").
coom_path("motherboard.cpu.price",1,"cpu").
coom_path("motherboard.cpu.price",2,"price").
coom_path("os.price",0,"os").
coom_path("os.price",1,"price").
coom_function("product","sum(screen.price)","sum","screen.price").
coom_path("screen.price",0,"screen").
coom_path("screen.price",1,"price").
coom_function("product","sum(applications.price)","sum","applications.price").
coom_path("applications.price",0,"applications").
coom_path("applications.price",1,"price").

coom_behavior(1).
coom_context(1,"product").
coom_require(1,"price<=maxPrice").
coom_binary("product","price<=maxPrice","price","<=","maxPrice").
coom_path("price",0,"price").
coom_path("maxPrice",0,"maxPrice").

coom_behavior(2).
coom_context(2,"product").
coom_require(2,"os.hdcapacity+sum(applications.hdcapacity)<=sum(hdunit.hdisk.capacity)").
coom_binary("product","os.hdcapacity+sum(applications.hdcapacity)<=sum(hdunit.hdisk.capacity)","os.hdcapacity+sum(applications.hdcapacity)","<=","sum(hdunit.hdisk.capacity)").
coom_binary("product","os.hdcapacity+sum(applications.hdcapacity)","os.hdcapacity","+","sum(applications.hdcapacity)").
coom_path("os.hdcapacity",0,"os").
coom_path("os.hdcapacity",1,"hdcapacity").
coom_function("product","sum(applications.hdcapacity)","sum","applications.hdcapacity").
coom_path("applications.hdcapacity",0,"applications").
coom_path("applications.hdcapacity",1,"hdcapacity").
coom_function("product","sum(hdunit.hdisk.capacity)","sum","hdunit.hdisk.capacity").
coom_path("hdunit.hdisk.capacity",0,"hdunit").
coom_path("hdunit.hdisk.capacity",1,"hdisk").
coom_path("hdunit.hdisk.capacity",2,"capacity").

coom_behavior(3).
coom_context(3,"product").
coom_condition(3,"usage=Internet").
coom_binary("product","usage=Internet","usage","=","Internet").
coom_path("usage",0,"usage").
coom_constant("Internet").
coom_require(3,"internetConn=True").
coom_binary("product","internetConn=True","internetConn","=","True").
coom_path("internetConn",0,"internetConn").
coom_constant("True").

coom_behavior(4).
coom_context(4,"product").
coom_condition(4,"usage=Multimedia").
coom_binary("product","usage=Multimedia","usage","=","Multimedia").
coom_path("usage",0,"usage").
coom_constant("Multimedia").
coom_require(4,"internetConn=True").
coom_binary("product","internetConn=True","internetConn","=","True").
coom_path("internetConn",0,"internetConn").
coom_constant("True").

coom_behavior(5).
coom_context(5,"product").
coom_combinations(5,0,"efficiency").
coom_combinations(5,1,"motherboard.mbtype.efficiency").
coom_combinations(5,2,"screen.efficiency").
coom_path("efficiency",0,"efficiency").
coom_path("motherboard.mbtype.efficiency",0,"motherboard").
coom_path("motherboard.mbtype.efficiency",1,"mbtype").
coom_path("motherboard.mbtype.efficiency",2,"efficiency").
coom_path("screen.efficiency",0,"screen").
coom_path("screen.efficiency",1,"efficiency").
coom_allow(5,(0,0),"A").
coom_allow(5,(1,0),"A").
coom_allow(5,(2,0),"A").
coom_allow(5,(0,1),"B").
coom_allow(5,(1,1),"A").
coom_allow(5,(1,1),"B").
coom_allow(5,(2,1),"A").
coom_allow(5,(2,1),"B").
coom_allow(5,(0,2),"C").
coom_allow(5,(1,2),"A").
coom_allow(5,(1,2),"B").
coom_allow(5,(1,2),"C").
coom_allow(5,(2,2),"A").
coom_allow(5,(2,2),"B").
coom_allow(5,(2,2),"C").

coom_behavior(6).
coom_context(6,"product").
coom_condition(6,"os=OSAlpha").
coom_binary("product","os=OSAlpha","os","=","OSAlpha").
coom_path("os",0,"os").
coom_constant("OSAlpha").
coom_require(6,"motherboard.cpu=CPUD").
coom_binary("product","motherboard.cpu=CPUD","motherboard.cpu","=","CPUD").
coom_path("motherboard.cpu",0,"motherboard").
coom_path("motherboard.cpu",1,"cpu").
coom_constant("CPUD").

coom_behavior(7).
coom_context(7,"HDUnit").
coom_imply("HDUnit","price","sum(hdisk.price)+sum(hdcontroller.price)").
coom_path("price",0,"price").
coom_binary("HDUnit","sum(hdisk.price)+sum(hdcontroller.price)","sum(hdisk.price)","+","sum(hdcontroller.price)").
coom_function("HDUnit","sum(hdisk.price)","sum","hdisk.price").
coom_path("hdisk.price",0,"hdisk").
coom_path("hdisk.price",1,"price").
coom_function("HDUnit","sum(hdcontroller.price)","sum","hdcontroller.price").
coom_path("hdcontroller.price",0,"hdcontroller").
coom_path("hdcontroller.price",1,"price").

coom_behavior(8).
coom_context(8,"Motherboard").
coom_imply("Motherboard","price","mbtype.price").
coom_path("price",0,"price").
coom_path("mbtype.price",0,"mbtype").
coom_path("mbtype.price",1,"price").

coom_behavior(9).
coom_context(9,"Motherboard").
coom_condition(9,"mbtype=MBSilver").
coom_binary("Motherboard","mbtype=MBSilver","mbtype","=","MBSilver").
coom_path("mbtype",0,"mbtype").
coom_constant("MBSilver").
coom_require(9,"cpu!=CPUD").
coom_binary("Motherboard","cpu!=CPUD","cpu","!=","CPUD").
coom_path("cpu",0,"cpu").
coom_constant("CPUD").

coom_behavior(10).
coom_context(10,"Motherboard").
coom_condition(10,"mbtype=MBDiamond").
coom_binary("Motherboard","mbtype=MBDiamond","mbtype","=","MBDiamond").
coom_path("mbtype",0,"mbtype").
coom_constant("MBDiamond").
coom_require(10,"cpu!=CPUS").
coom_binary("Motherboard","cpu!=CPUS","cpu","!=","CPUS").
coom_path("cpu",0,"cpu").
coom_constant("CPUS").
