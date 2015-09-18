package com.arakaron.GUI
{
	import com.arakaron.Arakaron;
	import com.arakaron.AssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class IconBox extends Sprite{
		public var borderBitmap:Bitmap;
		
		public var ibID:int;
		public var windowTile:BitmapData;
		
		private var StageWidth:int;
		private var CeilWidth:int;
		private var StageHeight:int;
		private var CeilHeight:int;
		
		private var srcX:int, srcY:int, destX:int, destY:int;
		
		public function IconBox(id:int, x:int, y:int){
			super();
			
			this.ibID = id;
			
			this.x = x;
			this.y = y;
			
			this.StageHeight = 44;
			this.CeilHeight = Math.ceil(this.StageHeight/16) * 16;
			this.StageWidth = 44;
			this.CeilWidth = Math.ceil(this.StageWidth/16) * 16;
			
			this.windowTile = com.arakaron.AssetManager.GetImage("window").bitmapData;
			
			this.borderBitmap = new Bitmap(new BitmapData(this.CeilWidth,this.CeilHeight));
			
			var xCeil:int = Math.ceil(this.StageWidth/16);
			var yCeil:int = Math.ceil(this.StageHeight/16);
			
			for (var x:int = 0; x < xCeil ; x++) {
				for (var y:int = 0; y < yCeil; y++) {
						destX = x*16;
						destY = y*16;
						srcX = 5;
						srcY = 1;
						if (y == 0) {
							srcX = 5;
							srcY = 0;
						}else if (y == Math.ceil(this.StageHeight/16 - 1)) {
							srcX = 5;
							srcY = 3;
						}
						if (x == 0 && y == 0) {
							srcX = 4;
							srcY = 0;
						} else if (x == 0 && y == Math.ceil(this.StageHeight/16 - 1)) {
							srcX = 4;
							srcY = 3;
						} else if (x == 0) {
							srcX = 4;
							srcY = 1;
						}
						if (x == Math.ceil(this.StageWidth/16 - 1) && y == 0) {
							srcX = 7;
							srcY = 0;
						} else if (x == Math.ceil(this.StageWidth/16 - 1) && y == Math.ceil(this.StageHeight/16 - 1)) {
							srcX = 7;
							srcY = 3;
						} else if (x == Math.ceil(this.StageWidth/16 - 1)) {
							srcX = 7;
							srcY = 1;
						}
						this.borderBitmap.bitmapData.copyPixels(this.windowTile,new Rectangle(srcX * 16,srcY * 16,16,16), new Point(destX,destY));
				}
			}
			
			this.windowTile.dispose();
			this.windowTile = null;
			
			this.borderBitmap.scaleX = this.StageWidth/this.CeilWidth; 
			this.borderBitmap.scaleY = this.StageHeight/this.CeilHeight; 
			
			this.addChild(this.borderBitmap);
		}
		
		public function addIcon(icon:Bitmap):void {
			this.addChild(icon);
			icon.x = 5;
			icon.y = 6;
		}
		
		public function clearIcon():void {
			if (this.numChildren > 1) {
				this.removeChildAt(1);
			}
		}
	}
}