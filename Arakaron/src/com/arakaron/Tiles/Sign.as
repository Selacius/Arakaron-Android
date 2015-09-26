package com.arakaron.Tiles{
	import com.arakaron.Arakaron;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Sign extends Sprite implements Tile{
		public var caste:String;
		
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		public var Interact:Boolean;
		
		private var tileset:BitmapData;
		private var canvasBitmap:Bitmap;
		
		private var frame:int;
		private var msgText:String;
		
		public function Sign(xmldoc:XML){
			super();
			
			this.caste = "Sign";
			this.Interact = true;
			
			this.x = xmldoc.@x;
			this.y = xmldoc.@y - 16;
			
			this.frame = xmldoc.properties.property[0].@value;
			this.msgText = xmldoc.properties.property[1].@value;
			
			xmldoc = null;
			
			this.ImmoveHitArea = new Sprite();
			this.InteractHitArea = new Sprite();
			
			this.canvasBitmap = new Bitmap(new BitmapData(32,32,true,0x00000000));
		}
		
		public function onAddedtoStage():void{
			this.ImmoveHitArea.graphics.beginFill(0,0);
			this.ImmoveHitArea.graphics.drawRect(0,0,32,32);
			this.ImmoveHitArea.graphics.endFill();
			this.addChild(this.ImmoveHitArea);
			
			this.InteractHitArea.graphics.beginFill(0,0);
			this.InteractHitArea.graphics.drawRect(-6,-6,44,44);
			this.InteractHitArea.graphics.endFill();
			this.addChild(this.InteractHitArea);
			
			this.tileset = TileAssetManager.GetImage("signs").bitmapData;
			
			this.addChild(this.canvasBitmap);
			
			var rect:Rectangle = new Rectangle(this.frame*32,0,32,32);
			
			this.canvasBitmap.bitmapData.copyPixels(this.tileset,rect, new Point(0,0));
			
			this.tileset.dispose();
			this.tileset = null
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
		
		public function onInteract():void{
			Arakaron.AlertWindow.updateWin(this.msgText, true);
		}
		
		public function onTouch():void	{
		}
		
		public function checkSwitches():void {
		}
	}
}