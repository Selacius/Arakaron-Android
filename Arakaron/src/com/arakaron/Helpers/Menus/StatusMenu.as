package com.arakaron.Helpers.Menus{
	import com.arakaron.Arakaron;
	import com.arakaron.Game_Party;
	import com.arakaron.Player;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	import com.arakaron.GUI.*
	
	public class StatusMenu extends Sprite implements MenuGUI{
		private var gui:MenuBox;
		private var statIcon:BitmapData;
		
		public var membID:int;
		public var char:Player;
		
		private var ids:Array = new Array(
									{name:"Strength",val:"Str"},
									{name:"Agility", val:"Agi"},
									{name:"Dexterity",val:"Dex"},
									{name:"Vitality", val:"Vit"},
									{name:"Spirit",val:"Spr"},
									{name:"Wisdom",val:"Wisdom"},
									{name:"Attack",val:"Atk"},
									{name:"Atk %",val:"AtkP"},
									{name:"Def (P/M)",val:"Def"},
									{name:"Def % (P/M)",val:"DefP"});
		private var statTxt:Array;		
		
		private var gear:Array = new Array(
									{slot:"A",name:"Helm", x:115, y:0},
									{slot:"A",name:"Chest", x:115, y:50},
									{slot:"A",name:"Gloves",x:65,y:25},
									{slot:"A",name:"Gloves",x:165,y:25},
									{slot:"A",name:"Gloves",x:65,y:75},
									{slot:"A",name:"Gloves",x:165,y:75},
									{slot:"A",name:"Boots", x:115, y:100},
									{slot:"W",name:"MHand",x:65,y:125},
									{slot:"A",name:"Boots", x:165, y:125});
		
		private  var gearIcon:Array;
		
		private var charDisplay:CharDisplay;
		private var lftBTN:Sprite;
		private var rgtBTN:Sprite;
		
		private var gearBTN:getTextButton;
		private var immuneBTN:getTextButton;
		private var goalBTN:getTextButton;
		
		private var gearFrame:Sprite;
		private var immuneFrame:Sprite;
		private var goalFrame:Sprite;
		
		private var immuneTxt:TxtFields;
		private var goalTxt:TxtFields;
		
		private var toolTip:ToolTip;
		
		public function StatusMenu(){
			super();
			
			this.visible = false;
		}
		
		public function onAddedToStage():void{
			this.visible = true;
			this.char = Game_Party.members(this.membID);
			
			drawGUI();
			this.x = (Arakaron.StageWidth - this.width)/2;
			this.y = (Arakaron.StageHeight - this.height)/2;
		}
		
		public function drawGUI():void{
			this.statIcon = com.arakaron.AssetManager.GetImage("menu").bitmapData;
			
			this.gui = new MenuBox(0,0,500, 523, 0.5)
			this.addChild(this.gui);			
			this.gui.exitBtn.addEventListener(MouseEvent.CLICK,onExitClick);
			
			this.charDisplay = new CharDisplay(membID,false, true);
			this.charDisplay.x = 35;
			this.charDisplay.y = 30;
			this.addChild(this.charDisplay);
			this.charDisplay.onAddedToStage();
			this.charDisplay.reDrawVals();
			
			if (Game_Party.active_party().length > 1) {
				this.lftBTN = new Sprite();
				var lftBTNBitmap:Bitmap = new Bitmap(new BitmapData(24,24,true,0x00000000));
				lftBTNBitmap.bitmapData.copyPixels(this.statIcon,new Rectangle(6*24,4*24,24,24), new Point(0,0));
				this.lftBTN.addChild(lftBTNBitmap);
				this.lftBTN.y = 91;
				this.lftBTN.x = 10;
				this.addChild(this.lftBTN);
				
				this.lftBTN.addEventListener(MouseEvent.CLICK,onLftClick);
				
				this.rgtBTN = new Sprite();
				var rgtBTNBitmap:Bitmap = new Bitmap(new BitmapData(24,24,true,0x00000000));
				rgtBTNBitmap.bitmapData.copyPixels(this.statIcon,new Rectangle(6*24,5*24,24,24), new Point(0,0));
				this.rgtBTN.addChild(rgtBTNBitmap);
				this.rgtBTN.y = 91;
				this.rgtBTN.x = 489;
				this.addChild(this.rgtBTN);
				
				this.rgtBTN.addEventListener(MouseEvent.CLICK,onRgtClick);
			}
			
			var horiz:DrawLine = new DrawLine((this.gui.width - 20), "horiz");
			horiz.y = this.charDisplay.y + this.charDisplay.height + 5;
			horiz.x = (this.gui.width - horiz.width)/2;
			this.addChild(horiz);
			
			var i:int;
			this.statTxt = new Array();
			for each(var val:Object in this.ids) {
				var txtfld1:TxtFields = new TxtFields("Menu",120,28,false,true);
				this.statTxt[i] = new TxtFields("Menu-right",80,28,false,true);
				if (i <= 5) {
					txtfld1.y = 28 * i + 190;
					this.statTxt[i].y = 28 * i + 190;
				} else if (i == 6) {
					txtfld1.y = 28 * i + 200;
					this.statTxt[i].y = 28 * i + 200;
				}else {
					txtfld1.y = 28 * i + 200;
					this.statTxt[i].y = 28 * i + 200;
				}
				txtfld1.x = 15;
				this.statTxt[i].x = 135;
				this.statTxt[i].defaultTextFormat.align = "right";
				
				if (val.val == "Atk") {
					this.statTxt[i].text = this.char[val.val](null);
				} else if (val.val == "Def") {
					this.statTxt[i].text = this.char["Def"]("Physical")+"/"+this.char["Def"]("Magic");
				}else if (val.val == "DefP") {
					this.statTxt[i].text = this.char["DefP"]("Physical")+"/"+this.char["DefP"]("Magic");
				}else {
					this.statTxt[i].text = this.char[val.val];
				}
				txtfld1.text = val.name+":";
				this.addChild(txtfld1);
				this.addChild(this.statTxt[i]);
				i++;
			}
			
			var verti:DrawLine = new DrawLine(300, "vert");
			verti.y = 186;
			verti.x = 232;
			this.addChild(verti);
			
			this.gearBTN = new getTextButton("Gear","medium");
			this.gearBTN.y = 190;
			this.gearBTN.x = 248;
			this.addChild(this.gearBTN);
			this.gearBTN.addEventListener(MouseEvent.CLICK, onBTNClick);
			
			this.gearFrame = new Sprite();
			this.gearFrame.x = 235;
			this.gearFrame.y = 225;
			this.addChild(this.gearFrame);
			
			i = 0;
			this.gearIcon = new Array();
			for each(val in this.gear) {
				this.gearIcon[i] = new IconBox(i,val.x, val.y);
				this.gearIcon[i].addIcon(char.gear.displayGearIcon(val.slot, val.name));
				this.gearFrame.addChild(this.gearIcon[i]);
				this.gearIcon[i].addEventListener(MouseEvent.CLICK, onMouseClick);
				i++;
			}
			
			this.toolTip = new ToolTip();
			this.gearFrame.addChild(this.toolTip);
			
			this.immuneBTN = new getTextButton("Immunity","medium");
			this.immuneBTN.y = 190;
			this.immuneBTN.x = 322;
			this.addChild(this.immuneBTN);
			this.immuneBTN.addEventListener(MouseEvent.CLICK, onBTNClick);
			
			this.immuneFrame = new Sprite();
			this.immuneFrame.x = 235;
			this.immuneFrame.y = 225;
			this.immuneFrame.visible = false;
			this.addChild(this.immuneFrame);
			
			this.immuneTxt = new TxtFields("RegText",275,250,true,true);
			this.immuneFrame.addChild(this.immuneTxt);
			
			this.goalBTN = new getTextButton("Goals","medium");
			this.goalBTN.y = 190;
			this.goalBTN.x = 431;
			this.addChild(this.goalBTN);
			this.goalBTN.addEventListener(MouseEvent.CLICK, onBTNClick);
			
			this.goalFrame = new Sprite();
			this.goalFrame.x = 235;
			this.goalFrame.y = 225;
			this.goalFrame.visible = false;
			this.addChild(this.goalFrame);
			
			this.goalTxt = new TxtFields("RegText", 275,250,true, true);
			this.goalFrame.addChild(this.goalTxt);
			
			this.goalTxt.text = "This is where the players goals/achievements can be found. \nTo be deployed in a future version.";
			this.immuneTxt.text = "This is where the players immunities/resistances can be found. \nTo be deployed in a future version.";
		}
		
		public function onMouseClick(e:MouseEvent):void {
			this.toolTip.clearGearTip();
			this.toolTip.visible = true;
			this.toolTip.updateGearTip(char.gear.getGearInfo(this.gear[e.target.ibID]) ,null);
			this.toolTip.x = (e.target.x - this.toolTip.width - 8);
			this.toolTip.y = (e.target.y);
		}
		
		private function onBTNClick(e:MouseEvent):void {
			if (e.currentTarget === this.gearBTN){
				trace ("Gear");
				this.gearFrame.visible = true;
				this.immuneFrame.visible = false;
				this.goalFrame.visible = false;
				this.toolTip.visible = false;
			}else if (e.currentTarget === this.goalBTN) {
				trace ("Goal");
				this.gearFrame.visible = false;
				this.immuneFrame.visible = false;
				this.goalFrame.visible = true;
				this.toolTip.visible = false;
			} else {
				trace ("immune");
				this.gearFrame.visible = false;
				this.immuneFrame.visible = true;
				this.goalFrame.visible = false;
				this.toolTip.visible = false;
			}
		}
		
		private function reDrawVals():void {
			this.char = Game_Party.members(this.membID);
			
			var i:int
			for each(var val:Object in this.ids) {
				if (val.val == "Atk") {
					this.statTxt[i].text = this.char[val.val](null);
				} else if (val.val == "Def") {
					this.statTxt[i].text = this.char["Def"]("Physical")+"/"+this.char["Def"]("Magic");
				}else if (val.val == "DefP") {
					this.statTxt[i].text = this.char["DefP"]("Physical")+"/"+this.char["DefP"]("Magic");
				}else {
					this.statTxt[i].text = this.char[val.val];
				}
				i++;
			}
			
			i = 0;
			for each(val in this.gear) {
				this.gearIcon[i].clearIcon();
				this.gearIcon[i].addIcon(char.gear.displayGearIcon(val.slot, val.name));
				i++;
			}
			this.charDisplay.charID = this.membID;
			this.charDisplay.reset();
			this.charDisplay.reDrawVals();
			
			this.toolTip.visible = false;
			
			this.goalTxt.text = "This is where the players goals/achievements can be found. \To be deployed in a future version.";
			this.immuneTxt.text = "This is where the players immunities/resistances can be found. \To be deployed in a future version.";
		}
		
		public function onExitClick(e:MouseEvent):void{
			this.onRemovedFromStage();
		}
		
		public function onRemovedFromStage():void{
			this.visible = false;
			
			for (var i:int=0; i<this.gearIcon.length; i++) {
				this.gearIcon[i].clearIcon();	
				this.gearIcon[i].borderBitmap.bitmapData.dispose();
				this.gearIcon[i].removeEventListener(MouseEvent.CLICK, onMouseClick);
				
				this.gearFrame.removeChild(this.gearIcon[i]);
				this.gearIcon[i] = null;
			}
			
			this.removeChildren(0,this.numChildren-1);
			
			this.statTxt = null;
			this.gearIcon = null;
			
			this.gui.exitBtn.removeEventListener(MouseEvent.CLICK,onExitClick);
			this.gui = null;
			
			this.lftBTN = null;
			this.rgtBTN = null;
			
			this.charDisplay = null;
			
			this.goalBTN = null;
			this.goalFrame.removeChild(this.goalTxt);
			this.goalFrame = null;
			this.goalTxt = null;
			this.gearBTN = null;
			this.gearFrame = null;
			this.immuneBTN = null;
			this.immuneFrame.removeChild(this.immuneTxt);
			this.immuneFrame = null;
			
			this.toolTip = null;
			
			Arakaron.mainMenu.onAddedToStage();
		}
		
		public function onLftClick(e:MouseEvent):void {
			this.membID--;
			if (this.membID < 0) {
				this.membID = Game_Party.size() - 1;
			}			
			this.reDrawVals();
		}
		
		public function onRgtClick(e:MouseEvent):void {
			this.membID++;
			if (this.membID > Game_Party.size() - 1) {
				this.membID = 0;
			}
			this.reDrawVals();
		}
	}
}