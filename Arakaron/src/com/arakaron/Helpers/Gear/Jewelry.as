package com.arakaron.Helpers.Gear{
	import com.arakaron.AssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Jewelry extends Sprite implements Gear{
		public var alias:String;		
		public var iID:int;
		
		public var iLvl:int;
		public var iRarity:String;
		public var iStyle:String;
		public var iType:String;
		public var iSlot:String;
		public var iLogo:int;
		
		public var iAtk:int;
		public var iAtkP:int;
		public var iDef:int = 0;
		public var iDefP:int = 0;		
		public var imDef:int = 0;
		public var imDefP:int = 0;
		
		public var iDesc:String;
		public var iCost:int;
		
		public var iBuffs:Object;
		public var iStats:Object;
		
		public var canvasBitmap:Bitmap;
		public var tileSet:BitmapData;
		
		public function Jewelry(xmldoc:XML){
			super();
			
			this.alias = xmldoc.name;
			this.iID = xmldoc.@id;
			
			this.iStyle = xmldoc.style;
			this.iRarity = xmldoc.rarity;
			this.iType = xmldoc.type;
			this.iSlot = xmldoc.slot;
			
			this.iLvl = xmldoc.lvl;
			this.iLogo = xmldoc.logo;
			
			this.iAtk = xmldoc.atk;
			this.iAtkP = xmldoc.atk;
			this.iDef = xmldoc.def;
			this.iDefP = xmldoc.defp;
			this.imDef = xmldoc.mdef;
			this.imDefP = xmldoc.mdefp;
			
			this.iDesc = xmldoc.desc;
			this.iCost = xmldoc.cost;
			
			xmldoc = null;
		}
		
		public function displayIcon():Bitmap {
			this.tileSet = com.arakaron.AssetManager.GetImage("armors").bitmapData;
			
			var y:int = int(this.iLogo/16);
			var x:int = (this.iLogo - y * 16 - 1);
			
			this.canvasBitmap = new Bitmap(new BitmapData(24,24,true,0x00000000));
			this.canvasBitmap.bitmapData.copyPixels(this.tileSet, new Rectangle(x * 24,y * 24,24,24),new Point(0,0));
			this.canvasBitmap.scaleX = 1.333;
			this.canvasBitmap.scaleY = 1.333;
			
			this.tileSet.dispose();
			this.tileSet = null;
			
			return (this.canvasBitmap);
		}
		
		public function onHit():void{
		}
	}
}