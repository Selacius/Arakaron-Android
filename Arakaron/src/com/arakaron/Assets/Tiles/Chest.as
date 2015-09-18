package com.arakaron.Assets.Tiles{
	import com.arakaron.Arakaron;
	import com.arakaron.Game_Inventory;
	import com.arakaron.LoadMap2;
	import com.arakaron.sqlManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Chest extends Sprite implements Tile{
		public var caste:String;
		
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		public var Interact:Boolean;
		
		private var tileset:BitmapData;
		private var canvasBitmap:Bitmap;
		
		private var switch1:int;
		private var switch2:int;
		
		private var chestID:String;
		
		public var key:int;
		public var locked:Boolean;
		public var empty:Boolean;
		public var items:Array;
		
		private var openedframe:int;
		
		public function Chest(mapName:String, xmldoc:XML){
			super();
			
			this.caste = "Chest";
			this.Interact = true;
			this.chestID = mapName+"|"+xmldoc.@x+"|"+xmldoc.@y;
			
			this.x = xmldoc.@x;
			this.y = xmldoc.@y - 16;
			
			if (xmldoc.@type == "locked") {
				this.locked = true;
			}
			
			this.key = xmldoc.properties.property[5].@value;

			this.openedframe = int(xmldoc.properties.property[1].@value) + 4;
		
			this.items = new Array();
			for (var i:int = 2; i < 5; i++) {
				var itm:Array = String(xmldoc.properties.property[i].@value).split("||");
				if (itm[0] != 0) {
					this.items.push(itm);	
				}
			}
			
			if (this.items == null) {
				this.empty = true;
			}
			
			xmldoc = null;
			
			this.ImmoveHitArea = new Sprite();
			this.InteractHitArea = new Sprite();
			
			this.canvasBitmap = new Bitmap(new BitmapData(32,32,true,0x00000000));
		}
			
		public function onAddedtoStage ():void {
			this.ImmoveHitArea.graphics.beginFill(0,0);
			this.ImmoveHitArea.graphics.drawRect(0,0,32,32);
			this.ImmoveHitArea.graphics.endFill();
			this.addChild(this.ImmoveHitArea);
			
			this.InteractHitArea.graphics.beginFill(0,0);
			this.InteractHitArea.graphics.drawRect(-6,-6,44,44);
			this.InteractHitArea.graphics.endFill();
			this.addChild(this.InteractHitArea);
			
			checkSwitches();
		}
		
		private function displayTile():void {
			this.tileset = TileAssetManager.GetImage("chests").bitmapData;
			
			this.addChild(this.canvasBitmap);
			
			var rect:Rectangle = new Rectangle((this.openedframe - (4 * (1 - this.switch1)))*32,0,32,32);
			
			this.canvasBitmap.bitmapData.copyPixels(this.tileset,rect, new Point(0,0));
			
			this.tileset.dispose();
			this.tileset = null	
		}
		
		public function checkSwitches():void {
			if (Arakaron.GameEvents[this.chestID] != undefined) {
				this.switch1 = Arakaron.GameEvents[this.chestID][0];
				this.switch2 = Arakaron.GameEvents[this.chestID][1];
				
				if (this.switch1 == 1) {
					this.empty = true;
				} else if (this.switch1 == 0) {
					this.empty = false;
				}
				if (this.switch2 == 1) {
					this.locked = false;
				} else if (this.switch2 == 0) {
					this.locked = true;
				}
			}
			
			this.displayTile();
		}
		
		public function onRemovedFromStage():void {
			this.canvasBitmap.bitmapData.dispose();
			this.removeChild(this.canvasBitmap);
			
			this.ImmoveHitArea.graphics.clear();
			this.removeChild(this.ImmoveHitArea);
			
			this.removeChild(this.InteractHitArea);
			this.InteractHitArea.graphics.clear();
			
			this.ImmoveHitArea = null;
			this.InteractHitArea = null;
		}
		
		public function onInteract():void {
			if (!this.empty) {
				if (this.locked) {
					if (com.arakaron.Game_Inventory.checkInvent("i"+this.key)) {
						giveItem();
						com.arakaron.Game_Inventory.removeItem("i"+this.key,1, false);
						this.locked = false;
						Arakaron.AlertWindow.updateWin("Used "+this.key+" to unlock the chest.", false);
						sqlManager.insertSQL("events",{event_id:this.chestID,switch1:"1",switch2:"1"});
					} else {
						Arakaron.AlertWindow.updateWin("Unfortunately you don't have the proper key.", true);
						trace ("You don't have the necessary key.");
					}
				} else {
					giveItem();
					sqlManager.insertSQL("events",{event_id:this.chestID,switch1:"1",switch2:"1"});
				}
			} else {
				Arakaron.AlertWindow.updateWin("Chest no longer contains anything.", true);
				trace ("I got nothing anymore");
			}
		}
		
		public function giveItem():void {
			trace ("They Are Trying to Steal Mah Treasures");
			
			for each (var itm:Array in this.items) {
				if (itm[0] == "Gold") {
					Arakaron.AlertWindow.updateWin("Received "+itm[1]+" Gold.", false);
				} else {
					com.arakaron.Game_Inventory.addInvent(itm[0],itm[1],true);
				}
			}
			
			this.tileset = TileAssetManager.GetImage("chests").bitmapData;
			var rect:Rectangle = new Rectangle(this.openedframe*32,0,32,32);
			this.canvasBitmap.bitmapData.copyPixels(this.tileset,rect, new Point(0,0));
			
			this.tileset.dispose();
			
			this.empty = true;
		}
		
		public function onTouch():void {
		}
		
	}
}