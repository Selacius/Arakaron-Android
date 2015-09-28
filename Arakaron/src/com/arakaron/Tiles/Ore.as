package com.arakaron.Tiles{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.arakaron.Arakaron;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Ore extends Sprite implements Tile{
		public var caste:String;
		
		public var ImmoveHitArea:Sprite;
		public var InteractHitArea:Sprite;
		public var Interact:Boolean;
		
		private var tileset:BitmapData;
		private var canvasBitmap:Bitmap;
		
		public var currQuan:int;
		private var maxQuan:int;
		private var frame:int;
		private var yFrame:int;
		public var oreType:String;
		
		private var anim:Animation;
		
		public function Ore(tileObs:Object){
			super();
			
			this.x = tileObs.tileX;
			this.y = tileObs.tileY - 16;
			
			this.caste = "Ore";
			this.Interact = true;
			
			this.frame = tileObs.tileFrame;
			this.maxQuan = tileObs.tileVal1e;
			this.currQuan = this.maxQuan;		
			this.oreType = tileObs.tileType;
			
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
			
			this.addChild(this.canvasBitmap);

			var obs:Object = {tileX:0, tileY:0, tileFrame:6, tileType:"small"}

			this.anim = new Animation(obs);
			this.addChild(this.anim);
			this.anim.onAddedtoStage();
			
			displayTile();
		}
		
		public function onRemovedFromStage():void{
			this.canvasBitmap.bitmapData.dispose();
			this.removeChild(this.canvasBitmap);
			
			this.removeChild(this.anim);
			this.anim = null;
			
			this.ImmoveHitArea.graphics.clear();
			this.removeChild(this.ImmoveHitArea);
			
			this.removeChild(this.InteractHitArea);
			this.InteractHitArea.graphics.clear();
			
			this.ImmoveHitArea = null;
			this.InteractHitArea = null;
		}
		
		private function displayTile():void {
			if (this.currQuan >= (this.maxQuan * 0.75)) {
				this.yFrame = 0;
			} else if (this.currQuan >= (this.maxQuan * 0.4)) {
				this.yFrame = 32;
			} else {
				this.yFrame = 64;
			}
			
			this.tileset = TileAssetManager.GetImage("ores").bitmapData;
			
			var rect:Rectangle = new Rectangle(this.frame*32,this.yFrame,32,32);
			
			this.canvasBitmap.bitmapData.copyPixels(this.tileset,rect, new Point(0,0));
			
			this.tileset.dispose();
			this.tileset = null;	
		}
		
		public function onInteract():void{
			if (this.currQuan > 0) {
				this.currQuan--;
				com.arakaron.Game_Inventory.addInvent("I|"+oreType,1, true);
				this.displayTile();
				if (this.currQuan == 0) {
					this.removeChild(this.anim);
					var myTimer:Timer = new Timer(300000, 1); // 5 Minutes
					myTimer.addEventListener(TimerEvent.TIMER, runOnce);
					myTimer.start();
				}
			}else {
				Arakaron.AlertWindow.updateWin("There seems to be no more ore available.",true);
			}
		}
		
		public function runOnce():void {
			this.currQuan = this.maxQuan;
			this.addChild(this.anim);
			this.displayTile();
		}
		
		public function onTouch():void{
		}
		
		public function onEnterFrame(e:int):void {
			this.anim.onEnterFrame(null);
		}
		
		public function checkSwitches():void {
		}
	}
}