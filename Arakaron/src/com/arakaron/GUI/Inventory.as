package com.arakaron.GUI{
	import com.arakaron.Game_Inventory;
	import com.arakaron.dbManager;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Inventory extends Sprite implements MenuGUI{
		
		protected static var data:XML = <data/>;
		private var gearList:XML = <list id="list" colour="#333366"  mask="true" gapV="0">{data}<label id="label"><font size="10"/></label></list>; 
		private var _gearList:UIList;
		
		public function Inventory(){
			super();
			
			this.visible = false;
		}
		
		public function onAddedToStage():void{
			this.visible = true;
			
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
			
			this._gearList.x = 182;
			this._gearList.y = 154;
			
			var btn:getTextButton = new getTextButton("Hey","medium");
			btn.x = 700;
			btn.y = 200;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onbtnclick);
		}
		
		public function onRemovedFromStage():void{
		}
		
		public function drawGUI():void{
		}
		
		public function onbtnclick(e:MouseEvent):void {
			trace ("Clickity Click Click");
			data.appendChild(<i label={"Howdy"} data={"A|3"}/>);
			trace (data);
			this._gearList.xmlData = data;
			//this.gearList.XMLdata = data;
		}
		
		public function onExitClick(e:MouseEvent):void{
		}
	}
}