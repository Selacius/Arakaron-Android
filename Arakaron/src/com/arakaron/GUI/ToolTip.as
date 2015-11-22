package com.arakaron.GUI{
	import com.arakaron.Helpers.Gear.*;
	import com.arakaron.Helpers.Menus.EquipMenu;
	import com.arakaron.Helpers.Menus.StatusMenu;
	
	import com.arakaron.GUI.textButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ToolTip extends Sprite{
		private var eqButton:textButton;
		
		private var heightMod:int;
		private var equip:String;
		
		private var gear:*
		
		private var rarity:Object = {Common:"#CCCCCC",Uncommon:"#26C426",Rare:"#2D2DE1",Epic:"#8C02CD"};
		
		private  var statComp:Array = new Array(
										{name:"iAtk",stat:"Atk"},
										{name:"iAtkP",stat:"Atk %"},
										{name:"iDef",stat:"Def"},
										{name:"iDefP",stat:"Def %"},
										{name:"imDef",stat:"Mag Defense"},
										{name:"imDefP",stat:"Mag Defense %"});
		
		private var bonusComp:Array = new Array(
										{name:"Strength",val:"Str"},
										{name:"Agility", val:"Agi"},
										{name:"Dexterity",val:"Dex"},
										{name:"Vitality", val:"Vit"},
										{name:"Spirit",val:"Spr"},
										{name:"Wisdom",val:"Wisdom"});
		
		public function ToolTip(){
			super();
			
			this.visible = false;
		}
		
		public function updateGearTip(gear:Object, equip:String):void {
			this.heightMod = 20;
			
			this.gear = gear;
			this.equip = equip;

			switch (equip) {
				case "equip":
					this.eqButton = new textButton(this,<text size="small">Equip</text>);
					this.eqButton.addEventListener(MouseEvent.CLICK, onMouseClick);
					heightMod += this.eqButton.height;
					break
				case "unequip":
					this.eqButton = new textButton(this,<text size="small">Unequip</text>);
					this.eqButton.addEventListener(MouseEvent.CLICK, onMouseClick);
					heightMod += this.eqButton.height;
					break
			}
			
			drawGUI(this);
			
			if (eqButton) {
				this.addChild(this.eqButton);
				this.eqButton.x = (this.width - this.eqButton.width)/2;
				this.eqButton.y = this.getChildAt(3).height + this.getChildAt(3).y
			}
			
			var myTimer:Timer = new Timer(2000, 1); // 2 Minutes
			myTimer.addEventListener(TimerEvent.TIMER, runOnce);
			myTimer.start();
		}
		
		private function drawGUI (guiCont:Sprite):void {			
			var tltipName:TxtFields = new TxtFields("ToolTip",200,28,false, false);
				tltipName.x = 6;
				tltipName.y = 6;
			
			var txt:String;
			
			txt = '<font color="'+this.rarity[gear.iRarity]+'" size ="19"><u>'+gear.alias+'</u></font>';
			if (gear is Armor) {
				txt += "\n "+gear.iSlot+"                "+gear.iMaterial;
				txt += "\n   "+gear.iDef+" Def ("+gear.iDefP+"%)";
				txt += "\n   "+gear.imDef+" Magic Def ("+gear.iDefP+"%)";
				if (gear.iAtk > 0) {
					txt += "\n   "+gear.iAtk+" Atk ("+gear.iAtkP+"%)";
				}
			} else if (gear is Weapon) {
				txt += "\n "+gear.iStyle+"            "+gear.iType;
				txt += "\n   "+gear.iAtk+" Atk ("+gear.iAtkP+"%)";
				if (gear.iDef > 0) {
					txt += "\n   "+gear.iDef+" Def ("+gear.iDefP+"%)";	
				} else if (gear.imDef > 0) {
					txt += "\n   "+gear.imDef+" Magic Def ("+gear.iDefP+"%)";
				}
			} else if (gear is Jewelry) {
				
			}
			
			for each (var val:Object in this.bonusComp) {
				if (gear["iStats"][val.val] != undefined) {
					txt += "\n +"+gear["iStats"][val.val]+" "+val.name;
				}
			}
			
			if (gear.iOnHit.id) {
				txt += "\n On-Hit: "+gear.iOnHit.id;
			}
			
			tltipName.htmlText = txt;
			
			var tltipDesc:TxtFields = new TxtFields("ToolTip2",tltipName.width-3,25, false, false);
				tltipDesc.x = 6;
				tltipDesc.y = tltipName.textHeight + 16;
				tltipDesc.text = gear.iDesc;
				tltipDesc.height = tltipDesc.textHeight + 4;
			
			heightMod += tltipName.height + tltipDesc.height;
			
			var gui:WindowBox = new WindowBox(0,0,heightMod,tltipName.width+14,1.0);
			guiCont.addChild(gui);
			guiCont.addChild(tltipName);
			
			
			var line:DrawLine = new DrawLine(gui.width-20,"horiz");
				line.x = (gui.width - line.width)/2
				line.y = tltipName.y + tltipName.height - 5;
			guiCont.addChild(line);
			
			guiCont.addChild(tltipDesc);
		}
		
		public function updateCompareGearTip(gear1:Object, gear2:Object):void {
			var gear1Cont:Sprite = new Sprite();
			if (gear1 != null) {
				this.gear = gear1;
				this.heightMod = 20;
				this.drawGUI(gear1Cont);
				this.addChild(gear1Cont);
			}
			
			this.gear = gear2;
			var gear2Cont:Sprite = new Sprite();
			this.heightMod = 20;
			this.drawGUI(gear2Cont);
			gear2Cont.x = gear1Cont.width;
			this.addChild(gear2Cont);
			
			var gearCompCont:Sprite = new Sprite();
			var gearCompTxt:TxtFields = new TxtFields("ToolTip3",(gear1Cont.width + gear2Cont.width - 10),100,true,false);
			
			var gui:WindowBox;
			
			var stat1:int;
			var stat2:int;
			var statDiff:int;
			var txt:String = "";
			for each (var val:Object in this.statComp) {
				if (gear1 == null) {
					stat1 = 0;
				} else {
					stat1 = gear1[val.name];
				}
				stat2 = gear2[val.name];
				statDiff = (stat2 - stat1);
				if (statDiff < 0) {
					txt += '<font color="#880000">'+statDiff+' '+val.stat+'</font>\n'; 
				} else if (statDiff > 0) {
					txt += '<font color="#0000FF">+'+statDiff+' '+val.stat+'</font>\n';
				}
			}
			
			for each (var val:Object in this.bonusComp) {
				if (gear1 == null || gear1["iStats"][val.val] == undefined) {
					stat1 = 0;
				} else {
					stat1 = gear1["iStats"][val.val];
				}
				stat2 = gear2["iStats"][val.val];
				statDiff = (stat2 - stat1);
				if (statDiff < 0) {
					txt += '<font color="#880000">'+statDiff+' '+val.name+'</font>\n'; 
				} else if (statDiff > 0) {
					txt += '<font color="#0000FF">+'+statDiff+' '+val.name+'</font>\n';
				}
			}
			
			if (txt != "") {
				gearCompTxt.htmlText = txt;
			}
			gearCompTxt.x = 5;
			if (gear2Cont.height > gear1Cont.height) {
				gearCompTxt.y = gear2Cont.height;
			}else {
				gearCompTxt.y = gear1Cont.height;
			}
			gearCompTxt.height = gearCompTxt.textHeight;
			
			this.addChild(gearCompTxt);
			
			this.eqButton = new textButton(this,<text size="small">Equip</text>);
			this.eqButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			this.addChild(this.eqButton);
			this.eqButton.x = (this.width - this.eqButton.width)/2;
			this.eqButton.y = gearCompTxt.y + gearCompTxt.height;
			
			gui = new WindowBox(-5,-5,(gearCompTxt.height + 15 + gearCompTxt.y + this.eqButton.height),(gearCompTxt.width + 20), 1.0);
			this.addChildAt(gui,0);
		}
		
		private function onMouseClick (e:MouseEvent):void {
			switch (e.target.txt.text) {
				case "Equip":
					(this.parent as EquipMenu).char.gear.equipGear((this.parent as EquipMenu).char, this.gear);
					(this.parent as EquipMenu).reDrawVals();
					this.clearGearTip();
					break
				case "Unequip":
					(this.parent as EquipMenu).char.gear.unEquipGear((this.parent as EquipMenu).char, this.gear);
					this.visible = false;
					break;
			}
		}
		
		private function runOnce(e:TimerEvent):void {
			this.visible = false;
			this.clearGearTip();
		}
		
		public function clearGearTip():void {
			if (this.numChildren > 0) {
				for (var i:int = (this.numChildren-1); i>=0; i--) {
					var child:* = this.getChildAt(i);					
					this.removeChild(child);
					child = null;
				}
			}
		}
	}
}