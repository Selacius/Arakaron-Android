package{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.*;
	import flash.filesystem.File;
	
	public class sqlManager{
		private static var GameDB:File = File.documentsDirectory.resolvePath("Arakaron/Arakaron - Android/Arakaron/src/com/arakaron/Assets/Database/GameDB.db");
		public static var connection:SQLConnection;
		public static var loadState:SQLStatement;
		private var loadSQL:int = -1;
		private var loadMapSQL:int = 0;
		
		public static var mapInfo:Array = new Array();
		public static var maps:Object = new Object();
		
		public var mapInfoSingle:Object;
		public var mapObsSingle:Object;
		public var mapImmoveSingle:Object;
		
		public var tempMapInfo:String;
		
		public function sqlManager(){
			connection = new SQLConnection();
			connection.openAsync(GameDB);
			trace ("Loading Connection");
			connection.addEventListener(SQLEvent.OPEN, onOpen);
			
			loadState = new SQLStatement();
			loadState.sqlConnection = connection;
			loadState.addEventListener(SQLEvent.RESULT,onLoadComplete);
		}
		
		public function onOpen(e:Event):void {
			connection.removeEventListener(SQLEvent.OPEN,onOpen);
			switch (loadSQL) {
				case -1:
					loadState.text = "SELECT * FROM `mapInfo`";
					break;
				case 0:
					tempMapInfo = mapInfo[loadSQL].mapName;
					loadState.text = "SELECT * FROM `"+tempMapInfo+"`";
					break;
				case 2:
					loadState.text = "SELECT * FROM `armors`";
					break;
				case 3:
					loadState.text = "SELECT * FROM `weapons`";
					break;
			}
			if (loadSQL != 1){
				loadState.execute();
			}
		}
		
		public function onLoadComplete(e:Event):void {
			var result:SQLResult = e.currentTarget.getResult();
			switch (loadSQL) {
				case -1:
					mapInfo = result.data;
					loadSQL++;
					break;
				case 0:
					maps[String(e.currentTarget.text).split("`")[1]] = result.data;
					loadMapSQL++;
					break;
			}
			if (mapInfo != null) {
				if (loadMapSQL < mapInfo.length) {
					onOpen(null);
				} else {
					loadState.removeEventListener(SQLEvent.RESULT,onLoadComplete);
				}
			}
		}
		
		public function getMaps(map:String):Object {
			return (maps[map]);
		}
		
		public function getSQLVersion(map:String):String {
			var _val:String = " ";
			if (mapInfo != null) {
				for (var i:int; i<mapInfo.length; i++) {
					if (mapInfo[i].mapName == map) {
						_val = mapInfo[i].mapVersion;
						break;
					}
				}
			}
			return (_val);
		}
		
		public function tableExists(map:String):Boolean {
			if (maps[map]) {
				return true;
			} else {
				return false;
			}
		}
		
		public function insertGearInfo(gear:Object):void {
			loadState.addEventListener(SQLEvent.RESULT,onGearInfoInsert);
			
			loadState.text = "INSERT INTO `"+gear.Table+"` (`iAlias`, `iSlot`, `iLvl`, `iLogo`, `iCaste`, `iStyle`, `iRarity`, `iQuality`, `iAtk`, `iAtkP`, `iDef`, `iDefP`, `imDef`, `iDesc`, `iStats`, `iOnHit`, `iCost`)"+
							 "VALUES (@iAlias, @iSlot, @iLvl, @iLogo, @iCaste, @iStyle, @iRarity, @iQuality, @iAtk, @iAtkP, @iDef, @iDefP, @imDef, @iDesc, @iStats, @iOnHit, @iCost);";
			
			loadState.parameters["@iAlias"] = gear.Alias;
			loadState.parameters["@iSlot"] = gear.Slot;
			loadState.parameters["@iLvl"] = gear.Lvl;
			loadState.parameters["@iLogo"] = 1;
			
			loadState.parameters["@iCaste"] = gear.Caste;
			loadState.parameters["@iStyle"] = gear.Style;
			loadState.parameters["@iRarity"] = gear.Rarity;
			loadState.parameters["@iQuality"] = gear.Quality;
			
			loadState.parameters["@iAtk"] = gear.Atk;
			loadState.parameters["@iAtkP"] = gear.Atkp;
			loadState.parameters["@iDef"] = gear.Def;
			loadState.parameters["@iDefP"] = gear.Defp;
			loadState.parameters["@imDef"] = gear.mDef;
			
			loadState.parameters["@iDesc"] = gear.Desc;
			loadState.parameters["@iStats"] = gear.iStats;
			loadState.parameters["@iOnHit"] = gear.OnHit;
			
			loadState.parameters["@iCost"] = gear.Cost;
			
			loadState.execute();
		}
		
		public function onGearInfoInsert (e:SQLEvent):void {
			
		}
		
		public function insertMapInfo(mapInfo:Object, mapObs:Object, mapImmove:Object):void {
			this.mapInfoSingle = mapInfo;
			this.mapObsSingle = mapObs;
			this.mapImmoveSingle = mapImmove;
			
			if (this.mapObsSingle[0] && this.mapImmoveSingle[0]) {
				loadState.addEventListener(SQLEvent.RESULT,onMapInfoInsert);
				
				loadState.text = "INSERT OR REPLACE INTO `mapInfo` (`mapName`,`mapWidth`,`mapHeight`,`mapType`,`mapVersion`,`mapBossID`,`mapLvlMin`,`mapLvlMax`)" +
								 "VALUES (@mapName, @mapWidth, @mapHeight, @mapType, @mapVersion, @mapBossID, @mapLvlMin, @mapLvlMax);";
				
				loadState.parameters["@mapName"] = mapInfo.mapName;
				loadState.parameters["@mapWidth"] = int(mapInfo.mapWidth);
				loadState.parameters["@mapHeight"] = int(mapInfo.mapHeight);
				loadState.parameters["@mapType"] = mapInfo.mapType;
				loadState.parameters["@mapVersion"] = (mapInfo.mapVersion);
				loadState.parameters["@mapBossID"] = int(mapInfo.mapBossID);
				loadState.parameters["@mapLvlMin"] = int(mapInfo.mapLvlMin);
				loadState.parameters["@mapLvlMax"] = int(mapInfo.mapLvlMax);
				
				loadState.execute();
			} else {
				if (!this.mapObsSingle[0]) {
					mapManager._complete.text += "   -Collidable Object Layer Not Present.";
				}
				if (!this.mapImmoveSingle[0]) {
					mapManager._complete.text += "   -Immovable Object Layer Not Present.";
				}
				mapManager._complete.text += "   -Parsing Prevented Until Layer(s) Present.";
			}
		}
		
		public function onMapInfoInsert(e:SQLEvent):void {
			mapManager._complete.text += "   -Map Info Inserted";
			
			loadState.removeEventListener(SQLEvent.RESULT,onMapInfoInsert);
			loadState.addEventListener(SQLEvent.RESULT,onMapTableCreate);
			
			loadState.text = "CREATE TABLE IF NOT EXISTS `"+mapInfoSingle.mapName+"` (`tileAlias` TEXT,`tileType` TEXT,`tileFrame` INTEGER,`tileX` INTEGER,`tileY` INTEGER,"+
				"`tileWidth` INTEGER,`tileHeight` INTEGER,`tileVal1` TEXT,`tileVal2` TEXT,`tileVal3` TEXT,`tileVal4` TEXT,`tileVal5` TEXT);";
			loadState.clearParameters();
			
			loadState.execute();
		}
		
		public function onMapTableCreate(e:SQLEvent):void {
			mapManager._complete.text += "   -Map Table Created";
			loadState.removeEventListener(SQLEvent.RESULT,onMapTableCreate);
			var saveState:SQLStatement = new SQLStatement();
			
			var sqlText:String = "INSERT OR REPLACE INTO `"+mapInfoSingle.mapName+"` (`tileAlias`,`tileType`,`tileFrame`,`tileX`,`tileY`,`tileWidth`,`tileHeight`,`tileVal1`,`tileVal2`,`tileVal3`,`tileVal4`,`tileVal5`)" +
							 "VALUES (@tileAlias, @tileType, @tileFrame, @tileX, @tileY, @tileWidth, @tileHeight, @tileVal1, @tileVal2, @tileVal3, @tileVal4, @tileVal5);";
			
			var tileProps:Object = new Object();
			
			for each (var val:XML in this.mapObsSingle) {
				saveState = new SQLStatement();
				saveState.sqlConnection = connection;
				saveState.text = sqlText;
				
				saveState.clearParameters();
				
				saveState.parameters["@tileAlias"] = String(val.@name);
				saveState.parameters["@tileType"] = String(val.@type);
				saveState.parameters["@tileX"] = int(val.@x);
				saveState.parameters["@tileY"] = int(val.@y);
				saveState.parameters["@tileWidth"] = int(val.@width);
				saveState.parameters["@tileHeight"] = int(val.@height);
				
				saveState.parameters["@tileFrame"] = int("");
				saveState.parameters["@tileVal1"] = "";
				saveState.parameters["@tileVal2"] = "";
				saveState.parameters["@tileVal3"] = "";
				saveState.parameters["@tileVal4"] = "";
				saveState.parameters["@tileVal5"] = "";
				
				tileProps = val.properties.property;
				switch (String(val.@name)) {
					case "Chest":
						saveState.parameters["@tileFrame"] = int(tileProps[0].@value);
						saveState.parameters["@tileVal1"] = tileProps[1].@value+","+tileProps[2].@value+","+tileProps[3].@value;
						saveState.parameters["@tileVal2"] = tileProps[4].@value;
						break;
					case "Exit":
						saveState.parameters["@tileVal1"] = tileProps[0].@value;
						saveState.parameters["@tileVal2"] = tileProps[1].@value;
						saveState.parameters["@tileVal3"] = tileProps[2].@value;
						break;
					case "Block":
						saveState.parameters["@tileVal1"] = tileProps[0].@value;
						saveState.parameters["@tileVal2"] = tileProps[1].@value;
						saveState.parameters["@tileVal3"] = tileProps[2].@value;
						break;
					case "Door":
						saveState.parameters["@tileFrame"] = tileProps[1].@value;
						saveState.parameters["@tileVal1"] = tileProps[0].@value;
						saveState.parameters["@tileVal2"] = tileProps[2].@value;
						break;
					case "Ore":
						saveState.parameters["@tileFrame"] = tileProps[0].@value;
						saveState.parameters["@tileVal1"] = tileProps[1].@value;
						break;
					case "Switch":
						saveState.parameters["@tileFrame"] = int(tileProps[0].@value);
						saveState.parameters["@tileVal1"] = tileProps[1].@value;
						saveState.parameters["@tileVal2"] = tileProps[2].@value;
						saveState.parameters["@tileVal3"] = tileProps[3].@value;
						saveState.parameters["@tileVal4"] = tileProps[4].@value;
						break;
					case "Sign":
						saveState.parameters["@tileFrame"] = int(tileProps[0].@value);
						saveState.parameters["@tileVal1"] = tileProps[1].@value;
						break;
					case "Animation":
						saveState.parameters["@tileFrame"] = int(tileProps[0].@value);
						break;
				}
				saveState.execute();	
			}
			for each (val in this.mapImmoveSingle) {
				saveState = new SQLStatement();
				saveState.sqlConnection = connection;
				saveState.text = sqlText;
				
				saveState.clearParameters();
				
				saveState.parameters["@tileAlias"] = String(val.@name);
				saveState.parameters["@tileType"] = String(val.@type);
				saveState.parameters["@tileX"] = int(val.@x);
				saveState.parameters["@tileY"] = int(val.@y);
				saveState.parameters["@tileWidth"] = int(val.@width);
				saveState.parameters["@tileHeight"] = int(val.@height);
				
				saveState.parameters["@tileFrame"] = int("");
				saveState.parameters["@tileVal1"] = "";
				saveState.parameters["@tileVal2"] = "";
				saveState.parameters["@tileVal3"] = "";
				saveState.parameters["@tileVal4"] = "";
				saveState.parameters["@tileVal5"] = "";
				
				saveState.execute();
			}
			mapManager._complete.text += "   -Map Object Data Inserted";
		}
	}
}