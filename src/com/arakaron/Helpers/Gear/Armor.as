package com.arakaron.Helpers.Gear{
	import com.arakaron.AssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Armor extends Sprite implements Gear{
		public var alias:String;
		public var caste:String;
		public var iID:int;
		
		public var iLvl:int;
		public var iRarity:String;
		public var iMaterial:String;
		public var iSlot:String;
		public var iLogo:int;
		
		public var iAtk:int = 0;
		public var iAtkP:int = 0;
		public var iDef:int;
		public var iDefP:int;		
		public var imDef:int;
		public var imDefP:int;
		
		public var iDesc:String;
		public var iCost:int;
		
		public var iStats:Object = new Object();
		public var iOnHit:Object = new Object();
		
		public var canvasBitmap:Bitmap;
		public var tileSet:BitmapData;
		
		public function Armor(xmldoc:XML){
			super();
			
			this.alias = xmldoc.name;
			this.caste = xmldoc.caste;
			
			this.iID = xmldoc.@id;
			
			this.iMaterial = xmldoc.style;
			this.iRarity = xmldoc.rarity;
			this.iSlot = xmldoc.slot;
			
			this.iLvl = xmldoc.lvl;
			this.iLogo = xmldoc.logo;
			
			this.iDef = xmldoc.def;
			this.iDefP = xmldoc.defp;
			this.imDef = xmldoc.mdef;
			this.imDefP = xmldoc.mdefp;
			
			if (xmldoc.atk) {
				this.iAtk = xmldoc.atk;
			}
			if (xmldoc.atkp) {
				this.iAtkP = xmldoc.atkp;
			}
			
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