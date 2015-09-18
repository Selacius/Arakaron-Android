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
	
	public class Door extends Sprite implements Tile{
		public var caste:String;
		
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		public var Interact:Boolean;
		
		private var tileset:BitmapData;
		private var canvasBitmap:Bitmap;
		
		private var doorID:String;
		private var openFrame:int = 7;
		private var startFrame:int;
		private var currFrame:int;
		private var canOpen:Boolean;
		private var isOpened:Boolean = false;
		private var keyID:int;
		private var isLocked:Boolean;
		
		public function Door(mapName:String, xmldoc:XML){
			super();
			
			this.caste = "Door";
			this.Interact = true;
			this.doorID = mapName+"|"+xmldoc.@x+"|"+xmldoc.@y;
			
			this.x = xmldoc.@x;
			this.y = xmldoc.@y - 16;
			
			this.canOpen = Boolean(String(xmldoc.properties.property[0].@value));
			this.startFrame = int(xmldoc.properties.property[1].@value);
			this.isLocked = Boolean(String(xmldoc.properties.property[2].@value));
			this.keyID = xmldoc.properties.property[3].@value;
			
			xmldoc = null;
			
			this.ImmoveHitArea = new Sprite();
			this.InteractHitArea = new Sprite();
			
			this.canvasBitmap = new Bitmap(new BitmapData(32,32,true,0x00000000));
		}
		
		public function onAddedtoStage():void{
			this.addChild(this.ImmoveHitArea);
			
			this.InteractHitArea.graphics.beginFill(0,0);
			this.InteractHitArea.graphics.drawRect(-6,-6,44,44);
			this.InteractHitArea.graphics.endFill();
			this.addChild(this.InteractHitArea);
			
			this.addChild(this.canvasBitmap);
			
			checkSwitches();
		}
		
		public function onRemovedFromStage():void{
			this.canvasBitmap.bitmapData.dispose();
			this.removeChild(this.canvasBitmap);
			
			this.ImmoveHitArea.graphics.clear();
			this.removeChild(this.ImmoveHitArea);
			
			this.removeChild(this.InteractHitArea);
			this.InteractHitArea.graphics.clear();
			
			this.ImmoveHitArea = null;
			this.InteractHitArea = null;
		}
		
		public function checkSwitches():void {
			if (!isOpened) {
				this.currFrame = this.startFrame;
			} else {
				this.currFrame = this.openFrame;
			}
			
			this.ImmoveHitArea.graphics.clear();
			this.ImmoveHitArea.graphics.beginFill(0,1);
			if (this.isOpened) {
				this.ImmoveHitArea.graphics.drawRect(0,0,0,0);
			} else {
				this.ImmoveHitArea.graphics.drawRect(0,0,32,32);
			}
			this.ImmoveHitArea.graphics.endFill();
			
			drawTile();
		}
		
		public function drawTile():void {
			this.tileset = TileAssetManager.GetImage("doors").bitmapData;
			
			var rect:Rectangle = new Rectangle(this.currFrame*32,0,32,32);
			this.canvasBitmap.bitmapData = new BitmapData(32,32,true,0x00000000);
			this.canvasBitmap.bitmapData.copyPixels(this.tileset,rect, new Point(0,0));
			
			this.tileset.dispose();
			this.tileset = null	
		}
		
		public function onInteract():void{
			if (this.canOpen) {
				if (this.isOpened) {
					trace ("Closed");
					this.isOpened = false;
				} else if (!this.isLocked) {
					trace ("Opened");
					this.isOpened = true;
				} 
			}
			checkSwitches();
		}
		
		public function onTouch():void{
		}
	}
}