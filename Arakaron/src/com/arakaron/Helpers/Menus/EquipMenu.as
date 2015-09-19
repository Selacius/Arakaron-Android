package com.arakaron.Helpers.Menus{
	import com.arakaron.Arakaron;
	import com.arakaron.GUI.*
	import com.arakaron.Game_Inventory;
	import com.arakaron.Game_Party;
	import com.arakaron.Player;
	import com.arakaron.dbManager;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	
	public class EquipMenu extends Sprite implements MenuGUI{
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
		
		private var gear:Array = new Array(
									{slot:"A",name:"Helm", x:65, y:155},
									{slot:"A",name:"Chest", x:65, y:205},
									{slot:"A",name:"Gloves",x:15,y:180},
									{slot:"A",name:"Gloves",x:115,y:180},
									{slot:"A",name:"Gloves",x:15,y:230},
									{slot:"A",name:"Gloves",x:115,y:230},
									{slot:"A",name:"Boots", x:65, y:255},
									{slot:"W",name:"MHand",x:15,y:280},
									{slot:"A",name:"Boots", x:115, y:280});
		
		private  var gearIcon:Array;
		
		private var charDisplay:CharDisplay;
		private var lftBTN:Sprite;
		private var rgtBTN:Sprite;
		
		protected static var data:XML = <data/>;
		private var gearList:XML = <list id="list" colour="#333366"  mask="true" gapV="0">{data}<label id="label"><font size="10"/></label></list>; 
		private var _gearList:UIList;
		
		private var toolTip:ToolTip;
		
		public function EquipMenu(){
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
			
			this.charDisplay = new CharDisplay(membID, false, false);
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
			
			var verti:DrawLine = new DrawLine(300, "vert");
			verti.y = 156;
			verti.x = 180;
			this.addChild(verti);
			
			var i:int = 0;
			this.gearIcon = new Array();
			for each(var val:Object in this.gear) {
				this.gearIcon[i] = new IconBox(i,val.x, val.y);
				this.gearIcon[i].addIcon(char.gear.displayGearIcon(val.slot, val.name));
				this.addChild(this.gearIcon[i]);
				this.gearIcon[i].addEventListener(MouseEvent.CLICK, onMouseClick);
				i++;
			}
			
			this.toolTip = new ToolTip();
			this.addChild(this.toolTip);
			
			var gearListing:Object = Game_Inventory.listInvent("Gear");
			
			data = <data/>;
			for (var slot:String in gearListing) {
				for (var itm:String in gearListing[slot]) {
					var alias:String = dbManager.Gear[slot][itm].alias
					if (gearListing[slot][itm] > 0) {
						data.appendChild(<i label={alias} data={slot+"|"+itm}/>);
					}
				}
			}
			
			this.gearList.data = data;
			UI.create(this,gearList,328,300);
			
			_gearList = UIList(UI.findViewById("list"));
			_gearList.addEventListener(UIList.CLICKED,onTxtClick);
			
			this._gearList.x = 182;
			this._gearList.y = 154;
			
			this.setChildIndex(this._gearList,this.numChildren-1);
		}
		
		public function onTxtClick(e:Event):void {
			var gearItem:String = this._gearList.data[this._gearList.index].data;			
			var slot:String = gearItem.split("|")[0];
			var id:int = gearItem.split("|")[1];
			
			var itm2:Object = dbManager.Gear[slot][id];			
			
			this.toolTip.clearGearTip();
			this.toolTip.visible = true;
			this.toolTip.updateCompareGearTip(char.gear[slot][itm2.iSlot],itm2);
			this.toolTip.x = (e.target.x - this.toolTip.width - 8);
			this.toolTip.y = (e.target.y);
		}
		
		public function onMouseClick(e:MouseEvent):void {
			this.toolTip.clearGearTip();
			this.toolTip.visible = true;
			this.toolTip.updateGearTip(char.gear.getGearInfo(this.gear[e.target.ibID]) ,"unequip");
			this.toolTip.x = 0
			this.toolTip.y = (e.target.y);
		}
		
		public function reDrawVals():void {
			this.char = Game_Party.members(this.membID);
			
			var i:int
			
			for each(var val:Object in this.gear) {
				this.gearIcon[i].clearIcon();
				this.gearIcon[i].addIcon(char.gear.displayGearIcon(val.slot, val.name));
				i++;
			}
			this.charDisplay.charID = this.membID;
			this.charDisplay.reset();
			this.charDisplay.reDrawVals();
			
			this.toolTip.visible = false;
			
			var gearListing:Object = Game_Inventory.listInvent("Gear");
			
			data = <data/>;
			for (var slot:String in gearListing) {
				for (var itm:String in gearListing[slot]) {
					var alias:String = dbManager.Gear[slot][itm].alias;
					if (gearListing[slot][itm] > 0) {
						data.appendChild(<i label={alias} data={slot+"|"+itm}/>);
					}
				}
			}			
			this._gearList.xmlData = data;
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
				
				this.removeChild(this.gearIcon[i]);
				this.gearIcon[i] = null;
			}
			
			for (i=this.numChildren-2; i>=0; i--) {
				this.removeChildAt(i);				
			}
			
			this.charDisplay = null;
			this.gearIcon = null;
			
			this.gui.exitBtn.removeEventListener(MouseEvent.CLICK,onExitClick);
			this.gui = null;
			
			this.lftBTN = null;
			this.rgtBTN = null;
			
			this.charDisplay = null;
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