package com.arakaron{
	import com.arakaron.Helpers.Gear.Armor;
	import com.arakaron.Helpers.Gear.Weapon;
	
	import flash.data.*;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.SQLError;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class dbManager{
		
		private static var GameDB:File = File.applicationDirectory.resolvePath("com/arakaron/Assets/Database/GameDB.db");
		
		public static var Allies:Array = new Array();
		public static var Gear:Object = new Object();
		private static var Armors:Array = new Array();
		private static var Weapons:Array = new Array();
		
		public static var loadArray:Array = new Array("Armors","Weapons","Allies");
		private static var loadVal:int;
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public static var connection:SQLConnection;
		private static var load_sql:int = -1;
		public static var load_state:SQLStatement;
		
		public function dbManager(){
		}
		
		public static function setDBLoad ():void {
			connection = new SQLConnection();
			
			connection.openAsync(GameDB);
			trace ("Loading GameDB Connection");
			connection.addEventListener(SQLEvent.OPEN, onOpen);
			
			load_state = new SQLStatement()
			load_state.sqlConnection = connection;
			load_state.addEventListener(SQLEvent.RESULT,onLoadComplete);
			load_state.addEventListener(SQLErrorEvent.ERROR,onError);
		}
		
		public static function onOpen(event:SQLEvent):void {
			
		}
		
		public static function onLoadComplete(event:SQLEvent):void {
			
		}
		
		public static function onError(event:SQLEvent):void {
			
		}
		
		public static function startDBLoad():void {
			xmlLoader(loadArray[loadVal]);
			
			loadVal++;
			if (loadVal < loadArray.length) {
				startDBLoad();
			}
		}
		
		private static function xmlLoader (value:Array):void {
			var loadType:String = value[0];
			if (value.length > 1) {
				var xmlFile:XML = value[1]
			}
			
			var xmlDoc:XML;
				
			switch (loadType) {
				case "Allies":
					for (var code:String in xmlFile.ally) {
						xmlDoc = xmlFile.ally[code];
						Allies.push (new Player(xmlDoc));
					}
					dispatchEvent();
					break;
				case "Armors":
					for (var code:String in xmlFile.armors) {
						xmlDoc = xmlFile.armors[code];
						Armors.push (new Armor(xmlDoc));
					}
					Gear.A = Armors;
					dispatchEvent();
					break;
				case "Weapons":
					for (var code:String in xmlFile.weapons) {
						xmlDoc = xmlFile.weapons[code];
						Weapons.push (new Weapon(xmlDoc));
					}
					Gear.W = Weapons;
					dispatchEvent();
					break;
			}
		}
		
		public static function addEventListener(type:String, listener:Function):void {
			dispatcher.addEventListener(type, listener);
		}
		
		public static function dispatchEvent ():Boolean {
			return dispatcher.dispatchEvent(new Event("fullTick",true));
		}
	}
}