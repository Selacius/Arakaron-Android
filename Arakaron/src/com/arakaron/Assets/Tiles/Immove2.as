package com.arakaron.Assets.Tiles{
	import flash.display.Sprite;
	
	public class Immove2 extends Sprite implements Tile{
		public var caste:String;
		
		private var intWidth:int;
		private var intHeight:int;
		
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		public var Interact:Boolean;
		
		public function Immove2(x:int, y:int, width:int, height:int){
			super();
			
			this.x = x;
			this.y = y;
			
			this.intHeight = height;
			this.intWidth = width;
			
			this.caste = "Immove";
			this.Interact = false;
		}
		
		public function onAddedtoStage():void {
			this.ImmoveHitArea = new Sprite();
			this.InteractHitArea = new Sprite();
			
			this.ImmoveHitArea.graphics.beginFill(0,0);
			this.ImmoveHitArea.graphics.drawRect(0,0,this.intWidth,this.intHeight);
			this.ImmoveHitArea.graphics.endFill();
			this.addChild(this.ImmoveHitArea);
			
			this.InteractHitArea.graphics.beginFill(0,0);
			this.InteractHitArea.graphics.drawRect(0,0,0,0);
			this.InteractHitArea.graphics.endFill();
			this.addChild(this.InteractHitArea);
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
			
		}
	}
}