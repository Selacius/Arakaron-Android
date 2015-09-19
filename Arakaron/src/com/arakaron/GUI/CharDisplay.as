package com.arakaron.GUI{
	import com.arakaron.AssetManager;
	import com.arakaron.Game_Party;
	import com.arakaron.Player;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CharDisplay extends Sprite{
		public var charID:int;
		private var char:Player
		
		private var cGraphic:Bitmap;
		private var cName:TxtFields;
		private var cLvl:TxtFields;
		private var cHPBar:GraphicBar;
		private var cMPBar:GraphicBar;
		private var xpBar:Boolean;
		private var cXPBar:GraphicBar;
		
		private var startX:int;
		
		private var menuIcons:Boolean;
		private var statIcon:BitmapData;
		
		public var statusIcon:Sprite;
		public var gearIcon:Sprite;
		public var skillIcon:Sprite;
		public var talentIcon:Sprite;
		
		public function CharDisplay(charID:int, iconDisplay:Boolean, xpBar:Boolean){
			super();
			this.charID = charID;
			this.menuIcons = iconDisplay;
			this.xpBar = xpBar;
		}
		
		public function onAddedToStage():void {
			loadGUI();
		}
		
		public function reset():void {
			this.cGraphic.bitmapData.dispose();
			this.cHPBar.clear();
			this.cMPBar.clear();
		}
		
		public function reDrawVals():void {
			this.char = Game_Party.members(charID);
			
			this.char.avatar.loadFace();
			this.cGraphic.bitmapData = this.char.avatar.faceBitmap.bitmapData.clone();
			this.cName.text = this.char.alias;
			this.cLvl.text = "Level "+char.lvl.toString()+" "+char.caste.toString();
			
			this.cHPBar.reDrawVals(char.HPMin, char.HPMax);			
			this.cMPBar.reDrawVals(char.MPMin, char.MPMax);
						
			this.cGraphic.y = 10;
			if (this.xpBar) {
				this.cXPBar.reDrawVals(char.xp, char.xpn);
				this.cGraphic.y = (this.height - this.cGraphic.height)/2;
			}
		}
		
		public function addXPBar():void {
			this.cXPBar = new GraphicBar("XP", (100 + this.startX), 106);
			this.addChild(this.cXPBar);
			
			this.cXPBar.onAddedToStage();
		}
		
		public function loadGUI():void {
			this.statIcon = com.arakaron.AssetManager.GetImage("status").bitmapData;
			
			if (this.menuIcons) {
				this.startX = 66;
				
				this.statusIcon = new Sprite();
				var statusBitmap:Bitmap = new Bitmap(new BitmapData(30,30,true,0x00000000));
				statusBitmap.bitmapData.copyPixels(this.statIcon,new Rectangle(30,0,30,30), new Point(0,0));
				this.statusIcon.addChild(statusBitmap);
				this.statusIcon.y = 20;
				this.addChild(this.statusIcon);
				
				this.gearIcon = new Sprite();
				var gearBitmap:Bitmap = new Bitmap(new BitmapData(30,30,true,0x00000000));
				gearBitmap.bitmapData.copyPixels(this.statIcon,new Rectangle(0,0,30,30), new Point(0,0));
				this.gearIcon.addChild(gearBitmap);
				this.gearIcon.y = 66;
				this.addChild(this.gearIcon);
				
				this.skillIcon = new Sprite();
				var skillBitmap:Bitmap = new Bitmap(new BitmapData(30,30,true,0x00000000));
				skillBitmap.bitmapData.copyPixels(this.statIcon,new Rectangle(120,0,30,30), new Point(0,0));
				this.skillIcon.addChild(skillBitmap);
				this.skillIcon.y = 5;
				this.skillIcon.x = 30;
				this.addChild(this.skillIcon);
				
				this.talentIcon = new Sprite();
				var talentBitmap:Bitmap = new Bitmap(new BitmapData(30,30,true,0x00000000));
				talentBitmap.bitmapData.copyPixels(this.statIcon,new Rectangle(60,0,30,30), new Point(0,0));
				this.talentIcon.addChild(talentBitmap);
				this.talentIcon.y = 49;
				this.talentIcon.x = 30;
				this.addChild(this.talentIcon);
			}
			
			this.statIcon.dispose();
			this.statIcon = null;
			
			this.cGraphic = new Bitmap();
			this.cGraphic.x = this.startX;
			this.addChild(this.cGraphic);
			
			this.cName = new TxtFields("DisplayName",150,25,false, false);
			this.cName.x = 100 + this.startX;
			this.cName.y = 4;
			this.addChild(this.cName);
			
			this.cLvl = new TxtFields("DisplayName",150,25,false, false);
			this.cLvl.x = 250 + this.startX;
			this.cLvl.y = 4;
			this.addChild(this.cLvl);
			
			this.cHPBar = new GraphicBar("HP", (100 + this.startX), 32);
			this.addChild(this.cHPBar);
			this.cHPBar.onAddedToStage();
			
			this.cMPBar = new GraphicBar("MP", (100 + this.startX), 70);
			this.addChild(this.cMPBar);
			this.cMPBar.onAddedToStage();
			
			if (this.xpBar) {
				this.addXPBar();
			}
		}
	}
}