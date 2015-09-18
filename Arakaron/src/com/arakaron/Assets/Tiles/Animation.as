package com.arakaron.Assets.Tiles{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Animation extends Sprite implements Tile{
		
		public var caste:String;
		private var size:String;
		private var frame:int;
		private var tileHeight:int;
		
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		public var Interact:Boolean;
		
		private var tileset:BitmapData;
		private var canvasBitmap:Bitmap;
		
		private var animIndex:int;
		private var animCount:int;
		public var rect:Rectangle;
		
		public function Animation(xint:int, yint:int, frame:int, type:String){
			super();
			
			this.x = xint;
			this.y = yint - 16;
			
			this.caste = "Animation";
			this.Interact = false;
			
			this.size = type;
			this.frame = frame;
			
			switch (this.size) {
				case "small":
					this.tileHeight = 32;
					break;
				case "medium":
					this.tileHeight = 46;
					break;
				case "large":
					this.tileHeight = 56;
					break;
			}
			
			this.ImmoveHitArea = new Sprite();
			this.InteractHitArea = new Sprite();
			
			this.canvasBitmap = new Bitmap(new BitmapData(32,this.tileHeight,true,0x00000000));
		}
		
		public function onAddedtoStage():void{
			this.ImmoveHitArea.graphics.beginFill(0,0);
			this.ImmoveHitArea.graphics.drawRect(0,0,32,this.tileHeight);
			this.ImmoveHitArea.graphics.endFill();
			this.addChild(this.ImmoveHitArea);
			
			this.InteractHitArea.graphics.beginFill(0,0);
			this.InteractHitArea.graphics.drawRect(10,10,10,10);
			this.InteractHitArea.graphics.endFill();
			this.addChild(this.InteractHitArea);
			
			this.addChild(this.canvasBitmap);
			
			this.rect = new Rectangle(0,0,32,this.tileHeight);
			
			this.tileset = TileAssetManager.GetImage(this.size+"Animation").bitmapData;
			
			drawPlay();
		}
		
		public function onEnterFrame (e:Event):void {
			if (this.animIndex == 7) {
				this.drawPlay();
				this.animIndex = 0;
			} else {
				this.animIndex++;
			}
		}
		
		public function drawPlay():void {
			if (this.animCount == 2) {
				this.animCount = 0;
			}else{
				this.animCount++;
			}

			rect.x = int(frame)*32;
			rect.y = int(animCount * this.tileHeight);
			canvasBitmap.bitmapData.copyPixels(tileset,rect, new Point(0,0));
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
			
			this.tileset.dispose();
			this.tileset = null;
		}
		
		public function onInteract():void{
		}
		
		public function onTouch():void{
		}
	}
}