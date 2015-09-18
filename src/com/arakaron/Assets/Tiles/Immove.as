package com.arakaron.Assets.Tiles{
	import flash.display.Sprite;
	
	public class Immove extends Sprite implements Tile{
		public var caste:String;
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		
		public function Immove(x:int, y:int){
			super();
			this.x = x;
			this.y = y;
			
			this.caste = "Immove";
		}
		
		public function onAddedtoStage():void {
			this.ImmoveHitArea = new Sprite();
			this.InteractHitArea = new Sprite();
			
			this.ImmoveHitArea.graphics.beginFill(0,1);
			this.ImmoveHitArea.graphics.drawRect(0,0,16,16);
			this.ImmoveHitArea.graphics.endFill();
			this.addChild(this.ImmoveHitArea);
			
			this.InteractHitArea.graphics.beginFill(0,0);
			this.InteractHitArea.graphics.drawRect(2,2,12,12);
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