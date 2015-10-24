package{
	import adobe.utils.XMLUI;
	
	import asfiles.MyEvent;
	
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	public class gearManager extends Sprite{
		[Embed(source="Assets/Button-UP.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTN_UP:Class;
		[Embed(source="Assets/Button-DOWN.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTN_DOWN:Class;
		
		protected static const data:XML = <data/>
		
		public static var stats:XML =	<vertical><horizontal>
											<menu value="Stat 1" alt="true" id="stat1" visible="false">{<data><Strength/><Agility/><Spirit/><Dexterity/><Vitality/><Wisdom/></data>}</menu>
											<input id="stat1val" width="100" alt="true" prompt="Stat 1 Val" visible="false"/>
											<menu value="Stat 2" alt="true" id="stat2" visible="false">{<data><Strength/><Agility/><Spirit/><Dexterity/><Vitality/><Wisdom/></data>}</menu>
											<input id="stat2val" width="100" alt="true" prompt="Stat 2 Val" visible="false"/>
										</horizontal>
										<horizontal>
											<menu value="Stat 3" alt="true" id="stat3" visible="false">{<data><Strength/><Agility/><Spirit/><Dexterity/><Vitality/><Wisdom/></data>}</menu>
											<input id="stat3val" width="100" alt="true" prompt="Stat 3 Val" visible="false"/>
											<menu value="Stat 4" alt="true" id="stat4" visible="false">{<data><Strength/><Agility/><Spirit/><Dexterity/><Vitality/><Wisdom/></data>}</menu>
											<input id="stat4val" width="100" alt="true" prompt="Stat 4 Val" visible="false"/>
										</horizontal></vertical>;
		public static var onhit:XML;
			
		public static const GEAR_VIEW:XML = <horizontal alignH="left" alignV="top" width="250">
				<list id="gearlist" colour="#333366"  gapV="0">{data}<label id="label"><font size="20"/></label></list>		
				<vertical>
					<horizontal>
						<menu value="Gear Type" alt="true" id="geartype">{<data><Armor/><Weapon/><Jewelry/></data>}</menu>
						<menu value="Gear Caste" alt="true" id="gearcaste">{<data><Physical/><Ranged/><Magic/></data>}</menu>
						<menu value="Rarity" alt="true" id="rarity">{<data><Common/><Uncommon/><Magic/><Rare/><Epic/></data>}</menu>
					</horizontal>
					<horizontal>
						<input id="Alias" width="200" alt="true" prompt="Gear Name"></input>
						<input id="Lvl" width="100" alt="true" prompt="Gear Level"></input>
					</horizontal>
					<horizontal>
						<menu value="Material Prefix" alt="true" id="gearprefix">{data}</menu>
						<menu value="Gear Material" alt="true" id="gearstyle">{data}</menu>
						<menu value="Gear Slot" alt="true" id="gearslot">{data}</menu>
					</horizontal>
					<horizontal>
						<label>Override Default Values:</label>
						<checkBox id="override" alt="true"/>
					</horizontal>
					<horizontal>
						<image>7</image>
						<label><b>Atk</b></label>
						<image>5</image>
						<label><b>To Hit</b></label>
						<image>6</image>
						<label><b>Def</b></label>
						<image>6</image>
						<label><b>Block</b></label>
						<label><b>Magic Def</b></label>
					</horizontal>
					<horizontal>
						<columns gapH="0" widths="60,60,60,60,60" width="300" pickerHeight="100">
						    <picker alignH="fill" id="Atk"><data><i label="0"/></data></picker>
							<picker alignH="fill" id="Atkp"><data><i label="0"/></data></picker>
						    <picker alignH="fill" id="Def"><data><i label="0"/></data></picker>
						    <picker alignH="fill" id="Defp"><data><i label="0"/></data></picker>
						    <picker alignH="fill" id="mDef"><data><i label="0"/></data></picker>
						</columns>
					</horizontal>
					<vertical>
						<frame>{stats}{onhit}</frame>
						<input id="desc" width="500" alt="true" prompt="Description"></input>
						<horizontal>
							<label alt="true">Cost: </label>
							<label id="Cost" alt="true">10</label>
						</horizontal>
						<horizontal>
							<button id="insert">Add New Gear</button>
							<button id="update">Update Gear</button>
						</horizontal>
					</vertical>
				</vertical>
			</horizontal>;
		
		private static var _gearAlias:UIInput;
		
		private static var _gearList:UIList;
		private static var _gearRarity:UIMenu;
		private static var _gearType:UIMenu;
		private static var _gearStyle:UIMenu;
		private static var _gearSlot:UIMenu;
		private static var _gearCaste:UIMenu;
		private static var _gearPrefix:UIMenu;
		
		private static var _override:UICheckBox;
		
		private static var _lvl:UIInput;
		private static var _atk:UIPicker;
		private static var _atkp:UIPicker;
		private static var _def:UIPicker;
		private static var _defp:UIPicker;
		private static var _mdef:UIPicker;
		
		public static var _stat1Menu:UIMenu;
		public static var _stat1Val:UIInput;
		public static var _stat2Menu:UIMenu;
		public static var _stat2Val:UIInput;
		public static var _stat3Menu:UIMenu;
		public static var _stat3Val:UIInput;
		public static var _stat4Menu:UIMenu;
		public static var _stat4Val:UIInput;
		
		public static var _insertBTN:UIButton;
		
		private static var _gearCost:UILabel;
		private static var rareMod:int = 1;
		private static var cost:Array = new Array();
		
		private static var Item:Object = new Object();
		
		public function gearManager(){
			super();
		}
		
		public static function onDisplay(e:Event):void {
			Item.BaseLvl = 1;
			
			Item.Atk = 0;
			Item.Atkp = 0;
			Item.Def = 0;
			Item.Defp = 0;
			Item.mDef = 0;
			
			Item.OnHit = null;
			Item.Desc = null;
			Item.Stats = null;
			
			var formula:Formulas = new Formulas();
			
			_gearList = UIList(UI.findViewById("gearlist"));
			
			_gearRarity = UIMenu(UI.findViewById("rarity"));
				_gearRarity.addEventListener(UIMenu.SELECTED,onRaritySelect);
				
			_gearType = UIMenu(UI.findViewById("geartype"));
				_gearType.addEventListener(UIMenu.SELECTED,onTypeSelect);
			
			_gearAlias = UIInput(UI.findViewById("Alias"));
				
			_gearStyle = UIMenu(UI.findViewById("gearstyle"));
				_gearStyle.addEventListener(UIMenu.SELECTED,onStyleSelect);
				
			_gearSlot = UIMenu(UI.findViewById("gearslot"));
				_gearSlot.addEventListener(UIMenu.SELECTED,onSlotSelect);
			
			_gearCaste = UIMenu(UI.findViewById("gearcaste"));
				_gearCaste.addEventListener(UIMenu.SELECTED,onCasteSelect);
			
			_gearCost = UILabel(UI.findViewById("Cost"));
			
			_override = UICheckBox(UI.findViewById("override"));
				_override.addEventListener(Event.CHANGE,onOverrideSet);
				
			_gearPrefix = UIMenu(UI.findViewById("gearprefix"));
				_gearPrefix.addEventListener(UIMenu.SELECTED,onPrefixSelect);
				
			_lvl = UIInput(UI.findViewById("Lvl"));
				_lvl.addEventListener(TextEvent.TEXT_INPUT,onTextChange);
			_atk = UIPicker(UI.findViewById("Atk"));
			_atkp = UIPicker(UI.findViewById("Atkp"));
			_def = UIPicker(UI.findViewById("Def"));
			_defp = UIPicker(UI.findViewById("Defp"));
			_mdef = UIPicker(UI.findViewById("mDef"));
			
			_stat1Menu = UIMenu(UI.findViewById("stat1"));
			_stat1Val = UIInput(UI.findViewById("stat1val"));
			_stat2Menu = UIMenu(UI.findViewById("stat2"));
			_stat2Val = UIInput(UI.findViewById("stat2val"));
			_stat3Menu = UIMenu(UI.findViewById("stat3"));
			_stat3Val = UIInput(UI.findViewById("stat3val"));
			_stat4Menu = UIMenu(UI.findViewById("stat4"));
			_stat4Val = UIInput(UI.findViewById("stat4val"));
			
			_insertBTN = UIButton(UI.findViewById("insert"));
				_insertBTN.addEventListener(MouseEvent.CLICK, onInsertClick);
		}
		
		private static function onParseClick():void {
			if (Item.Lvl && Item.Rarity && Item.Type && Item.Caste && Item.Slot && Item.Style) {
				if (Item.Type == "Armor") {
					Item.Quality = "Normal";
					
					Item.Def = Formulas.DEF(Item);
					Item.BaseDef = Item.Def;
					
					onOverrideSet(null);
				} else if (Item.Type == "Weapon") {
					Item.Quality = "Normal";
					
					Item.Atk = Formulas.ATK(Item);
					Item.BaseAtk = Item.Atk;
					
					onOverrideSet(null);
				}
			}
			updateCost();
		}
		
		private static function onRaritySelect(e:MyEvent):void {
			Item.Rarity = e.parameters[1];
			
			rareMod = 1 + e.parameters[0];
			
			for (var i:int = 0; i<4; i++){
				if (i <= (e.parameters[0] - 1)) {
					gearManager["_stat"+(i+1)+"Menu"].visible = true;
					gearManager["_stat"+(i+1)+"Val"].visible = true;
				} else {
					gearManager["_stat"+(i+1)+"Menu"].visible = false;
					gearManager["_stat"+(i+1)+"Val"].visible = false;
				}
			}
			
			onParseClick();
		}
		
		private static function onTypeSelect(e:MyEvent):void {
			Item.Type = e.parameters[1];
			
			var data1:XML;
			switch (Item.Type) {
				case "Armor":
					Item.Table = "armors";
					data1 = <data><Reinforced/><Hardened/><Thick/><Sturdy/><Normal/><Rusty/><Battered/><Ragged/><Cracked/></data>;
					break;
				case "Weapon":
					Item.Table = "weapons";
					data1 = <data><Tempered/><Sharpened/><Strong/><Balanced/><Normal/><Chipped/><Dull/><Bent/><Cracked/></data>;
					break;
			}
			
			_gearPrefix.xmlData = data1;
			
			cost[0] = 100;
			onParseClick();
		}
		
		private static function onPrefixSelect(e:MyEvent):void {
			Item.Prefix = 4 - e.parameters[0];
			
			onParseClick();
		}
		
		private static function onCasteSelect(e:MyEvent):void {
			Item.Caste = e.parameters[1];
			
			var data1:XML;
			var data2:XML;
			if (Item.Type == "Armor") {
				data2 = <data><Helm/><Chest/><Gloves/><Boots/></data>;
				switch (e.parameters[1]) {
					case "Physical":
						data1 = <data><Cloth/><Leather/><Chain/><Mail/><Plate/><Mithril/></data>;
						data2 = <data><Helm/><Chest/><Gloves/><Boots/><Shield/></data>
						break;
					case "Magic":
						data1 = <data><Cloth/><Leather/><Chain/></data>;
						break;
					case "Ranged":
						data1 = <data><Chain/><Mail/><Plate/></data>;
						break; 
				}
			} else if (Item.Type == "Weapon") {
				data1 = <data><Wood/><Stone/><Copper/><Iron/><Steel/><Mithril/></data>;
				switch (e.parameters[1]) {
					case "Physical":
						data2 = <data><Dagger/><OHSword/><OHAxe/><OHMace/><THSword/><THAxe/><THMace/></data>
						break;
					case "Magic":
						data2 = <data><Dagger/><Wand/><Staff/></data>;
						break;
					case "Ranged":
						data2 = <data><Dagger/><OHSword/><ThrowingKnife/><Bow/><CrossBow/></data>;
						break; 
				}
			}
			_gearStyle.xmlData = data1;
			_gearSlot.xmlData = data2;
			onParseClick();
		}
		
		private static function onStyleSelect(e:MyEvent):void {
			Item.Style = e.parameters[1];
	
			cost[1] = (1 + e.parameters[0]) * 30;
			onParseClick();
		}
		
		private static function onSlotSelect(e:MyEvent):void {
			Item.Slot = e.parameters[1];
			
			cost[2] = (1 + e.parameters[0]) * 40;
			onParseClick();
		}
		
		private static function onOverrideSet(e:Event):void {
			var data:XML = <data/>;
			if (Item.Type == "Armor") {
				if (_override.state) {
					for (var i=Item.BaseDef-10; i<=Item.BaseDef+10; i++) {
						data.appendChild(<i label={i}/>);
					}
					_def.xmlData = data;
					_def.setIndex(10,false,true);
				} else {
					data.appendChild(<i label={Item.BaseDef}/>);
					_def.xmlData = data;
				}
			} else if (Item.Type == "Weapon") {
				if (_override.state) {
					for (var i=Item.BaseAtk-10; i<=Item.BaseAtk+10; i++) {
						data.appendChild(<i label={i}/>);
					}
					_atk.xmlData = data;
					_atk.setIndex(10,false,true);
				} else {
					data.appendChild(<i label={Item.BaseAtk}/>);
					_atk.xmlData = data;
				}
			}
			
		}
		
		private static function onTextChange(e:TextEvent):void {
			if (String(e.target.name).indexOf("instance")) {
				if (e.target.name != "Lvl") {
					if (_override.state) {
						Item[e.target.name] = int(gearManager["_"+String(e.target.name).toLowerCase()].text);
					} else {
						gearManager["_"+String(e.target.name).toLowerCase()].text = Item["Base"+e.target.name];
					}
				} else {
					Item.Lvl = gearManager["_"+String(e.target.name).toLowerCase()].text;
				}
			}
			onParseClick();
		}
		
		private static function updateCost():void {
			var tcost:int = 10;
			for each (var i in cost) {
				tcost += i;
			}
			
			if (Item.Type == "Armor") {
			/*	tcost += int(_atk.text) * 10;
				tcost += int(_atkp.text) * 10;
				tcost += int(_def.text) * 5;
				tcost += int(_defp.text) * 5;
				tcost += int(_mdef.text) * 5;
				tcost += int(_mdefp.text) * 5;*/
			} else if (Item.Type == "Weapon") {
				/*tcost += int(_atk.text) * 5;
				tcost += int(_atkp.text) * 5;
				tcost += int(_def.text) * 10;
				tcost += int(_defp.text) * 10;
				tcost += int(_mdef.text) * 7;
				tcost += int(_mdefp.text) * 7;*/
			}
			
			tcost *= rareMod;
			
			Item.Cost = tcost;
			
			_gearCost.text = String(tcost);
		}
		
		public static function onInsertClick(e:MouseEvent):void {
			Item.Alias = _gearAlias.text;
			
			sqlParser.sqlData.insertGearInfo(Item);
		}
	}
}