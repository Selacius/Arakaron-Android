package com.arakaron.GUI{
	import com.arakaron.AssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.TextField;
	
	public class getTextButton extends Sprite{
		public var txt:TextField;
		
		private var btnBack:Bitmap;
		private var btnMid:Bitmap;
		private var btnHeight:int;
		private var btnWidth:int;
		
		private var windowTile:BitmapData;
		
		public function getTextButton(text:String, size:String){
			super();
			
			this.txt = new TxtFields("Button-"+size,10,10, false, false);
			this.txt.text = text;
			this.txt.x = 8;
			this.txt.y = 1;
			
			this.btnHeight = this.txt.height + 2;
			this.btnWidth = this.txt.width + 16;
			this.windowTile = com.arakaron.AssetManager.GetImage("window").bitmapData;
			
			this.btnBack = new Bitmap(new BitmapData(this.btnWidth, 33));
			this.btnBack.bitmapData.copyPixels(this.windowTile,new Rectangle(0,0,16,33), new Point(0,0));
			this.btnBack.bitmapData.copyPixels(this.windowTile,new Rectangle(32,0,16,33), new Point(this.btnWidth-16,0));
			this.btnBack.scaleY = this.btnHeight/33;
			
			this.btnMid = new Bitmap(new BitmapData(16,33));
			this.btnMid.bitmapData.copyPixels(this.windowTile,new Rectangle(16,0,16,33), new Point(0,0));
			this.btnMid.x = 15;
			this.btnMid.scaleX = (this.btnWidth - 30)/16;
			this.btnMid.scaleY = this.btnHeight/33;
			
			this.addChild(this.btnBack);
			this.addChild(this.btnMid);
			this.addChild(this.txt);
			
			this.useHandCursor = true;
			this.buttonMode = true;
			this.mouseChildren = false;
			
			this.windowTile.dispose();
			this.windowTile = null;
		}
	}
}