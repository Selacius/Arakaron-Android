package com.arakaron.Assets.Tiles{
	import com.arakaron.Arakaron;
	import com.arakaron.LoadMap2;
	import com.arakaron.sqlManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Switch extends Sprite implements Tile{
		private var hostMap:LoadMap2;
		
		public var caste:String;
		
		private var baseFrame:int;
		
		private var reset:String;
		
		public var trigger:String;
		private var triggered:Boolean;
		private var trigID:String;
		private var trigIDval1:int;
		private var trigIDval2:int;
		private var trigMulti:Boolean;
		public var active:Boolean;
		
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		public var Interact:Boolean;
		
		private var tileset:BitmapData;
		private var canvasBitmap:Bitmap;
		
		public function Switch(ref_map:LoadMap2, xmldoc:XML){
			super();
			
			this.hostMap = ref_map;
			
			this.caste = "Switch";
			this.Interact = true;
			
			this.x = xmldoc.@x;
			this.y = xmldoc.@y - 16;
			
			this.baseFrame = xmldoc.properties.property[0].@value;
			this.trigMulti = Boolean(String(xmldoc.properties.property[1].@value));
			this.reset = String(xmldoc.properties.property[2].@value);
			
			this.trigger = xmldoc.properties.property[4].@value;
			this.trigID = xmldoc.properties.property[5].@value;
			this.trigIDval1 = int(String(xmldoc.properties.property[3].@value).split("|")[0]);
			this.trigIDval2 = int(String(xmldoc.properties.property[3].@value).split("|")[1]);
			
			xmldoc = null;
			
			this.ImmoveHitArea = new Sprite();
			this.InteractHitArea = new Sprite();
			
			this.canvasBitmap = new Bitmap(new BitmapData(32,32,true,0x00000000));
		}
		
		public function onAddedtoStage():void{
			this.ImmoveHitArea.graphics.beginFill(0,0);
			if (this.trigger == "Action") {
				this.ImmoveHitArea.graphics.drawRect(0,0,32,32);
			}else {
				this.ImmoveHitArea.graphics.drawRect(0,0,0,0);
			}
			this.ImmoveHitArea.graphics.endFill();
			this.addChild(this.ImmoveHitArea);
			
			this.InteractHitArea.graphics.beginFill(0,0);
			this.InteractHitArea.graphics.drawRect(-3,-3,38,38);
			this.InteractHitArea.graphics.endFill();
			this.addChild(this.InteractHitArea);
			
			this.tileset = TileAssetManager.GetImage("chests").bitmapData;
			
			this.addChild(this.canvasBitmap);
			
			var rect:Rectangle = new Rectangle(this.baseFrame*32,0,32,32);
			
			this.canvasBitmap.bitmapData.copyPixels(this.tileset,rect, new Point(0,0));
			
			this.tileset.dispose();
			this.tileset = null			
		}
		
		public function onRemovedFromStage():void{
			if (this.reset) {
				this.triggered = false;
				Arakaron.GameEvents[this.trigID] = [0,0];
			}
			this.canvasBitmap.bitmapData.dispose();
			this.removeChild(this.canvasBitmap);
			
			this.ImmoveHitArea.graphics.clear();
			this.removeChild(this.ImmoveHitArea);
			
			this.removeChild(this.InteractHitArea);
			this.InteractHitArea.graphics.clear();
			
			this.ImmoveHitArea = null;
			this.InteractHitArea = null;
		}
		
		public function onInteract():void{
			if (this.trigger == "Action") {
				if (!this.triggered || this.trigMulti) {
					trace ("It's Action Time");
					triggerSwitch();
				}
			}
		}
		
		public function onTouch():void{
			if (this.trigger == "Touch") {
				if (!this.triggered || this.trigMulti) {
					trace ("It's Touching Time");
					triggerSwitch();
				}
			}
		}

		private function triggerSwitch():void {
			if (Arakaron.GameEvents[this.trigID] == undefined) {
				Arakaron.GameEvents[this.trigID] = [this.trigIDval1, this.trigIDval2];
				this.triggered = true;
			} else {
				if (this.triggered && this.trigMulti) {
					Arakaron.GameEvents[this.trigID][0] -= this.trigIDval1;
					Arakaron.GameEvents[this.trigID][1] -= this.trigIDval2;
					this.triggered = !this.triggered;
				}else {
					Arakaron.GameEvents[this.trigID][0] += this.trigIDval1;
					Arakaron.GameEvents[this.trigID][1] += this.trigIDval2;
					this.triggered = true;
				}
			}
			
			if (this.reset == "persist") {
				sqlManager.insertSQL("events",{event_id:this.trigID,switch1:this.trigIDval1,switch2:this.trigIDval2});
			}
			this.hostMap.triggerEvents();
		}
		
		public function checkSwitches():void {
		}
	}
}