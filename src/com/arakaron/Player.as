package com.arakaron  {
	import com.arakaron.Helpers.Avatar;
	import com.arakaron.Helpers.Formulas;
	
	import flash.display.Sprite;
	
	import flashx.textLayout.tlf_internal;
	
	public class Player extends Sprite{
		public var formula:Formulas = new Formulas;

		public var avatar:Avatar;
		
		public var gear:Gear_List;
		
		private var PC:XML;
		
		public var ident:int;
		public var alias:String;
		public var caste:String;
		public var race:String;
		
		public var lvl:int;
		public var xp:int=0;
		
		public var active_party:Boolean;
		
		public var HPMin:int, MPMin:int, a_hp:int=0, a_mp:int=0;
		public var a_str:int=0, a_agi:int=0, a_spr:int=0, a_dex:int=0, a_vit:int=0, a_wisdom:int=0;
		private var bhp:int, bmp:int, bstr:int, bagi:int, bspr:int, bdex:int, bvit:int, bwisdom:int;

		public function Player (PC:XML) {
			this.PC = PC;
			
			this.ident = PC.@id;
			this.alias = PC.name;
			this.caste = PC.type;
			this.race = PC.race;
			
			this.lvl = PC.lvl;
			this.xp = this.formula.xpn(this.lvl-1);
			
			this.gear = new Gear_List();
			this.addGear();
			
			this.HPMin = this.HPMax;
			this.MPMin = this.MPMax;
		}
		
		public function add_avatar():void{
			this.hitArea = new Sprite();
			this.hitArea.graphics.beginFill(0,0);
			this.hitArea.graphics.drawRect(6,8,20,16);
			this.hitArea.graphics.endFill();
			
			this.avatar = new Avatar(this.ident);
			this.addChild(this.avatar);
			this.addChild(this.hitArea);
		}
		
		private function addGear():void {
			for (var equ in PC.equip.gear) {
				if (this.PC.equip.gear[equ] != "-") {
					switch (String(this.PC.equip.gear[equ].@style)) {
						case "armor":
							this.gear.add_gear("A|"+this.PC.equip.gear[equ]);
							break;
						case "weapon":
							this.gear.add_gear("W|"+this.PC.equip.gear[equ]);
							break;
						case "jewelry":
							this.gear.add_gear("J|"+this.PC.equip.gear[equ]);
							break;
					}
				}
			}
		}
		
		public function get xpn():int {
			return (this.formula.xpn(this.lvl+1));
		}
		
		//HPMax
		public function get HPMax():int {
			this.bhp = this.formula.play_vitals("HP",this.PC.g_hp, this.lvl);			
			return (this.bhp + this.a_hp);
		}
		
		//MPMax
		public function get MPMax():int {
			this.bmp = this.formula.play_vitals("MP",this.PC.g_mp, this.lvl);	
			return (this.bmp + this.a_mp);
		}
		
		//Str
		public function get Str():int {
			this.bstr = this.formula.play_stats(this.PC.g_str, this.lvl);
			
			return (this.bstr + this.a_str);
		}
		
		//Agi
		public function get Agi():int {
			this.bagi = this.formula.play_stats(this.PC.g_agi, this.lvl);
			
			return (this.bagi + this.a_agi + this.gear.getStat(new Array("iStats","Agi")));
		}
		
		//Spr
		public function get Spr():int {
			this.bspr = this.formula.play_stats(this.PC.g_spr, this.lvl);			
			
			return (this.bspr + this.a_spr);
		}
		
		//Dex
		public function get Dex():int {
			this.bdex = this.formula.play_stats(this.PC.g_dex, this.lvl);
			
			return (this.bdex + this.a_dex);
		}
		
		//Vit
		public function get Vit():int {
			this.bvit = this.formula.play_stats(this.PC.g_vit, this.lvl);
			
			return (this.bvit + this.a_vit);
		}

		//Wisdom
		public function get Wisdom():int {
			this.bwisdom = this.formula.play_stats(this.PC.g_wisdom, this.lvl);
			
			return (this.bwisdom + this.a_wisdom);
		}
		
		public function Atk(type:String):int {
			//Attack
			if (type == null) {
				type = this.caste;
			}
			return (this.gear.getStat("iAtk") + this.formula.Attack(this,type));
		}
		
		public function get AtkP():int {
			return (0);
		}
		
		public function Def(type:String):int {
			var _def:int = this.formula.Defense(this,type);
			if (type == null) {
				type = this.caste;
			} else if (type == "Magic") {
				_def += this.gear.getStat("imDef");
			} else {
				_def += this.gear.getStat("iDef")
			}
			return (_def);
		}
		
		public function DefP(type:String):int {
			var _defP:int = 0;
			if (type == null) {
				type = this.caste;
			} else if (type == "Magic") {
				_defP = this.gear.getStat("imDefP")
			} else {
				_defP = this.Dex/4 + this.gear.getStat("iDefP") 
			}
			return (_defP);
		}		
	}
	
}
