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
	
	public class allyManager extends Sprite{
		[Embed(source="Assets/Button-UP.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTN_UP:Class;
		[Embed(source="Assets/Button-DOWN.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTN_DOWN:Class;
		
		protected static const data:XML = <data/>
		protected static const data2:XML = 	<data>
												<i label="1"/>
												<i label="2"/>
												<i label="3"/>
												<i label="4"/>
												<i label="5"/>
												<i label="6"/>
												<i label="7"/>
												<i label="8"/>
												<i label="9"/>
											</data>;
			
			
		public static var ALLY_VIEW:XML = 	<horizontal alignH="left" alignV="top" width="250">
												<list id="allylist" colour="#333366"  gapV="0">{data}<label id="label"><font size="20"/></label></list>		
												<vertical>
													<horizontal>
														<input id="allyAlias" width="200" alt="true" prompt="Alias" />
														<input id="allyLvl" width="100" alt="true" prompt="Level" />
													</horizontal>
													<horizontal>
														<menu id="allyRace" alt="true" value="Race">{<data><Human/><Elf/><Dwarf/></data>}</menu>
														<menu id="allyType" alt="true" value="Type">{<data><Physical/><Ranged/><Magic/></data>}</menu>
														<menu id="allyCaste" alt="true" value="Caste">{data}</menu>
													</horizontal>
													<horizontal>
														<image>8</image>
														<label><b>HP</b></label>
														<image>10</image>
														<label><b>MP</b></label>
														<image>15</image>
														<label><b>Str</b></label>
														<image>15</image>
														<label><b>Agi</b></label>
														<image>15</image>
														<label><b>Spr</b></label>
														<image>15</image>
														<label><b>Dex</b></label>
														<image>15</image>
														<label><b>Vit</b></label>
														<image>15</image>
														<label><b>Wis</b></label>
													</horizontal>
													<horizontal>
														<columns gapH="0" widths="60,60,60,60,60,60,60,60" width="480" pickerHeight="100">
														    <picker alignH="fill" id="allyHP">{data2}</picker>
															<picker alignH="fill" id="allyMP">{data2}</picker>
														    <picker alignH="fill" id="allyStr">{data2}</picker>
														    <picker alignH="fill" id="allyAgi">{data2}</picker>
														    <picker alignH="fill" id="allySpr">{data2}</picker>
														    <picker alignH="fill" id="allyDex">{data2}</picker>
															<picker alignH="fill" id="allyVit">{data2}</picker>
															<picker alignH="fill" id="allyWis">{data2}</picker>
														</columns>
													</horizontal>
													<columns widths="70,50,55,55,50,50,60,50">
														<label id="HP"/>
														<label id="MP"/>
														<label id="Str"/>
														<label id="Agi"/>
														<label id="Spr"/>
														<label id="Dex"/>
														<label id="Vit"/>
														<label id="Wis"/>
													</columns>
													<horizontal>
														<label>Attack:</label>
														<label id="allyAtk" width="75"/>
														<label>To Hit:</label>
														<label id="ToHit" width="75"/>
														<label>Crit:</label>
														<label id="Crit" width="75"/>
													</horizontal>
													<horizontal>
														<label>Defense:</label>
														<label id="allyDef" width="75"/>
														<label>Block:</label>
														<label id="Block" width="75"/>
													</horizontal>
													<horizontal>
														<label>Magic Defense:</label>
														<label id="allymDef" width="75"/>
													</horizontal>
												</vertical>
											</horizontal>;
			
		private static var _allyList:UIList;
		
		private static var _allyAlias:UIInput;
		private static var _allyRace:UIMenu;
		private static var _allyType:UIMenu;
		private static var _allyCaste:UIMenu;
		private static var _allyLvl:UIInput;
		
		private static var _allyHP:UIPicker;
			private static var _HP:UILabel;
		private static var _allyMP:UIPicker;
			private static var _MP:UILabel;
		private static var _allyStr:UIPicker;
			private static var _Str:UILabel;
		private static var _allyAgi:UIPicker;
			private static var _Agi:UILabel;
		private static var _allySpr:UIPicker;
			private static var _Spr:UILabel;
		private static var _allyDex:UIPicker;
			private static var _Dex:UILabel;
		private static var _allyVit:UIPicker;
			private static var _Vit:UILabel;
		private static var _allyWis:UIPicker;
			private static var _Wis:UILabel;
			
		private static var _Atk:UILabel;
		private static var _mAtk:UILabel;
		private static var _Def:UILabel;
		private static var _mDef:UILabel;
		
		private static var _toHIT:UILabel;
		private static var _CRIT:UILabel;
			
		private static var ALLY:Object;
		
		public function allyManager(){
			super();
		}
		
		public static function onDisplay(e:Event):void {
			ALLY = new Object();
			ALLY.Lvl = 1;
			
			var formula:Formulas = new Formulas();
			
			var data:XML = <data />;
			for each (var obs:Object in sqlManager.ally) {
				data.appendChild(<i label={obs.Alias}/>);	
			}
			
			_allyList = UIList(UI.findViewById("allylist"));
				_allyList.addEventListener(UIList.CLICKED, onListClick);
				_allyList.xmlData = data;
			
			_allyAlias = UIInput(UI.findViewById("allyAlias"));
			_allyLvl = UIInput(UI.findViewById("allyLvl"));
				_allyLvl.addEventListener(TextEvent.TEXT_INPUT,onTextChange)
			_allyRace = UIMenu(UI.findViewById("allyRace"));
			_allyType = UIMenu(UI.findViewById("allyType"));
				_allyType.addEventListener(UIMenu.SELECTED,onTypeSelect);
			_allyCaste = UIMenu(UI.findViewById("allyCaste"));
				_allyCaste.addEventListener(UIMenu.SELECTED, onCasteSelect);
			
			_allyHP = UIPicker(UI.findViewById("allyHP"));	
				_HP = UILabel(UI.findViewById("HP"));
			_allyMP = UIPicker(UI.findViewById("allyMP"));	
				_MP = UILabel(UI.findViewById("MP"));	
			_allyStr = UIPicker(UI.findViewById("allyStr"));	
				_Str = UILabel(UI.findViewById("Str"));	
			_allyAgi = UIPicker(UI.findViewById("allyAgi"));	
				_Agi = UILabel(UI.findViewById("Agi"));	
			_allySpr = UIPicker(UI.findViewById("allySpr"));	
				_Spr = UILabel(UI.findViewById("Spr"));	
			_allyDex = UIPicker(UI.findViewById("allyDex"));	
				_Dex = UILabel(UI.findViewById("Dex"));	
			_allyVit = UIPicker(UI.findViewById("allyVit"));	
				_Vit = UILabel(UI.findViewById("Vit"));	
			_allyWis= UIPicker(UI.findViewById("allyWis"));	
				_Wis = UILabel(UI.findViewById("Wis"));			
			
			_Atk = UILabel(UI.findViewById("allyAtk"));
			_mAtk = UILabel(UI.findViewById("allymAtk"));
			_Def = UILabel(UI.findViewById("allyDef"));
			_mDef = UILabel(UI.findViewById("allymDef"));
			
			_toHIT = UILabel(UI.findViewById("ToHit"));
			_CRIT = UILabel(UI.findViewById("Crit"));
		}
		
		private static function onListClick (e:Event):void {
			ALLY = sqlManager.ally[_allyList.index];
			
			_allyAlias.text = ALLY.Alias;
			_allyLvl.text = ALLY.Lvl;
		}
		
		private static function onTextChange(e:TextEvent):void {
			ALLY.Lvl = int(allyManager["_allyLvl"].text);
			setAllyStats();
		}
		
		private static function onTypeSelect(e:MyEvent):void {
			ALLY.Type = e.parameters[1];
			
			var data:XML;
			switch (e.parameters[1]) {
				case "Physical":
					data = <data><Warrior/><Rogue/></data>;
					break;
				case "Ranged":
					data = <data><Ranger/></data>;
					break;
				case "Magic":
					data = <data><Mage/><Priest/></data>;
					break;
			}
			_allyCaste.text = "Caste";
			_allyCaste.xmlData = data;
		}
		
		private static function onCasteSelect(e:MyEvent):void {			
			ALLY.Caste = e.parameters[1];
			
			_allyHP.setIndex(sqlManager.Allies[e.parameters[1]].HP,false, true);
			_allyMP.setIndex(sqlManager.Allies[e.parameters[1]].MP,false, true);
			
			_allyStr.setIndex(sqlManager.Allies[e.parameters[1]].Str,false,true);
			_allyAgi.setIndex(sqlManager.Allies[e.parameters[1]].Agi,false,true);
			_allySpr.setIndex(sqlManager.Allies[e.parameters[1]].Spr,false,true);
			_allyDex.setIndex(sqlManager.Allies[e.parameters[1]].Dex,false,true);
			_allyVit.setIndex(sqlManager.Allies[e.parameters[1]].Vit,false,true);
			_allyWis.setIndex(sqlManager.Allies[e.parameters[1]].Wis,false,true);
			
			setAllyStats();
		}
		
		public static function setAllyStats():void {
			if (ALLY.Caste) {
				ALLY.Str = int(Formulas.STATS(_allyStr.index,ALLY.Lvl));
				ALLY.Agi = int(Formulas.STATS(_allyAgi.index,ALLY.Lvl));
				ALLY.Dex = Formulas.STATS(_allyDex.index,ALLY.Lvl);
				ALLY.Spr = Formulas.STATS(_allySpr.index,ALLY.Lvl);
				ALLY.Vit = Formulas.STATS(_allyVit.index,ALLY.Lvl);
				ALLY.Wis = Formulas.STATS(_allyWis.index,ALLY.Lvl);
				
				ALLY.HP = Formulas.VITALS("HP",_allyHP.index,ALLY)
				ALLY.MP = Formulas.VITALS("MP",_allyMP.index,ALLY)
				
				_Str.text = String(ALLY.Str);
				_Agi.text = String(ALLY.Agi);
				_Dex.text = String(ALLY.Dex);
				_Spr.text = String(ALLY.Spr);
				_Vit.text = String(ALLY.Vit);
				_Wis.text = String(ALLY.Wis);	
				
				_Atk.text = String(Formulas.allyAtk(ALLY,_allyType.text));
				
				_Def.text = String(Formulas.allyDef(ALLY,"Physical"));
				_mDef.text = String(Formulas.allyDef(ALLY,"Magic"));
				
				_HP.text = String(ALLY.HP);
				_MP.text = String(ALLY.MP);
				
				_toHIT.text = String(Formulas.toHit(ALLY,new Object()))+" %";
				_CRIT.text = String(Formulas.CritChance(ALLY))+" %";
			}
		}
	}
}