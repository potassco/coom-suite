%%% COOM model
coom_structure("product").
coom_feature("product","grundmerkmale","Grundmerkmale",1,1).
coom_feature("product","pfosten","Pfosten",1,1).
coom_feature("product","cover","Cover",1,1).

coom_structure("Grundmerkmale").
coom_feature("Grundmerkmale","montagehoehe","num",1,1).
coom_feature("Grundmerkmale","durchgangshoehe","num",1,1).
coom_feature("Grundmerkmale","laenge","num",1,1).
coom_feature("Grundmerkmale","eingabeBreite","num",1,1).
coom_feature("Grundmerkmale","bestellBreite","num",1,1).
coom_feature("Grundmerkmale","flaeche","num",1,1).
coom_feature("Grundmerkmale","neigungswinkelAnlage","num",1,1).
coom_feature("Grundmerkmale","weight","num",1,1).

coom_structure("Pfosten").
coom_feature("Pfosten","km_gesamthoehe","num",1,1).
coom_feature("Pfosten","km_mittePfosten","num",1,1).
coom_feature("Pfosten","ueberstand","num",1,1).
coom_feature("Pfosten","typPfosten","TypPfosten",1,1).

coom_enumeration("TypPfosten").
coom_option("TypPfosten", "_Ohne").
coom_option("TypPfosten", "_Starr").
coom_option("TypPfosten", "_Hoehenverstellbar").
coom_option("TypPfosten", "_Doppelpfosten").

coom_enumeration("Cover").
coom_attribute("Cover","weight","num").
coom_option("Cover", "_AcrylLumera").
coom_attribute_value("Cover","_AcrylLumera","weight",1495).
coom_option("Cover", "_AcrylPerfora").
coom_attribute_value("Cover","_AcrylPerfora","weight",1238).
coom_option("Cover", "_AcrylAllWeather").
coom_attribute_value("Cover","_AcrylAllWeather","weight",2600).
coom_option("Cover", "_AcrylStandardFremd").
coom_attribute_value("Cover","_AcrylStandardFremd","weight",800).
coom_option("Cover", "_AcrylUniQuer").
coom_attribute_value("Cover","_AcrylUniQuer","weight",599).
coom_option("Cover", "_AcrylUniQuerFremd").
coom_attribute_value("Cover","_AcrylUniQuerFremd","weight",673).
coom_option("Cover", "_KombiAcryl").
coom_attribute_value("Cover","_KombiAcryl","weight",2598).
coom_option("Cover", "_KombiSoltis").
coom_attribute_value("Cover","_KombiSoltis","weight",2293).
coom_option("Cover", "_Satinee").
coom_attribute_value("Cover","_Satinee","weight",1487).
coom_option("Cover", "_Screen").
coom_attribute_value("Cover","_Screen","weight",2499).

coom_behavior(0).
coom_context(0,"Pfosten").
coom_require(0,"ueberstand=(root.grundmerkmale.eingabeBreite-km_mittePfosten)").
coom_binary("ueberstand=(root.grundmerkmale.eingabeBreite-km_mittePfosten)","ueberstand","=","(root.grundmerkmale.eingabeBreite-km_mittePfosten)").
coom_path("ueberstand",0,"ueberstand").
coom_unary("(root.grundmerkmale.eingabeBreite-km_mittePfosten)","()","root.grundmerkmale.eingabeBreite-km_mittePfosten").
coom_binary("root.grundmerkmale.eingabeBreite-km_mittePfosten","root.grundmerkmale.eingabeBreite","-","km_mittePfosten").
coom_path("root.grundmerkmale.eingabeBreite",0,"root").
coom_path("root.grundmerkmale.eingabeBreite",1,"grundmerkmale").
coom_path("root.grundmerkmale.eingabeBreite",2,"eingabeBreite").
coom_path("km_mittePfosten",0,"km_mittePfosten").

coom_behavior(1).
coom_context(1,"Pfosten").
coom_require(1,"km_gesamthoehe=(root.grundmerkmale.durchgangshoehe+(tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand))").
coom_binary("km_gesamthoehe=(root.grundmerkmale.durchgangshoehe+(tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand))","km_gesamthoehe","=","(root.grundmerkmale.durchgangshoehe+(tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand))").
coom_path("km_gesamthoehe",0,"km_gesamthoehe").
coom_unary("(root.grundmerkmale.durchgangshoehe+(tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand))","()","root.grundmerkmale.durchgangshoehe+(tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand)").
coom_binary("root.grundmerkmale.durchgangshoehe+(tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand)","root.grundmerkmale.durchgangshoehe","+","(tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand)").
coom_path("root.grundmerkmale.durchgangshoehe",0,"root").
coom_path("root.grundmerkmale.durchgangshoehe",1,"grundmerkmale").
coom_path("root.grundmerkmale.durchgangshoehe",2,"durchgangshoehe").
coom_unary("(tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand)","()","tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand").
coom_binary("tan(root.grundmerkmale.neigungswinkelAnlage)*ueberstand","tan(root.grundmerkmale.neigungswinkelAnlage)","*","ueberstand").
coom_unary("tan(root.grundmerkmale.neigungswinkelAnlage)","tan","root.grundmerkmale.neigungswinkelAnlage").
coom_path("root.grundmerkmale.neigungswinkelAnlage",0,"root").
coom_path("root.grundmerkmale.neigungswinkelAnlage",1,"grundmerkmale").
coom_path("root.grundmerkmale.neigungswinkelAnlage",2,"neigungswinkelAnlage").
coom_path("ueberstand",0,"ueberstand").

coom_behavior(2).
coom_context(2,"Pfosten").
coom_require(2,"ueberstand>105").
coom_binary("ueberstand>105","ueberstand",">","105").
coom_path("ueberstand",0,"ueberstand").
coom_number("105",105).

coom_behavior(3).
coom_context(3,"Pfosten").
coom_require(3,"km_mittePfosten<4000").
coom_binary("km_mittePfosten<4000","km_mittePfosten","<","4000").
coom_path("km_mittePfosten",0,"km_mittePfosten").
coom_number("4000",4000).

coom_behavior(4).
coom_context(4,"Pfosten").
coom_require(4,"km_gesamthoehe>1000").
coom_binary("km_gesamthoehe>1000","km_gesamthoehe",">","1000").
coom_path("km_gesamthoehe",0,"km_gesamthoehe").
coom_number("1000",1000).

coom_behavior(5).
coom_context(5,"Pfosten").
coom_require(5,"km_gesamthoehe<3200").
coom_binary("km_gesamthoehe<3200","km_gesamthoehe","<","3200").
coom_path("km_gesamthoehe",0,"km_gesamthoehe").
coom_number("3200",3200).

coom_behavior(6).
coom_context(6,"Pfosten").
coom_condition(6,"km_gesamthoehe>2200").
coom_binary("km_gesamthoehe>2200","km_gesamthoehe",">","2200").
coom_path("km_gesamthoehe",0,"km_gesamthoehe").
coom_number("2200",2200).
coom_require(6,"typPfosten!=_Doppelpfosten").
coom_binary("typPfosten!=_Doppelpfosten","typPfosten","!=","_Doppelpfosten").
coom_path("typPfosten",0,"typPfosten").
coom_path("_Doppelpfosten",0,"_Doppelpfosten").

coom_behavior(7).
coom_context(7,"product").
coom_require(7,"grundmerkmale.neigungswinkelAnlage=(atan(((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))))+acos((48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2))))))").
coom_binary("grundmerkmale.neigungswinkelAnlage=(atan(((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))))+acos((48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2))))))","grundmerkmale.neigungswinkelAnlage","=","(atan(((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))))+acos((48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2))))))").
coom_path("grundmerkmale.neigungswinkelAnlage",0,"grundmerkmale").
coom_path("grundmerkmale.neigungswinkelAnlage",1,"neigungswinkelAnlage").
coom_unary("(atan(((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))))+acos((48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2))))))","()","atan(((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))))+acos((48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)))))").
coom_binary("atan(((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))))+acos((48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)))))","atan(((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))))","+","acos((48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)))))").
coom_unary("atan(((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))))","atan","((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe)))").
coom_unary("((125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe)))","()","(125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))").
coom_binary("(125-grundmerkmale.eingabeBreite)/((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))","(125-grundmerkmale.eingabeBreite)","/","((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))").
coom_unary("(125-grundmerkmale.eingabeBreite)","()","125-grundmerkmale.eingabeBreite").
coom_binary("125-grundmerkmale.eingabeBreite","125","-","grundmerkmale.eingabeBreite").
coom_number("125",125).
coom_path("grundmerkmale.eingabeBreite",0,"grundmerkmale").
coom_path("grundmerkmale.eingabeBreite",1,"eingabeBreite").
coom_unary("((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))","()","(grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe)").
coom_binary("(grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe)","(grundmerkmale.montagehoehe-8.82)","+","(90-grundmerkmale.durchgangshoehe)").
coom_unary("(grundmerkmale.montagehoehe-8.82)","()","grundmerkmale.montagehoehe-8.82").
coom_binary("grundmerkmale.montagehoehe-8.82","grundmerkmale.montagehoehe","-","8.82").
coom_path("grundmerkmale.montagehoehe",0,"grundmerkmale").
coom_path("grundmerkmale.montagehoehe",1,"montagehoehe").
coom_unary("(90-grundmerkmale.durchgangshoehe)","()","90-grundmerkmale.durchgangshoehe").
coom_binary("90-grundmerkmale.durchgangshoehe","90","-","grundmerkmale.durchgangshoehe").
coom_number("90",90).
coom_path("grundmerkmale.durchgangshoehe",0,"grundmerkmale").
coom_path("grundmerkmale.durchgangshoehe",1,"durchgangshoehe").
coom_unary("acos((48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)))))","acos","(48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2))))").
coom_unary("(48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2))))","()","48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)))").
coom_binary("48.4985/sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)))","48.4985","/","sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)))").
coom_unary("sqrt(((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)))","sqrt","((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2))").
coom_unary("((((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2))","()","(((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)").
coom_binary("(((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)+((125-grundmerkmale.eingabeBreite)^2)","(((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)","+","((125-grundmerkmale.eingabeBreite)^2)").
coom_unary("(((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2)","()","((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2").
coom_binary("((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))^2","((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))","^","2").
coom_unary("((grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe))","()","(grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe)").
coom_binary("(grundmerkmale.montagehoehe-8.82)+(90-grundmerkmale.durchgangshoehe)","(grundmerkmale.montagehoehe-8.82)","+","(90-grundmerkmale.durchgangshoehe)").
coom_unary("(grundmerkmale.montagehoehe-8.82)","()","grundmerkmale.montagehoehe-8.82").
coom_binary("grundmerkmale.montagehoehe-8.82","grundmerkmale.montagehoehe","-","8.82").
coom_path("grundmerkmale.montagehoehe",0,"grundmerkmale").
coom_path("grundmerkmale.montagehoehe",1,"montagehoehe").
coom_unary("(90-grundmerkmale.durchgangshoehe)","()","90-grundmerkmale.durchgangshoehe").
coom_binary("90-grundmerkmale.durchgangshoehe","90","-","grundmerkmale.durchgangshoehe").
coom_number("90",90).
coom_path("grundmerkmale.durchgangshoehe",0,"grundmerkmale").
coom_path("grundmerkmale.durchgangshoehe",1,"durchgangshoehe").
coom_number("2",2).
coom_unary("((125-grundmerkmale.eingabeBreite)^2)","()","(125-grundmerkmale.eingabeBreite)^2").
coom_binary("(125-grundmerkmale.eingabeBreite)^2","(125-grundmerkmale.eingabeBreite)","^","2").
coom_unary("(125-grundmerkmale.eingabeBreite)","()","125-grundmerkmale.eingabeBreite").
coom_binary("125-grundmerkmale.eingabeBreite","125","-","grundmerkmale.eingabeBreite").
coom_number("125",125).
coom_path("grundmerkmale.eingabeBreite",0,"grundmerkmale").
coom_path("grundmerkmale.eingabeBreite",1,"eingabeBreite").
coom_number("2",2).

coom_behavior(8).
coom_context(8,"product").
coom_require(8,"grundmerkmale.bestellBreite=(grundmerkmale.eingabeBreite+(tan(grundmerkmale.neigungswinkelAnlage)*80))").
coom_binary("grundmerkmale.bestellBreite=(grundmerkmale.eingabeBreite+(tan(grundmerkmale.neigungswinkelAnlage)*80))","grundmerkmale.bestellBreite","=","(grundmerkmale.eingabeBreite+(tan(grundmerkmale.neigungswinkelAnlage)*80))").
coom_path("grundmerkmale.bestellBreite",0,"grundmerkmale").
coom_path("grundmerkmale.bestellBreite",1,"bestellBreite").
coom_unary("(grundmerkmale.eingabeBreite+(tan(grundmerkmale.neigungswinkelAnlage)*80))","()","grundmerkmale.eingabeBreite+(tan(grundmerkmale.neigungswinkelAnlage)*80)").
coom_binary("grundmerkmale.eingabeBreite+(tan(grundmerkmale.neigungswinkelAnlage)*80)","grundmerkmale.eingabeBreite","+","(tan(grundmerkmale.neigungswinkelAnlage)*80)").
coom_path("grundmerkmale.eingabeBreite",0,"grundmerkmale").
coom_path("grundmerkmale.eingabeBreite",1,"eingabeBreite").
coom_unary("(tan(grundmerkmale.neigungswinkelAnlage)*80)","()","tan(grundmerkmale.neigungswinkelAnlage)*80").
coom_binary("tan(grundmerkmale.neigungswinkelAnlage)*80","tan(grundmerkmale.neigungswinkelAnlage)","*","80").
coom_unary("tan(grundmerkmale.neigungswinkelAnlage)","tan","grundmerkmale.neigungswinkelAnlage").
coom_path("grundmerkmale.neigungswinkelAnlage",0,"grundmerkmale").
coom_path("grundmerkmale.neigungswinkelAnlage",1,"neigungswinkelAnlage").
coom_number("80",80).

coom_behavior(9).
coom_context(9,"product").
coom_require(9,"grundmerkmale.flaeche=(grundmerkmale.laenge*(grundmerkmale.bestellBreite/1000000))").
coom_binary("grundmerkmale.flaeche=(grundmerkmale.laenge*(grundmerkmale.bestellBreite/1000000))","grundmerkmale.flaeche","=","(grundmerkmale.laenge*(grundmerkmale.bestellBreite/1000000))").
coom_path("grundmerkmale.flaeche",0,"grundmerkmale").
coom_path("grundmerkmale.flaeche",1,"flaeche").
coom_unary("(grundmerkmale.laenge*(grundmerkmale.bestellBreite/1000000))","()","grundmerkmale.laenge*(grundmerkmale.bestellBreite/1000000)").
coom_binary("grundmerkmale.laenge*(grundmerkmale.bestellBreite/1000000)","grundmerkmale.laenge","*","(grundmerkmale.bestellBreite/1000000)").
coom_path("grundmerkmale.laenge",0,"grundmerkmale").
coom_path("grundmerkmale.laenge",1,"laenge").
coom_unary("(grundmerkmale.bestellBreite/1000000)","()","grundmerkmale.bestellBreite/1000000").
coom_binary("grundmerkmale.bestellBreite/1000000","grundmerkmale.bestellBreite","/","1000000").
coom_path("grundmerkmale.bestellBreite",0,"grundmerkmale").
coom_path("grundmerkmale.bestellBreite",1,"bestellBreite").
coom_number("1000000",1000000).

coom_behavior(10).
coom_context(10,"product").
coom_require(10,"grundmerkmale.weight=(grundmerkmale.flaeche*(cover.weight/1000))").
coom_binary("grundmerkmale.weight=(grundmerkmale.flaeche*(cover.weight/1000))","grundmerkmale.weight","=","(grundmerkmale.flaeche*(cover.weight/1000))").
coom_path("grundmerkmale.weight",0,"grundmerkmale").
coom_path("grundmerkmale.weight",1,"weight").
coom_unary("(grundmerkmale.flaeche*(cover.weight/1000))","()","grundmerkmale.flaeche*(cover.weight/1000)").
coom_binary("grundmerkmale.flaeche*(cover.weight/1000)","grundmerkmale.flaeche","*","(cover.weight/1000)").
coom_path("grundmerkmale.flaeche",0,"grundmerkmale").
coom_path("grundmerkmale.flaeche",1,"flaeche").
coom_unary("(cover.weight/1000)","()","cover.weight/1000").
coom_binary("cover.weight/1000","cover.weight","/","1000").
coom_path("cover.weight",0,"cover").
coom_path("cover.weight",1,"weight").
coom_number("1000",1000).
