package com.arakaron{

	public class Game_Inventory{
		
		public static var Invent:Object;
		
		public function Game_Inventory(){
		}
		
		public static function init():void {
			Invent = new Object();
				Invent.I = new Array();
				Invent.A = new Array();
				Invent.W = new Array();
				Invent.J = new Array();
		}
		
		public static function loadInvent(id:String, num:int):void {
			var iType:String = id.split("|")[0];
			var itmID:int = int(id.split("|")[1]);
			Invent[iType][itmID] = num;
		}
		
		public static function addInvent(id:String, num:int, newItem:Boolean):void {
			var iType:String = id.split("|")[0];
			var itmID:int = int(id.split("|")[1]);
		
			if (Invent[iType][itmID] > 0) {
				Invent[iType][itmID] = Invent[iType][itmID] + num;
			} else {
				Invent[iType][itmID] = 0 + num;
			}
			if (newItem) {
				Arakaron.AlertWindow.updateWin("Received "+num+"x of "+itmID+".", false);
			}
			com.arakaron.sqlManager.insertSQL("inventory",{index:iType+"|"+itmID,quan:Invent[iType][itmID]});
		}
		
		public static function removeItem(id:String, num:int, newItem:Boolean):void {
			var iType:String = id.split("|")[0];
			var itmID:int = int(id.split("|")[1]);
			
			if (Invent[iType][itmID]  > 0) {
				Invent[iType][itmID]  = Invent[iType][itmID]  - num;
			} else {
				Invent[iType][itmID]  = 0;
			}
			com.arakaron.sqlManager.insertSQL("inventory",{index:iType+"|"+itmID,quan:Invent[iType][itmID]});
		}
		
		public static function checkInvent(id:String):Boolean {
			var iType:String = id.split("|")[0];
			var itmID:int = int(id.split("|")[1]);
			
			if (Invent[iType][itmID]) {
				return (true);
			} else {
				return (false);
			}
		}
		
		public static function displayItem(id:int){
			return Invent[id];
		}
		
		public static function listInvent(list:String):Object {
			var listArray:Object = new Object();
			if (list == "All") {				
				//listArray;
			} else if (list == "Gear") {				
				listArray.A = Invent.A;
				listArray.W = Invent.W;
				listArray.J = Invent.J;
			} else {
				for (var ind:Object in Invent) {
					if (ind.charAt(0) == list) {
						listArray.push(new Array(ind, Invent[ind]));
					}
				}
			}
			return (listArray);
		}
	}
}