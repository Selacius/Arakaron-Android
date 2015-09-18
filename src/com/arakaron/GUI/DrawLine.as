package com.arakaron.GUI{
	import com.arakaron.AssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.*;
	
	public class DrawLine extends Sprite{
		private var tileSet:BitmapData;
		private var lineBitmap:Bitmap;
		private var midBitmap:Bitmap;
		
		private var numTiles:int;
		
		public function DrawLine(width:int, orient:String){
			super();
			
			this.numTiles = Math.round(width/16 - 1.5);
			
			this.tileSet = com.arakaron.AssetManager.GetImage("window").bitmapData;
			
			this.lineBitmap = new Bitmap(new BitmapData(width,16,true,0x00000000));
			this.lineBitmap.bitmapData.copyPixels(this.tileSet,new Rectangle(0,48,16,16), new Point(0,0));
			this.lineBitmap.bitmapData.copyPixels(this.tileSet,new Rectangle(32,48,16,16), new Point(width-17,0));
			
			this.midBitmap = new Bitmap(new BitmapData(16,16,true,0x00000000));
			this.midBitmap.bitmapData.copyPixels(this.tileSet,new Rectangle(16,48,16,16), new Point(0,0));
			this.midBitmap.scaleX = (width-32)/16;
			
			this.addChild(this.lineBitmap);
			this.addChild(this.midBitmap);
			
			if (orient == "vert") {
				this.lineBitmap.rotation = 90;
				this.midBitmap.rotation = 90;
				this.midBitmap.y = 16;
			} else {
				this.midBitmap.x = 16;
			}
			
			this.tileSet.dispose();
			this.tileSet = null;
		}
	}
}