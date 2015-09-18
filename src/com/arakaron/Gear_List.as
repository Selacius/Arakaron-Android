package com.arakaron  {
	import com.arakaron.Helpers.Gear.Armor;
	import com.arakaron.Helpers.Gear.Gear;
	import com.arakaron.Helpers.Gear.Jewelry;
	import com.arakaron.Helpers.Gear.Weapon;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Gear_List {
		public var A:Object;
		public var W:Object;
		
		public var J:Array;
		
		public function Gear_List() {
			this.A = new Object();
				this.A.Helm = null;
				this.A.Chest = null;
				this.A.Gloves = null;
				this.A.Boots = null;
			this.W = new Array();
				this.W.MHand = null;
				this.W.OHand = null;
			this.J = new Array();
				this.J.Neck = null;
				this.J.Ring1 = null;
				this.J.Ring2 = null;
		}
		
		public function add_gear(id:String):void {
			var slot:String = id.split("|")[0];
			var itmID:int = int(id.split("|")[1]);
			if (itmID != -1) {	
				var itm:*;
				switch (slot) {
					case "A":
						itm = dbManager.Gear.A[itmID];
						this.A[itm.iSlot] = itm;
						break;
					case "W":
						itm = dbManager.Gear.W[itmID];
						this.W[itm.iSlot] = itm;
						break;
					case "J":
						itm = dbManager.Gear.J[itmID];
						this.J[itm.iSlot] = itm;
						break;
				}
			}
		}
		
		public function  getGearInfo(gear:Object):Object {
			if (this[gear.slot][gear.name] == undefined) {
				return ("");
			} else {
				return (this[gear.slot][gear.name]);
			}
		}
		
		public function displayGearIcon(slot:String,id:String):Bitmap {
			if (this[slot][id] == undefined) {
				return (new Bitmap(new BitmapData(24,24,true,0x00000000)));
			} else {
				return (this[slot][id].displayIcon());
			}
		}
		
		public function displayGear(slot:String,id:String, val:String):String {
			if (this[slot][id] == undefined) {
				return ("");
			} else {
				return (this[slot][id][val]);
			}
			
		}
		
		public function unEquipGear(char:Player, item:Object):void {
			if (item as Armor) {
				Game_Inventory.addInvent("A|"+item.iID,1,false);
				this.A[item.iSlot] = null;
				sqlManager.insertSQL("characters",char);
			}
		}
		
		public function equipGear (char:Player, item:Object):void {
			if (item as Armor) {
				if (this.A[item.iSlot]) {
					trace ("I have an item already");
					Game_Inventory.addInvent("A|"+this.A[item.iSlot].iID,1,false);
					Game_Inventory.removeItem("A|"+item.iID,1,false);
				}
				this.A[item.iSlot] = item;	
			} else if (item as Weapon) {
				if (this.W[item.iSlot]) {
					Game_Inventory.addInvent("W|"+this.W[item.iSlot].iID,1,false);
					Game_Inventory.removeItem("W|"+item.iID,1,false);
				}
				this.W[item.iSlot] = item;
			}
			sqlManager.insertSQL("characters",char);
		}
		
		public function getStat(stat:Object):int {
			var _stat:int;
			for each (var itm:Armor in this.A) {
				if (itm != null) {
					if (stat is Array) {
						_stat += int(itm[stat[0]][stat[1]]);
					} else {
						_stat += int(itm[stat]);
					}
				}
			}
			for each (var itm2:Weapon in this.W) {
				if (itm2 != null) {
					if (stat is Array) {
						_stat += int(itm2[stat[0]][stat[1]]);
					} else {
						_stat += int(itm2[stat]);
					}
				}
			}
			for each (var itm3:Jewelry in this.J) {
				if (itm3 != null) {
					if (stat is Array) {
						_stat += int(itm3[stat[0]][stat[1]]);
					} else {
						_stat += int(itm3[stat]);
					}
				}
			}
			return (_stat);
		}
	
	}
	
}
