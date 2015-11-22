package{	
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
		
		protected static const data3:XML = <data>
												<i label="Empty">Empty</i>
												<i label="Strength">Str</i>
												<i label="Agility">Agi</i>
												<i label="Dexterity">Dex</i>
												<i label="Vitality">Vit</i>
												<i label="Wisdom">Wis</i>
												<i label="Spirit">Spr</i>
											</data>
			
		public static var stats:XML =	<vertical><horizontal>
											<menu value="Empty" alt="true" id="stat1" visible="false">{data3}</menu>
											<label id="stat1val" width="50" alt="true" visible="false">0</label>
											<menu value="Empty" alt="true" id="stat2" visible="false">{data3}</menu>
											<label id="stat2val" width="50" alt="true" visible="false">0</label>
										</horizontal>
										<horizontal>
											<menu value="Empty" alt="true" id="stat3" visible="false">{data3}</menu>
											<label id="stat3val" width="50" alt="true" visible="false">0</label>
											<menu value="Empty" alt="true" id="stat4" visible="false">{data3}</menu>
											<label id="stat4val" width="50" alt="true" visible="false">0</label>
										</horizontal></vertical>;
		public static var onhit:XML;
			
		public static const GEAR_VIEW:XML = <horizontal alignH="left" alignV="top" width="250">
				<list id="gearlist" colour="#333366"  gapV="0">{data}<label id="label"><font size="20"/></label></list>		
				<vertical>
					<horizontal>
						<label id="iID" width="50" alt="true">ID:</label>
						<input id="Alias" width="200" alt="true" prompt="Gear Name"></input>
						<input id="Lvl" width="50" alt="true" prompt="Required Level"></input>
						<label id="reqLvl" width="150" alt="true">Gear Level: </label>
					</horizontal>
					<horizontal>
						<menu value="Gear Type" alt="true" id="geartype">{<data><Armor/><Weapon/><Jewelry/></data>}</menu>
						<menu value="Gear Caste" alt="true" id="gearcaste">{<data><Physical/><Ranged/><Magic/></data>}</menu>
						<menu value="Rarity" alt="true" id="rarity">{<data><Common/><Uncommon/><Magic/><Rare/><Epic/></data>}</menu>
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
						<image>6</image>
						<label><b>Def</b></label>
						<image>6</image>
						<label><b>Magic Def</b></label>
					</horizontal>
					<horizontal>
						<columns gapH="0" widths="60,60,60" width="180" pickerHeight="100">
						    <picker alignH="fill" id="Atk"><data><i label="0"/></data></picker>
						    <picker alignH="fill" id="Def"><data><i label="0"/></data></picker>
						    <picker alignH="fill" id="mDef"><data><i label="0"/></data></picker>
						</columns>
						{stats}
					</horizontal>
					<vertical>
						{onhit}
						<input id="desc" width="500" alt="true" prompt="Description"></input>
						<horizontal>
							<label alt="true">Cost: </label>
							<label id="Cost" alt="true">10</label>
						</horizontal>
						<horizontal>
							<button id="insert">Add New Gear</button>
							<button id="update">Update Gear</button>
						</horizontal>
						<label id="Status"/>
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
		
		private static var _iID:UILabel;
		private static var _lvl:UIInput;
		private static var _reqLvl:UILabel;
		private static var _atk:UIPicker;
		private static var _atkp:UIPicker;
		private static var _def:UIPicker;
		private static var _defp:UIPicker;
		private static var _mdef:UIPicker;
		
		private static var _strLabel:UILabel;
		
		public static var _stat1Menu:UIMenu;
		public static var _stat1Val:UILabel;
		public static var _stat2Menu:UIMenu;
		public static var _stat2Val:UILabel;
		public static var _stat3Menu:UIMenu;
		public static var _stat3Val:UILabel;
		public static var _stat4Menu:UIMenu;
		public static var _stat4Val:UILabel;
		
		public static var _statPick:int;
		public static var _statPickBase:int;
		
		public static var _insertBTN:UIButton;
		
		private static var _gearCost:UILabel;
		private static var rareMod:int = 1;
		private static var cost:Array = new Array();
		
		private static var Item:Object = new Object();
		
		private static var _statDef:Object = new Object();
		
		private static var _Status:UILabel;
		
		public function gearManager(){
			super();
		}
		
		public static function onDisplay(e:Event):void {
			_statDef.Str = "Strength";
			_statDef.Vit = "Vitality";
			_statDef.Agi = "Agility";
			_statDef.Spr = "Spirit";
			_statDef.Dex = "Dexterity";
			_statDef.Wis = "Wisdom";
			
			Item.BaseLvl = 1;
			
			Item.iAtk = 0;
			Item.iDef = 0;
			Item.imDef = 0;
			
			Item.iOnHit = null;
			Item.iDesc = null;
			Item.iStats = "";
			
			var formula:Formulas = new Formulas();
			
			_gearList = UIList(UI.findViewById("gearlist"));
				_gearList.addEventListener(UIList.CLICKED, onListClick);
			
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
			
			_iID = UILabel(UI.findViewById("iID"));	
			
			_lvl = UIInput(UI.findViewById("Lvl"));
				_lvl.addEventListener(TextEvent.TEXT_INPUT,onTextChange);
			_reqLvl = UILabel(UI.findViewById("reqLvl"));
			_atk = UIPicker(UI.findViewById("Atk"));
			_atkp = UIPicker(UI.findViewById("Atkp"));
			_def = UIPicker(UI.findViewById("Def"));
			_defp = UIPicker(UI.findViewById("Defp"));
			_mdef = UIPicker(UI.findViewById("mDef"));
			
			_stat1Menu = UIMenu(UI.findViewById("stat1"));
				_stat1Menu.addEventListener(UIMenu.SELECTED,onStatSelect);
			_stat1Val = UILabel(UI.findViewById("stat1val"));
			_stat2Menu = UIMenu(UI.findViewById("stat2"));
				_stat2Menu.addEventListener(UIMenu.SELECTED,onStatSelect);
			_stat2Val = UILabel(UI.findViewById("stat2val"));
			_stat3Menu = UIMenu(UI.findViewById("stat3"));
				_stat3Menu.addEventListener(UIMenu.SELECTED,onStatSelect);
			_stat3Val = UILabel(UI.findViewById("stat3val"));
			_stat4Menu = UIMenu(UI.findViewById("stat4"));
				_stat4Menu.addEventListener(UIMenu.SELECTED,onStatSelect);
			_stat4Val = UILabel(UI.findViewById("stat4val"));
			
			_insertBTN = UIButton(UI.findViewById("insert"));
				_insertBTN.addEventListener(MouseEvent.CLICK, onInsertClick);
			
			_Status = UILabel(UI.findViewById("Status"));
				
			var data:XML = <data/>;
			for each (var obs:Object in sqlManager.gear) {
				data.appendChild(<i label={obs.iAlias}/>);	
			}
			_gearList.xmlData = data;
		}
		
		private static function onListClick(e:Event):void {
			Item = sqlManager.gear[_gearList.index];
			_gearAlias.text = Item.iAlias;
			_lvl.text = Item.iLvl;
			_reqLvl.text = "Gear Level: "+Item.gLvl;
			_iID.text = "ID: "+ Item.ID;
			
			var data:XML = <data />;
			data.appendChild(<i label={Item.iAtk}/>);
			_atk.xmlData = data;
			
			var data2:XML = <data />;
			data2.appendChild(<i label={Item.iDef}/>);
			_def.xmlData = data2;
			
			var data3:XML = <data />;
			data3.appendChild(<i label={Item.imDef}/>);
			_mdef.xmlData = data3;
			
			_gearCost.text = Item.iCost;
			
			_gearType.text = Item.iType;
			_gearCaste.text = Item.iCaste;
			_gearRarity.text = Item.iRarity;
			
			_gearStyle.text = Item.iStyle;
			_gearSlot.text = Item.iSlot;
			_gearPrefix.text = Item.iQuality;
			
			setPrefix();
			setSlotStyle();
			setStatSelection();
			
			var tempStats = String(Item.iStats).split("|");
			Item.iStats = new Array();
			
			for each (var stat in tempStats) {
				var newStat = stat.split(",");
				Item.iStats.push (newStat);
			}
			
			if (Item.iStats != "null") {
				for (stat in Item.iStats) {
					gearManager["_stat"+(stat+1)+"Menu"].text = _statDef[Item.iStats[stat][0]];
					gearManager["_stat"+(stat+1)+"Val"].text = Item.iStats[stat][1];
				}
			}
			
			if (Item.iType == "Armor") {
				Item.BaseDef = Item.iDef;
			} else if (Item.iType == "Weapon") {
				Item.BaseAtk = Item.iAtk;
			}
		}
		
		private static function onParseClick():void {
			if (Item.iLvl && Item.iRarity && Item.iType && Item.iCaste && Item.iSlot && Item.iStyle && Item.iQuality) {
				Item.gLvl = Formulas.gearLvl(Item);
				_reqLvl.text = "Gear Level: "+String(Formulas.gearLvl(Item));
				
				onStatSelect(null);
				
				if (Item.iType == "Armor") {
					
					Item.iDef = Formulas.DEF(Item);
					Item.BaseDef = Item.iDef;
					
					onOverrideSet(null);
				} else if (Item.iType == "Weapon") {
					
					Item.iAtk = Formulas.ATK(Item);
					Item.BaseAtk = Item.iAtk;
					
					onOverrideSet(null);
				}
			}
			updateCost();
		}
		
		private static function onRaritySelect(e:MyEvent):void {
			Item.iRarity = e.parameters[1];
			
			rareMod = 1 + e.parameters[0];
			
			_statPickBase = e.parameters[0]; 
			
			setStatSelection();
			
			onParseClick();
		}
		
		private static function onTypeSelect(e:MyEvent):void {
			Item.iType = e.parameters[1];
			
			setPrefix();
			
			cost[0] = 100;
			onParseClick();
		}
		
		
		private static function setPrefix():void {
			var data1:XML;
			switch (Item.iType) {
				case "Armor":
					Item.Table = "armors";
					data1 = <data><i label="Reinforced (+4)">Reinforced</i><i label="Hardened (+3)">Hardened</i><i label="Thick (+2)">Thick</i><i label="Sturdy (+1)">Sturdy</i><i label="Normal (0)">Normal</i><i label="Rusty (-1)">Rusty</i><i label="Battered (-2)">Battered</i><i label="Ragged (-3)">Ragged</i><i label="Cracked (-4)">Cracked</i></data>;
					break;
				case "Weapon":
					Item.Table = "weapons";
					data1 = <data><i label="Tempered (+4)">Tempered</i><i label="Sharpened (+3)">Sharpened</i><i label="Strong (+2)">Strong</i><i label="Balanced (+1)">Balanced</i><i label="Normal (0)">Normal</i><i label="Chipped (-1)">Chipped</i><i label="Dull (-2)">Dull</i><i label="Bent (-3)">Bent</i><i label="Cracked (-4)">Cracked</i></data>;
					break;
			}
			
			_gearPrefix.xmlData = data1;
		}
		
		private static function setSlotStyle():void {
			var data1:XML;
			var data2:XML;
			if (Item.iType == "Armor") {
				data2 = <data><Helm/><Chest/><Gloves/><Boots/></data>;
				switch (Item.iCaste) {
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
			} else if (Item.iType == "Weapon") {
				data1 = <data><Wood/><Stone/><Copper/><Iron/><Steel/><Mithril/></data>;
				switch (Item.iCaste) {
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
		}
		
		private static function setStatSelection():void {
			switch (Item.iRarity) {
				case "Common":
					_statPickBase = 0;
					break;
				case "Uncommon":
					_statPickBase = 1;
					break;
				case "Magic":
					_statPickBase = 2;
					break;
				case "Rare":
					_statPickBase = 3;
					break;
				case "Epic":
					_statPickBase = 4;
					break;
			}
			
			
			for (var i:int = 1; i<=4; i++){
				if (i <= _statPickBase) {
					gearManager["_stat"+i+"Menu"].visible = true;
					gearManager["_stat"+i+"Val"].visible = true;
				} else {
					gearManager["_stat"+i+"Menu"].visible = false;
					gearManager["_stat"+i+"Val"].visible = false;
				}
			}
		}
		
		private static function onPrefixSelect(e:MyEvent):void {
			Item.iQuality = 4 - e.parameters[0];
			
			onParseClick();
		}
		
		private static function onCasteSelect(e:MyEvent):void {
			Item.iCaste = e.parameters[1];
			
			setSlotStyle();
			onParseClick();
		}
		
		private static function onStyleSelect(e:MyEvent):void {
			Item.iStyle = e.parameters[1];
	
			cost[1] = (1 + e.parameters[0]) * 30;
			onParseClick();
		}
		
		private static function onSlotSelect(e:MyEvent):void {
			Item.iSlot = e.parameters[1];
			
			cost[2] = (1 + e.parameters[0]) * 40;
			onParseClick();
		}
		
		private static function onOverrideSet(e:Event):void {
			var data:XML = <data/>;
			if (Item.iType == "Armor") {
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
			} else if (Item.iType == "Weapon") {
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
					Item.iLvl = gearManager["_"+String(e.target.name).toLowerCase()].text;
				}
			}
			onParseClick();
		}
		
		private static function onStatSelect (e:MyEvent):void {
			_statPick = 0;
			for (var i=1; i<=_statPickBase; i++ ){
				if (gearManager["_stat"+i+"Menu"].text != "Empty") {
					_statPick++;
				}
			}
			for (i=1; i<=_statPickBase; i++ ){
				if (gearManager["_stat"+i+"Menu"].text != "Empty") {
					gearManager["_stat"+i+"Val"].text = Formulas.ENCHANT(Item,_statPickBase, _statPick);
					if (gearManager["_stat"+i+"Menu"].text == "Vitality" || gearManager["_stat"+i+"Menu"].text == "Wisdom") {
						gearManager["_stat"+i+"Val"].text = int(int(gearManager["_stat"+i+"Val"].text) * 1.33);
					}
				} else {
					gearManager["_stat"+i+"Val"].text = 0;
				}
			}
		}
		
		private static function updateCost():void {
			var tcost:int = 10;
			for each (var i in cost) {
				tcost += i;
			}
			
			if (Item.iType == "Armor") {
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
			
			Item.iCost = tcost;
			
			_gearCost.text = String(tcost);
		}
		
		public static function onInsertClick(e:MouseEvent):void {
			Item.iAlias = _gearAlias.text;
			Item.iStats = "";
			
			_Status.text = "";
			for (var i=1; i<=_statPickBase; i++) {
				if (gearManager["_stat"+(i+1)+"Menu"].text != "Empty") {
					Item.iStats += String(gearManager["_stat"+(i+1)+"Menu"].text).slice(0,3)+","+gearManager["_stat"+(i+1)+"Val"].text;
					if (i != _statPickBase) {
						Item.iStats+= "|";
					}
				}
			}
			
			sqlParser.sqlData.insertGearInfo(Item);
		}
	}
}