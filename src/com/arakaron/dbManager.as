package com.arakaron{
	import com.arakaron.Helpers.Gear.Armor;
	import com.arakaron.Helpers.Gear.Weapon;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class dbManager{
		
		[Embed(source='com/arakaron/Assets/Database/allies.xml', mimeType="application/octet-stream")]
			private static const Ally:Class;
		[Embed(source='com/arakaron/Assets/Database/armors.xml', mimeType="application/octet-stream")]
			private static const ArmorList:Class;
		[Embed(source='com/arakaron/Assets/Database/weapons.xml', mimeType="application/octet-stream")]
			private static const WeaponList:Class;
		
		public static var Allies:Array = new Array();
		public static var Gear:Object = new Object();
		private static var Armors:Array = new Array();
		private static var Weapons:Array = new Array();
		
		public static var loadArray:Array = new Array();
		private static var loadVal:int;
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public function dbManager(){
		}
		
		public static function setDBLoad ():void {
			loadArray.push(new Array("Armors", new XML(new ArmorList)));
			loadArray.push(new Array("Weapons", new XML(new WeaponList)));
			loadArray.push(new Array("Allies", new XML(new Ally)));
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
			var xmlFile:XML = value[1]
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