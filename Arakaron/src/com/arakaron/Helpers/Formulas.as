package com.arakaron.Helpers {
	import com.arakaron.Player;

	public class Formulas {
		[Embed(source='../Assets/Database/Growth Stats - Primary.xml', mimeType="application/octet-stream")]
    		public static const Primary_Stats:Class;
		[Embed(source='../Assets/Database/Growth Stats - HP.xml', mimeType="application/octet-stream")]
    		public static const Primary_Stats_HP:Class;
		[Embed(source='../Assets/Database/Growth Stats - MP.xml', mimeType="application/octet-stream")]
			public static const Primary_Stats_MP:Class;
		
		private var load_stats:XML;
		private var xmldoc:XML;
		
		private var vitals_HP:Array = new Array();
		private var vitals_MP:Array = new Array();
		
		public function Formulas () {	
		}
		
		public function xpn (lvl:int):int {
			var _xpp:int = 0;
			for (var i:int=1; i<=lvl; i++) {
				_xpp += (Math.pow(i, 1.75) * 160)
			}
			return _xpp;
		}
		
		public function play_vitals (type:String, growth_val:int, lvl:int):int {
			var stat:int;
			var grad2:Number;
			var grad:Number;
			
			switch (type) {
				case "HP":	
					grad = (0.8866 + 0.0325 * (growth_val - 1));
					grad2 = Math.exp(-0.1*lvl + 5);
					
					stat = (8750/(grad + grad2)) + 200 + (5 - growth_val);
					
					break;
				case "MP":
					grad = (0.8866 + 0.0325 * (growth_val - 1));
					grad2 = Math.exp(-0.1*lvl + 5);
					
					stat = (875/(grad + grad2)) + 20 + (5 - growth_val);
					break;
			}
			return (stat);
		}
		
		public function play_stats (growth_val:int, lvl:int):int {
			var grad:Number = (0.75 + 0.075*(growth_val-1));
			var grad2:Number = Math.exp(-0.09*lvl + 5);
			
			var stat:Number = (250/(grad + grad2)) + 10 + (5 - growth_val); 
			
			return (Math.ceil(stat));
		}
		
		public function enemy_stats (growth_val:int, lvl:int, rand:Number):int {
			var grad:Number = (0.75 + 0.075*(growth_val-1));
			var grad2:Number = Math.exp(-0.09*lvl + 5);
			
			var stat:Number = (250/(grad + grad2)) + 10 + (5 - growth_val); 
			
			return (Math.ceil(stat * rand));
		}
		
		public function enemy_vitals (type:String, growth_val:int, lvl:int, rand:Number):int {
			var grad3:Number;
			var grad2:Number;
			var grad:Number;
			var base:Number;
			var stat:int;
			
			switch (type) {
				case "HP":
					grad3 = this.vitals_HP[growth_val]["gradient3"] * Math.pow(lvl+9,3);
					grad2 = this.vitals_HP[growth_val]["gradient2"] * Math.pow(lvl+9,2);
					grad = this.vitals_HP[growth_val]["gradient1"] * (lvl+9);
					base = this.vitals_HP[growth_val]["base"] - 125;
					
					stat = grad3 + grad2 + grad + base;
					break;
				case "MP":
					grad3 = this.vitals_MP[growth_val]["gradient3"] * Math.pow(lvl,3);
					grad2 = this.vitals_MP[growth_val]["gradient2"] * Math.pow(lvl,2);
					grad = this.vitals_MP[growth_val]["gradient1"] * lvl;
					base = this.vitals_MP[growth_val]["base"];
					
					stat = grad3 + grad2 + grad + base;
					break;
			}
			
			return (Math.ceil(stat * rand));
		}
		
		public function Hit (att:Object, targ:Object, type:String):int {
			var hit:Number;
			switch (type) {
				case "Physical":
					hit = ((att.Dex/4) + att.AtkP) + (att.DefP - targ.DefP);
					break;
				case "Magic":
					hit = (att.MAtP + att.lvl) - (targ.lvl/2) - 1;
					break;
			} 
			
			return (hit);
		}
		
		public function Crit (att:Object, targ:Object):int {
			var crit:int = ((att.Luck + att.lvl - targ.lvl)/4) + att.CritP;
			
			return (crit);
		}
		
		public function Attack (att:Player, type:String):int {			
			var atk:Number;
			switch (type) {
				case "Physical":
					atk = (att.Str * 2.5) + (att.Agi * 2.5) + (3 * (1 + (att.Dex/1000)));
					break;
				case "Magic":
					atk = (att.Wisdom * 5) + (2 * (1 + (att.Dex/1000)));
					break;
				case "Ranged":
					atk = (att.Str * 1.5) + (att.Agi * 3.5) + (4 * (1 + (att.Dex/750)));
					break;
			}
			return Math.round(atk);
		}
		
		public function Defense (att:Object, type:String):int {
			//var def:Number = att.Vit + (att.gear_list.def * (0.85 + (att.Dex/1500)));
			var def:Number;
			switch (type) {
				case "Physical":
					//def = att.Vit + (att.gear_list.Def * (0.85 + (att.Dex/1500)));
					def = att.Vit + (10 * (0.85 + (att.Dex/1500)));
					break;
				case "Magic":
					//def = att.Spr + (att.gear_list.MDef * (0.85 + (att.wisdom/1500)));
					def = att.Spr + (10 * (0.85 + (att.Wisdom/1500)));
					break;
				case "Ranged":
					//def = att.Vit + (att.gear_list.Def * (0.85 + (att.Dex/1500)));
					def = att.Vit + (10 * (0.85 + (att.Dex/1500)));
					break;
			}
			return Math.round(def);
		}
		
		public static function Damage (att:Object, power:int, targ:Object, type:String):int {
			var base_dmg:Number;
			var max:Number;
			var dam:int;
			
			switch (type) {
				case "Physical":
					base_dmg = att.Atk(type) + ((att.Atk(type) + att.lvl)/32) * ((att.Atk(type) * att.lvl)/32);
					max = (power * (512 - targ.Def(type)) * base_dmg)/8192;
					dam = max * (Rand_Num("Damage"));
					break;
				case "Ranged":
					base_dmg = att.Atk(type) + ((att.Atk(type) + att.lvl)/32) * ((att.Atk(type) * att.lvl)/32);
					max = (power * (512 - targ.Def(type)) * base_dmg)/8192;
					dam = max * (Rand_Num("Damage"));
					break;
				case "Magic":
					base_dmg = 6 * (att.Atk(type) + att.lvl);
					max = (power * (512 - targ.Def(type)) * base_dmg)/8192;
					dam = max * (Rand_Num("Damage"));
					break;
				case "Cure":
					base_dmg = 6 * (att.Atk("Magic") + att.lvl);
					max = (power * 22 * base_dmg);
					dam = max * (Rand_Num("Damage"));
					break;
				case "Item":
					base_dmg = 16 * power;
					max = (base_dmg * (512 - targ.Def("Physical")))/512;
					dam = max * (Rand_Num("Damage"));
					break;
			}
			return (Math.floor(dam));
		}
		
		public static function DR(att:Object, targ:Object):Number {
			return (((att.Def/(att.Def + 400 + (30 * targ.Lvl)))*100)/100);
		}
		
		public static function Rand_Num (type:String):Number {
			var rand:Number;
			switch (type) {
				case "Damage":
					rand = int(1000 * (3841 + (Math.random() * 255))/4096)/1000;
					break;
				case "Battle":
					rand = (Math.round(((((Math.random() * 65535) * 99)/65535) + 1)*100)/100);	
					trace ("Battle: "+rand);
					break;
				case "Stats":
					rand = int(1000 * (3841 + (Math.random() * 1283))/4270)/1000;
					trace ("Stats: "+rand);
					break;
			}
			return (rand);
		}
	}
}