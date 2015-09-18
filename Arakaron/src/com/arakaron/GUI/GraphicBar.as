package com.arakaron.GUI{
	import com.arakaron.AssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GraphicBar extends Sprite{
		private var barText:TxtFields;
		private var barType:String;
		private var barTypeText:TxtFields;
		private var barFill:Bitmap;
		private var barBorder:Bitmap;
		
		private var tileSet:BitmapData;
		
		public function GraphicBar(bartype:String, x:int, y:int){
			super();
			
			this.x = x;
			this.y = y;
			
			this.barType = bartype;
		}
		
		public function onAddedToStage():void {
			loadGUI();
		}
		
		public function clear():void {
			this.barFill.bitmapData.dispose();
		}
		
		public function reDrawVals(minVal:int, maxVal:int):void {
			this.tileSet = com.arakaron.AssetManager.GetImage("menu").bitmapData;
			
			this.barTypeText.text = this.barType+":";
			
			this.barText.text = minVal+"/"+maxVal;
			
			var y:int;
			switch (this.barType) {
				case "HP":
					y = 8;
					break;
				case "MP":
					y = 9;
					break;
				case "XP":
					y = 10;
					break;
			}
			var perc:int = Math.round(144 * (minVal/maxVal));
			this.barFill.bitmapData = new BitmapData(144,24,true,0x00000000);
			this.barFill.bitmapData.copyPixels(this.tileSet,new Rectangle(0,y*24,perc,24), new Point(0,0));
			this.barFill.scaleX = 1.333;
			this.barFill.scaleY = 1.5;
			
			this.tileSet.dispose();
			this.tileSet = null;
		}
		
		public function loadGUI():void {			
			this.barTypeText = new TxtFields("RegText",40,25,false, false);
			this.barTypeText.y = 5;
			this.addChild(this.barTypeText);
			
			this.tileSet = com.arakaron.AssetManager.GetImage("menu").bitmapData;
			
			this.barFill = new Bitmap(new BitmapData(144,24,true,0x00000000));
			this.barFill.x = 45;
			this.addChild(this.barFill);

			this.barBorder = new Bitmap(new BitmapData(144,24)); 
			this.barBorder.bitmapData.copyPixels(this.tileSet,new Rectangle(0,6*24,144,24), new Point(0,0))
			this.barBorder.x = 45;
			this.barBorder.scaleX = 1.333;
			this.barBorder.scaleY = 1.5;
			this.addChild(this.barBorder);
			
			this.barText = new TxtFields("RegText",175,25,false, false);
			this.barText.x = 52;
			this.barText.y = 5;
			this.addChild(this.barText);
		}
	}
}