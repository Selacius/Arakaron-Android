package com.arakaron.GUI
{
	import com.arakaron.Arakaron;
	import com.arakaron.AssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class WindowBox extends Sprite{
		public var Layer1Bitmap:Bitmap;
		public var Layer2Bitmap:Bitmap;
		public var Layer3Bitmap:Bitmap;
		
		public var windowTile:BitmapData;
		
		private var StageWidth:int;
		private var CeilWidth:int;
		private var StageHeight:int;
		private var CeilHeight:int;
		
		private var srcX:int, srcY:int, destX:int, destY:int;
		
		public function WindowBox(x:int, y:int, height:int, width:int, alpha:Number){
			super();
			
			this.x = x;
			this.y = y;
			
			this.StageHeight = height;
			this.CeilHeight = Math.ceil(this.StageHeight/16) * 16;
			this.StageWidth = width;
			this.CeilWidth = Math.ceil(this.StageWidth/16) * 16;
			
			this.windowTile = com.arakaron.AssetManager.GetImage("window").bitmapData;
			
			this.Layer1Bitmap = new Bitmap(new BitmapData(this.CeilWidth,this.CeilHeight));
			this.Layer2Bitmap = new Bitmap(new BitmapData(this.CeilWidth,this.CeilHeight));
			this.Layer3Bitmap = new Bitmap(new BitmapData(this.CeilWidth,this.CeilHeight));
			
			var xCeil:int = Math.ceil(this.StageWidth/16);
			var yCeil:int = Math.ceil(this.StageHeight/16);
			
			for (var i:int = 1; i < 4; i++) {
				for (var x:int = 0; x < xCeil ; x++) {
					for (var y:int = 0; y < yCeil; y++) {
						switch (i) {
							case 1:
								destX = x*16;
								destY = y*16;
								this.Layer1Bitmap.bitmapData.copyPixels(this.windowTile,new Rectangle(0,0,16,16), new Point(destX,destY));
								break;
							case 2:
								destX = x*16;
								destY = y*16;
								srcX = x % 4;
								srcY = y % 4 + 4;
								this.Layer2Bitmap.bitmapData.copyPixels(this.windowTile,new Rectangle(srcX * 16,srcY * 16,16,16), new Point(destX,destY));
								break;
							case 3:
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
								this.Layer3Bitmap.bitmapData.copyPixels(this.windowTile,new Rectangle(srcX * 16,srcY * 16,16,16), new Point(destX,destY));
								break;
						}
					}
				}
			}
			
			this.windowTile.dispose();
			this.windowTile = null;

			this.Layer1Bitmap.scaleX = this.StageWidth/this.CeilWidth; 
			this.Layer1Bitmap.scaleY = this.StageHeight/this.CeilHeight;
			this.Layer1Bitmap.alpha = alpha;
			
			this.Layer2Bitmap.scaleX = this.StageWidth/this.CeilWidth; 
			this.Layer2Bitmap.scaleY = this.StageHeight/this.CeilHeight;
			
			this.Layer3Bitmap.scaleX = this.StageWidth/this.CeilWidth; 
			this.Layer3Bitmap.scaleY = this.StageHeight/this.CeilHeight; 
			
			this.addChild(this.Layer1Bitmap);
			this.addChild(this.Layer2Bitmap);
			this.addChild(this.Layer3Bitmap);
		}
	}
}