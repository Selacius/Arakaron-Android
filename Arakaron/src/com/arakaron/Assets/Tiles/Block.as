package com.arakaron.Assets.Tiles{
	import com.arakaron.Arakaron;
	import com.arakaron.Game_Party;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Block extends Sprite implements Tile {
		public var caste:String;
		
		private var intWidth:int;
		private var intHeight:int;
		
		public var baseCollide:Boolean;
		public var blockID:String;
		private var trigType:String;
		public var trigVal:int;
		public var Blocked:Boolean;
		
		private var touched:Boolean;
		
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		public var Interact:Boolean;
		
		public function Block(mapName:String, xmldoc:XML){
			super();
			this.x = xmldoc.@x;
			this.y = xmldoc.@y - 32;
			
			this.intHeight = xmldoc.@height;
			this.intWidth = xmldoc.@width;
			
			this.baseCollide = Boolean(int(xmldoc.properties.property[0].@value));
			this.Blocked = this.baseCollide;
			this.trigType = xmldoc.properties.property[1].@value;
			this.trigVal = int(xmldoc.properties.property[2].@value);
			
			this.blockID = mapName+"|"+xmldoc.@x+"|"+xmldoc.@y;
			
			this.caste = "Block";
			this.Interact = true;
			
			xmldoc = null;
			
			this.ImmoveHitArea = new Sprite();
			this.InteractHitArea = new Sprite();
		}
		
		public function onAddedtoStage():void {
			this.ImmoveHitArea.graphics.beginFill(0,1);
			this.addChild(this.ImmoveHitArea);
			
			this.InteractHitArea.graphics.beginFill(0,0);
			this.addChild(this.InteractHitArea);
			
			drawTile();
		}
		
		private function drawTile() :void {
			if (this.Blocked) {
				this.ImmoveHitArea.graphics.drawRect(0,0,this.intWidth,this.intHeight);
			} else {
				this.ImmoveHitArea.graphics.drawRect(0,0,0,0);
			}
			this.ImmoveHitArea.graphics.endFill();
			
			this.InteractHitArea.graphics.drawRect(-2,-2,this.intWidth+4,this.intHeight+4);
			this.InteractHitArea.graphics.endFill();
		}
		
		public function onRemovedFromStage():void {
			this.ImmoveHitArea.graphics.clear();
			this.removeChild(this.ImmoveHitArea);
			
			this.removeChild(this.InteractHitArea);
			this.InteractHitArea.graphics.clear();
			
			this.ImmoveHitArea = null;
			this.InteractHitArea = null;
		}
		
		public function onInteract():void {
		}
		
		public function onTouch():void {
			if (this.Blocked && !this.touched) {
				Arakaron.AlertWindow.updateWin("Something appears to be blocking your way.", true);
				this.touched = true;
				
				var timer:Timer = new Timer(5000)
				timer.addEventListener(TimerEvent.TIMER, reSet); 
				timer.start();
			}
		}
		
		private function reSet(e:TimerEvent):void {
			this.touched = false;
		}
		
		public function checkSwitches():void {
			switch (this.trigType) {
				case "lvl":
					if (com.arakaron.Game_Party.avg_lvl("single") >= this.trigVal) {
						this.Blocked != this.Blocked;
					}
					break;
				case "item":
					if (com.arakaron.Game_Inventory.checkInvent("I|"+this.trigVal)) {
						this.Blocked = !this.Blocked;
						com.arakaron.Game_Inventory.removeItem("I|"+this.trigVal,1, false);
					}
					break;
				case "event":
					if (Arakaron.GameEvents[this.blockID] != undefined) {
						if (Arakaron.GameEvents[this.blockID][0] == this.trigVal) {
							this.Blocked = !this.Blocked;
						}
					}
				break;
			}
			drawTile();
		}
	}
}