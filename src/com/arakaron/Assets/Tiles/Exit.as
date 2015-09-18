package com.arakaron.Assets.Tiles{
	import com.arakaron.Arakaron;
	
	import flash.display.Sprite;
	
	public class Exit extends Sprite implements Tile{
		public var caste:String;
		
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		
		public var Interact:Boolean;
		
		private var intWidth:int;
		private var intHeight:int;
		
		public var map_id:String, map_x:int, map_y:int;
		
		public function Exit(xmldoc:XML){
			super();
			
			this.x = xmldoc.@x;
			this.y = xmldoc.@y;
			
			this.intWidth = xmldoc.@width;
			this.intHeight = xmldoc.@height;
			
			this.caste = "Exit";
			this.Interact = true;
			
			this.map_id = xmldoc.properties.property[0].@value;
			this.map_x = xmldoc.properties.property[1].@value;
			this.map_y = xmldoc.properties.property[2].@value;
			
			xmldoc = null;
			
			this.ImmoveHitArea = new Sprite();
			this.InteractHitArea = new Sprite();
		}
		
		public function onAddedtoStage():void{
			this.ImmoveHitArea.graphics.beginFill(0x0000FF,1);
			this.ImmoveHitArea.graphics.drawRect(0,0,intWidth,intHeight);
			this.ImmoveHitArea.graphics.endFill();
			this.addChild(this.ImmoveHitArea);
			
			this.InteractHitArea.graphics.beginFill(0,0);
			this.InteractHitArea.graphics.drawRect(0,0,intWidth,intHeight);
			this.InteractHitArea.graphics.endFill();
			this.addChild(this.InteractHitArea);
		}
		
		public function onRemovedFromStage():void{
			this.ImmoveHitArea.graphics.clear();
			this.removeChild(this.ImmoveHitArea);
			
			this.removeChild(this.InteractHitArea);
			this.InteractHitArea.graphics.clear();
			
			this.ImmoveHitArea = null;
			this.InteractHitArea = null;
		}
		
		public function onInteract():void{
		}
		
		public function onTouch():void{
		}
		
		public function checkSwitches():void {
		}
	}
}