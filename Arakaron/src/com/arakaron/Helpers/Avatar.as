package com.arakaron.Helpers{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InterpolationMethod;
	import flash.display.Sprite;
	import flash.geom.*;
	import com.arakaron.AssetManager;
	
	public class Avatar extends Sprite {
		
		public var faceBitmap:Bitmap;
		public var tileBitmap:Bitmap;
		
		private var index:int;
		private var indexx:int;
		private var indexy:int;
		
		public var border:Boolean;
		
		private var tileset:BitmapData;
		private var faceset:BitmapData;
		
		private var animCount:int;
		private var animIndex:int;
		
		
		public function Avatar(id:int){
			super();
						
			this.index = id;
			if (this.index > 3) {
				this.indexx = this.index - 4;
				this.indexy = 1;
			} else {
				this.indexx = this.index;
				this.indexy = 0;
			}
		}
		
		public function loadFace():void {
			this.faceset = AssetManager.GetImage("actor1_face").bitmapData;
			
			this.faceBitmap = new Bitmap(new BitmapData(96,96,true,0x00000000));
			var rect:Rectangle = new Rectangle(0,0,96,96);
			
			rect.x = (this.indexx * 96);
			rect.y = (this.indexy * 96);
			
			this.faceBitmap.bitmapData.copyPixels(this.faceset,rect, new Point(0,0));
			
			this.faceset.dispose();
			this.faceset = null
		}
		
		public function add_face():void {
			this.loadFace();
			this.addChild(this.faceBitmap);
		}
		
		public function face_border():void {
			this.graphics.lineStyle(2, 0x0000FF);
			this.graphics.drawRect(-2, -2, this.width+4, this.height+4);
			this.graphics.endFill();
			
			this.border = true;
		}
		
		public function clear_border():void {
			this.graphics.clear();
			this.border = false;
		}
		
		public function add_tile():void {
			this.tileset = AssetManager.GetImage("actor1").bitmapData;
			
			this.tileBitmap = new Bitmap(new BitmapData(32,32,true,0x00000000));			
			
			this.addChild(this.tileBitmap);
			
			var rect:Rectangle = new Rectangle(0,0,32,32);
			
			rect.x = (this.indexx * 96);
			rect.y = (this.indexy * 128);
			this.tileBitmap.bitmapData.copyPixels(this.tileset,rect, new Point(0,0));
		}
		
		public function move_tile(direc:int, movem:Boolean):void {
			var rect:Rectangle = new Rectangle(0,0,32,32);	
			//this.tileset = AssetManager.GetImage("actor1").bitmapData;
			if (movem) {
				if (animCount == 6) {
					animIndex++;
					animCount = 0;
					if (animIndex == 3){
						animIndex = 0;
					}
				}else{
					animCount++;
				}
				
				rect.x = (this.indexx * 96) + int((animIndex % 3))*32;
				rect.y = (this.indexy * 128) + int(direc * 32);
				this.tileBitmap.bitmapData.copyPixels(tileset,rect, new Point(0,0));
			}
			else {
				rect.x = (this.indexx * 96) + int((0 % 3))*32;
				rect.y = (this.indexy * 128) + int(direc * 32);
				this.tileBitmap.bitmapData.copyPixels(tileset,rect, new Point(0,0));
			}
		}
	}
}