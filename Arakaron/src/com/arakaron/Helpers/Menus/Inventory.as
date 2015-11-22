package com.arakaron.Helpers.Menus{
	import com.arakaron.Arakaron;
	import com.arakaron.AssetManager;
	import com.arakaron.GUI.*;
	import com.arakaron.GUI.MenuBox;
	import com.arakaron.GUI.MenuGUI;
	import com.arakaron.Game_Inventory;
	import com.arakaron.dbManager;
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.*;
	import flash.utils.getQualifiedClassName;
	
	public class Inventory extends Sprite implements MenuGUI{
		
		protected static var data:XML = <data/>;
		private var LAYOUT:XML = <horizontal autoScale="false">
									<skin>{getQualifiedClassName(AssetManager.MENU2)}</skin>
									<textbtn id="exitbtn" type="Exit"/>
									<vertical>
										<image>375,30</image>
										<frame><horizontal>{LAYOUT1}{LAYOUT2}</horizontal></frame>
									</vertical>	
								</horizontal>; 
		protected static var LAYOUT1:XML =  <horizontal>
												<vertical width="200">
													<horizontal alignH="centre">
														<textbtn size="medium" id="itmbtn">Items</textbtn>
														<textbtn size="medium" id="gearbtn">Gear</textbtn>
													</horizontal>
													<list id="itemlist" gapV="0" mask="true" width="200" height="400">{data}<label id="label"><font/></label></list>
												</vertical>
												<image>5,300</image>
											</horizontal>;
		protected static var LAYOUT2:XML = 	<vertical>
												<image>150,25</image>
												<horizontal>
													<label><b>Name:</b></label>
													<label id="itmname"/>
												</horizontal>
												<textbtn size="medium" id="itmuse" visible="false">Use Item</textbtn>
											</vertical>;

		private var _itemList:UIList;
		
		private var _itmbtn:textButton;
		private var _gearbtn:textButton;
		private var _exitbtn:textButton;
		
		private var _itmname:UILabel;
		
		public function Inventory(){
			super();
			
			this.visible = false;
		}
		
		public function onAddedToStage():void{
			this.visible = true;
			trace (System.totalMemory);
			this.drawGUI();
			trace (System.totalMemory);
			this.x = (Arakaron.StageWidth - this.width)/2;
			this.y = (Arakaron.StageHeight - this.height)/2;
		}
		
		public function onRemovedFromStage():void{
		}
		
		public function drawGUI():void{
			

			UIe.activate(this);
			UI.extend(["textbtn"],[textButton]);
			UI.create(this,LAYOUT,525,500);

			var gearListing:Object = Game_Inventory.listInvent("Gear");
			
			data = <data/>;
			for (var slot:String in gearListing) {
				for (var itm:String in gearListing[slot]) {
					var alias:String = dbManager.Gear[slot][itm].alias
					if (gearListing[slot][itm] > 0) {
						data.appendChild(<i label={"Howdy"} data={"A|3"+Math.random()}/>);
					}
				}
			}
			
			this._itemList = UIList(UI.findViewById("itemlist"));
			this._itemList.xmlData = data;
			this._itemList.addEventListener(UIList.CLICKED,onListClick);
			
			this._itmbtn = textButton(UI.findViewById("itmbtn"));
			this._itmbtn.addEventListener(MouseEvent.CLICK,onItemClick);
			
			this._gearbtn = textButton(UI.findViewById("gearbtn"));
			this._gearbtn.addEventListener(MouseEvent.CLICK,onGearClick);
			
			_exitbtn = textButton(UI.findViewById("exitbtn"));
			_exitbtn.x = 483;
			_exitbtn.y = 4;
			this._exitbtn.addEventListener(MouseEvent.CLICK,onExitClick);
		}
		
		public function onListClick(e:Event):void {
			var index:String = this._itemList.data[this._itemList.index].data;
			
			this._itmname = UILabel(UI.findViewById("itmname"));
			this._itmname.text = index;
		}
		
		public function onItemClick(e:MouseEvent):void {
			var gearListing:Object = Game_Inventory.listInvent("Gear");
			
			data = <data/>;
			for (var slot:String in gearListing) {
				for (var itm:String in gearListing[slot]) {
					var alias:String = dbManager.Gear[slot][itm].alias
					if (gearListing[slot][itm] > 0) {
						data.appendChild(<i label={"Howdy"} data={"A|3"}/>);
					}
				}
			}
			this._itemList.xmlData = data;
		}
		
		public function onGearClick(e:MouseEvent):void {
			
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
			this._itemList.xmlData = data;
		}
		
		public function onExitClick(e:MouseEvent):void{
			this.visible = false;
			
			UI.clear();
			
			_itemList = null;
			_itmname = null;
			
			_itmbtn.destructor();
			_itmbtn = null;
			_gearbtn.destructor();
			_gearbtn = null;
			_exitbtn.destructor();
			_exitbtn = null;
			
						
			Arakaron.mainMenu.onAddedToStage();
		}
	}
}