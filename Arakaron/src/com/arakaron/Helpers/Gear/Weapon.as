package com.arakaron.Helpers.Gear{
	import com.arakaron.AssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Weapon extends Sprite implements Gear{
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
		
		public var iStats:Object = new Object();
		public var iOnHit:Object = new Object();
		
		public var canvasBitmap:Bitmap;
		public var tileSet:BitmapData;
		
		public function Weapon(xmldoc:XML){
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
			this.iAtkP = xmldoc.atkp;
			
			if (xmldoc.def) {
				this.iDef = xmldoc.def;
			}
			if (xmldoc.defp) {
				this.iDefP = xmldoc.defp;
			}
			
			for(var val in xmldoc.stats.effect) {
				this.iStats[xmldoc.stats.effect[val].@val] = xmldoc.stats.effect[val]
			}
			
			if (xmldoc.on_hit != "") {
				this.iOnHit.id = xmldoc.on_hit;
				this.iOnHit.perc = xmldoc.on_hit.@perc;
				this.iOnHit.lvl = xmldoc.on_hit.@lvl;
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