coom_structure("product").
coom_feature("product","persons","Person",2,2).
coom_feature("product","rooms","Room",2,2).
coom_feature("product","things","Thing",2,2).

coom_structure("Person").
coom_reference("Person","roomsOwned","Room",0,2).
coom_reference("Person","thingOwned","Thing",1,1).

coom_structure("Thing").
coom_reference("Thing","storedInRoom","Room",1,1).
coom_reference("Thing","owner","Person",1,1).

coom_structure("Room").
coom_reference("Room","things","Thing",1,1).
coom_reference("Room","owner","Person",1,1).

coom_behavior(0).
coom_context(0,"Person").
coom_require(0,"thingOwned.storedInRoom.owner=this").
coom_binary("thingOwned.storedInRoom.owner=this","thingOwned.storedInRoom.owner","=","this").
coom_path("thingOwned.storedInRoom.owner",0,"thingOwned").
coom_path("thingOwned.storedInRoom.owner",1,"storedInRoom").
coom_path("thingOwned.storedInRoom.owner",2,"owner").
coom_path("this",0,"this").
coom_user_associate(("root.persons[0]","root.things[0]")).
coom_user_associate(("root.persons[1]","root.things[1]")).
