package com.arakaron.GUI
{
	import com.arakaron.Arakaron;
	import com.arakaron.AssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MenuBox extends Sprite{
		public var baseBitmap:Bitmap;
		public var borderBitmap:Bitmap;
		public var exitBitmap:Bitmap;
		public var exitBtn:Sprite;
		
		public var windowTile:BitmapData;
		
		private var StageWidth:int;
		private var CeilWidth:int;
		private var StageHeight:int;
		private var CeilHeight:int;
		
		private var srcX:int, srcY:int, destX:int, destY:int;
		
		public function MenuBox(x:int, y:int, height:int, width:int, alpha:Number){
			super();
			
			this.x = x;
			this.y = y;
			
			this.StageHeight = height;
			this.CeilHeight = Math.ceil(this.StageHeight/42) * 42;
			this.StageWidth = width;
			this.CeilWidth = Math.ceil(this.StageWidth/42) * 42;
			
			this.windowTile = com.arakaron.AssetManager.GetImage("menu").bitmapData;
			
			this.baseBitmap = new Bitmap(new BitmapData(this.CeilWidth,this.CeilHeight));
			this.borderBitmap = new Bitmap(new BitmapData(this.CeilWidth,this.CeilHeight));
			this.exitBitmap = new Bitmap(new BitmapData(16,16));
			this.exitBtn = new Sprite();
			
			var xCeil:int = Math.ceil(this.StageWidth/42);
			var yCeil:int = Math.ceil(this.StageHeight/42);
			
			for (var i:int = 1; i < 3; i++) {
				for (var x:int = 0; x < xCeil ; x++) {
					for (var y:int = 0; y < yCeil; y++) {
						switch (i) {
							case 1:
								if (x == Math.ceil(this.StageWidth/42 - 1) && y == 0) {
									srcX = 1;
									srcY = 1;
								} else {
									srcX = 1;
									srcY = 1;
								}
								destX = x*42;
								destY = y*42;
								this.baseBitmap.bitmapData.copyPixels(this.windowTile,new Rectangle(srcX * 42,srcY * 42,42,42), new Point(destX,destY));
								break;
							case 2:
								destX = x*42;
								destY = y*42;
								srcX = 3;
								srcY = 1;
								if (y == 0) {
									srcX = 1;
									srcY = 0;
								}else if (y == Math.ceil(this.StageHeight/42 - 1)) {
									srcX = 1;
									srcY = 2;
								}
								if (x == 0 && y == 0) {
									srcX = 0;
									srcY = 0;
								} else if (x == 0 && y == Math.ceil(this.StageHeight/42 - 1)) {
									srcX = 0;
									srcY = 2;
								} else if (x == 0) {
									srcX = 0;
									srcY = 1;
								}
								if (x == Math.ceil(this.StageWidth/42 - 1) && y == 0) {
									srcX = 2;
									srcY = 0;
								} else if (x == Math.ceil(this.StageWidth/42 - 1) && y == Math.ceil(this.StageHeight/42 - 1)) {
									srcX = 2;
									srcY = 2;
								} else if (x == Math.ceil(this.StageWidth/42 - 1)) {
									srcX = 2;
									srcY = 1;
								}
								this.borderBitmap.bitmapData.copyPixels(this.windowTile,new Rectangle(srcX * 42,srcY * 42,42,42), new Point(destX,destY));
								break;
						}
					}
				}
			}
			
			this.exitBitmap.bitmapData.copyPixels(this.windowTile,new Rectangle(9*16,0,16,16), new Point(0,0));
			this.exitBtn.addChild(this.exitBitmap);
			
			this.exitBtn.y = 13;
			this.exitBtn.x = this.StageWidth - 28;
			
			this.windowTile.dispose();
			this.windowTile = null;

			this.baseBitmap.scaleX = this.StageWidth/this.CeilWidth; 
			this.baseBitmap.scaleY = this.StageHeight/this.CeilHeight;
			
			this.borderBitmap.scaleX = this.StageWidth/this.CeilWidth; 
			this.borderBitmap.scaleY = this.StageHeight/this.CeilHeight;
			
			this.exitBitmap.scaleX = this.StageWidth/this.CeilWidth;
			this.exitBitmap.scaleY = this.StageHeight/this.CeilHeight;
			
			this.addChild(this.baseBitmap);
			this.addChild(this.borderBitmap);
			this.addChild(this.exitBtn);
		}
	}
}