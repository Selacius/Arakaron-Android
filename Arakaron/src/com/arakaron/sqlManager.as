package com.arakaron{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.*;
	import flash.filesystem.File;
	
	public class sqlManager{
		
		private static var mainGame:Arakaron;
		
		public static var connection:SQLConnection;
		private static var load_sql:int = 0;
		public static var load_state:SQLStatement;
		
		private static var DefaultDB:File = File.applicationDirectory.resolvePath("com/arakaron/Assets/Database/DefaultDb.db");
		private static var dbFile:File = File.applicationStorageDirectory.resolvePath("Arakaron/myData.db");
		
		public function sqlManager(){
		}
		
		public static function init(ref_game:Arakaron):void {
			mainGame = ref_game;
			
			connection = new SQLConnection();
			
			if (!dbFile.exists) {
				trace ("dbFile does not exist");
				DefaultDB.copyTo(dbFile,false);
				Arakaron.first_run = true;
			}
			
			connection.openAsync(dbFile);
			trace ("Loading Connection");
			connection.addEventListener(SQLEvent.OPEN, onOpen);
			
			load_state = new SQLStatement()
			load_state.sqlConnection = connection;
			load_state.addEventListener(SQLEvent.RESULT,onLoadComplete);
		}
		
		private static function onOpen (event:SQLEvent):void {
			if (Arakaron.first_run) {
				mainGame.loadCharSelect();
			}else {
				connection.removeEventListener(SQLEvent.OPEN,onOpen);
				switch (load_sql) {
					case 0:
						load_state.text = "SELECT * FROM `game`";
						break;
					case 1:
						load_state.text = "SELECT * FROM `characters`";
						break;
					case 2:
						load_state.text = "SELECT * FROM `inventory`";
						break;
					case 3:
						load_state.text = "SELECT * FROM `events`";
						break;
					case 4:
						load_state.removeEventListener(SQLEvent.RESULT,onLoadComplete);
						mainGame.loadCharSelect();
						break;
				}
				if (load_sql != 4) {
					load_state.execute();
				}
			}
		}
		
		private static function onLoadComplete (event:SQLEvent):void {
			var result:SQLResult = event.currentTarget.getResult();
			switch (load_sql) {
				case 0:
					trace ("Loading Map Data");					
					mainGame.mapID = result.data[0].mapid;
					mainGame.x_coord = result.data[0].xcoord;
					mainGame.y_coord = result.data[0].ycoord;
					Arakaron.Gold = result.data[0].gold;
					
					load_sql++;
					break;
				case 1:
					trace ("Loading Character Data");
					if (result.data == null) {
						Arakaron.first_run = true;
						load_sql = 4;
					} else {
						var row:Object;
						for (var i:int = 0; i < result.data.length; i++) {
							row = result.data[i];
							Game_Party.load_player(row)
						}
						
						load_sql++;
						break;
					}
				case 2:
					trace ("Loading Inventory");
					var row:Object;
					for (var i:int = 0; i < result.data.length; i++) {
						row = result.data[i];
						Game_Inventory.loadInvent(row.index,int(row.quantity));
					}
					load_sql++;
					break
				case 3:
					trace ("Loading Events");
					var row:Object;
					for (var i:int = 0; i < result.data.length; i++) {
						row = result.data[i];
						Arakaron.GameEvents[row.event_id] = new Array(row.switch1, row.switch2);
					}
					load_sql = 4;
					break
			}
			onOpen(null);
		}
		
		public static function insertSQL (table:String, value:Object):void {
			load_state = new SQLStatement();
			switch (table) {
				case "characters":
					load_state.text = "INSERT OR REPLACE INTO `characters` (`id`,`alias`,`lvl`,`active_party`,`a_str`,`a_agi`,`a_spr`,`a_dex`,`a_vit`,`a_wisdom`,`a_hp`,`hp`,`a_mp`,`mp`, `helm`,`chest`,`gloves`,`boots`,`necklace`,`ring1`,`ring2`,`main_hand`,`off_hand`)" +
														"VALUES (@id, @alias, @lvl, @active_party, @a_str, @a_agi, @a_spr, @a_dex, @a_vit, @a_wisdom, @a_hp, @hp, @a_mp, @mp, @Helm, @Chest, @Gloves, @Boots, @Neck, @Ring1, @Ring2, @MHand, @OHand);";
					
					load_state.parameters["@id"] = value.ident;
					load_state.parameters["@alias"] = value.alias;
					load_state.parameters["@lvl"] = value.lvl;
					load_state.parameters["@active_party"] = int(value.active_party);
					load_state.parameters["@a_str"] = value.a_str + 5;
					load_state.parameters["@a_agi"] = value.a_agi;
					load_state.parameters["@a_spr"] = value.a_spr;
					load_state.parameters["@a_dex"] = value.a_dex;
					load_state.parameters["@a_vit"] = value.a_vit;
					load_state.parameters["@a_wisdom"] = value.a_wisdom;
					load_state.parameters["@a_hp"] = value.a_hp;
					load_state.parameters["@hp"] = int(value.HPMin * 0.5);
					load_state.parameters["@a_mp"] = value.a_mp;
					load_state.parameters["@mp"] = int(value.MPMin * 0.75);
					
					var sqlVal:int;
					for (var val in value.gear.A) {
						if (value.gear.A[val] == null) {
							sqlVal = -1;
						} else {
							sqlVal = value.gear.A[val].iID;
						}
						load_state.parameters["@"+val] = sqlVal; 
					}
					
					for (val in value.gear.W) {
						if (value.gear.W[val] == null) {
							sqlVal = -1;
						} else {
							sqlVal = value.gear.W[val].iID;
						}
						load_state.parameters["@"+val] = sqlVal; 
					}
					
					for (val in value.gear.J) {
						if (value.gear.J[val] == null) {
							sqlVal = -1;
						} else {
							sqlVal = value.gear.J[val].iID;
						}
						load_state.parameters["@"+val] = sqlVal; 
					}
					
					break;
				case "inventory":
					load_state.text = "INSERT OR REPLACE INTO `inventory` (`index`,`quantity`) VALUES (@id, @quan);";
					
					load_state.parameters["@quan"] = int(value.quan);
					load_state.parameters["@id"] = String(value.index);
					
					break;
				case "events":
					load_state.text = "INSERT OR REPLACE INTO `events` (`event_id`,`switch1`,`switch2`) VALUES (@id, @switch1, @switch2);";
					
					load_state.parameters["@id"] = String(value.event_id);
					load_state.parameters["@switch1"] = int(value.switch1);
					load_state.parameters["@switch2"] = int(value.switch2);
					
					break;
			}
			
			load_state.sqlConnection = connection;
			
			load_state.execute();
		}
		
		public static function onExit (e:Event):void {
			connection.addEventListener(SQLEvent.CLOSE,onSQLClose);
			connection.close();
		}
		
		private static function onSQLClose (e:SQLEvent):void {
			dbFile.deleteFile();
		}
	}
}