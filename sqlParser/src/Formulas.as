package{
	import flash.geom.Orientation3D;

	public class Formulas{
		public static var armorSlots:Object = new Object();
		public static var armorStyle:Object = new Object();
		public static var armorQuality:Object = new Object();
		
		public static var weaponSlots:Object = new Object();
		public static var weaponStyle:Object = new Object();
		public static var weaponQuality:Object = new Object();
		
		public static var rareMod:Object = new Object();
		
		public static var Allies:Object = new Object();
		
		public function Formulas(){
			armorSlots.Chest = 1.28;
			armorSlots.Helm = 1.04;
			armorSlots.Boots = 0.88;
			armorSlots.Gloves = 0.80;
			
			armorStyle.Cloth = {mod:2.09,int:10.34};
			armorStyle.Leather = {mod:3.37,int:15.869};
			armorStyle.Chain = {mod:4.934,int:22.806};			
			armorStyle.Mail = {mod:5.738,int:33.436};
			armorStyle.Plate = {mod:7.034,int:44.224};
			armorStyle.Mithril = {mod:10.2486,int:67.104};
			
			rareMod.Common = 1.00;
			rareMod.Uncommon = 1.08;
			rareMod.Magic = 1.22;
			rareMod.Rare = 1.74;
			rareMod.Epic = 2.0;
			
			weaponSlots.Dagger = {speed:1.8, mod:0.004, mod2:0.3283, int:1.0882};
			weaponSlots.OHSword = {speed:2.25, mod:0.004, mod2:0.3283, int:1.0882};
			weaponSlots.OHAxe = {speed:2.25, mod:0.004, mod2:0.3283, int:1.0882};
			weaponSlots.OHMace = {speed:2.25, mod:0.004, mod2:0.3283, int:1.0882};
			weaponSlots.THSword = {speed:3.0, mod:0.004, mod2:0.4996, int:0.7};
			weaponSlots.THAxe = {speed:3.0, mod:0.004, mod2:0.4996, int:0.7};
			weaponSlots.THMace = {speed:3.0, mod:0.004, mod2:0.4996, int:0.7};
			weaponSlots.Wand = {speed:1.8, mod:0.0011, mod2:0.216, int:0.5};
			weaponSlots.Staff = {speed:3.1, mod:0.0043, mod2:0.4042, int:1.1039};
			weaponSlots.Bow = {speed:2.3, mod:0.0038, mod2:0.4589, int:1.3406};
			weaponSlots.CrossBow = {speed:2.7, mod:0.0038, mod2:0.4589, int:1.3406};
			weaponSlots.ThrowingKnife = {speed:1.8, mod:0.0038, mod2:0.4589, int:1.3406};
			
			weaponStyle.Wood = 0.01;
			weaponStyle.Stone = 0.02;
			weaponStyle.Copper = 0.03;
			weaponStyle.Iron = 0.04;
			weaponStyle.Steel = 0.05;
			weaponStyle.Mithril = 0.06;
			
			weaponQuality.Tempered = 4;
			weaponQuality.Sharpened = 3;
			weaponQuality.Strong = 2;
			weaponQuality.Balanced = 1;
			weaponQuality.Normal = 0;
			weaponQuality.Chipped = -1;
			weaponQuality.Dull = -2;
			weaponQuality.Bent = -3;
			weaponQuality.Cracked = -4;
			
		}
		
		public static function DEF (Item:Object):int {
			var style:Number = armorStyle[Item.iStyle].int;
			var lvl:Number = armorStyle[Item.iStyle].mod * Math.pow(Item.iLvl, (1 + (rareMod[Item.iRarity] - 1)/10 + Item.iStyle/50));
			var slot:Number = armorSlots[Item.iSlot];
			
			var _def:int = Math.ceil(slot * (lvl + style));
			
			return (_def);
		}
		
		public static function ATK (Item:Object):int {
			var style:Number = 2 * weaponSlots[Item.iSlot].speed;
			var mod1:Number = weaponSlots[Item.iSlot].mod * Math.pow(Item.iLvl, (2 + (rareMod[Item.iRarity] - 1)/10));
			var mod2:Number = weaponSlots[Item.iSlot].mod2 * Math.pow(Item.iLvl, (1 + weaponQuality[Item.iQuality]/50 + weaponStyle[Item.iStyle]));
			var yint:Number = weaponSlots[Item.iSlot].int;
			
			var _atk:int = Math.ceil(style * (mod1 + mod2 + yint));
			return (_atk);
		}
		
		public static function gearLvl(Item:Object):int {
			var _lvlmod:Number = (100 * Item.iLvl)/(10-rareMod[Item.iRarity]);
			var _yint:Number = 15 * (Math.pow(Math.sqrt(Item.iLvl),(3 + rareMod[Item.iRarity]/15)));
			var _denom:Number = 100 - Math.pow(rareMod[Item.iRarity],4);
			
			return ((_lvlmod + _yint)/_denom);
		}
		
		public static function ENCHANT (Item:Object, statMax:int, modSlots:int):int {
			var _stat:int;
			var _minStat:Number = Item.gLvl/4;
			var _numer:Number = (statMax-modSlots)/(modSlots * (5-modSlots));
			
			_stat = _minStat * (1 + _numer);
			
			if (Item.iType == "Armor") {
				_stat *= 1.5;
				if (Item.iSlot == "Boots") {
					_stat *= 0.75;
				} else if (Item.iSlot == "Gloves") {
					_stat *= 0.75;
				}
			}
			return (_stat);			
		}
		
		public static function VITALS (type:String, growth_val:int, ally:Object):int {
			var stat:int;
			var grad2:Number;
			var grad:Number;
			
			switch (type) {
				case "HP":	
					grad = (0.75 + 0.0325 * growth_val);
					grad2 = Math.exp(-0.1*ally.Lvl + 5);
					
					stat = (8750/(grad + grad2)) + 150 + (4 - growth_val) + (ally.Vit * 7);
					
					break;
				case "MP":
					grad = (0.8866 + 0.0325 * growth_val);
					grad2 = Math.exp(-0.1*ally.Lvl + 5);
					
					stat = (875/(grad + grad2)) + 10 + (4 - growth_val) + (ally.Wis * 5);
					break;
			}
			return (stat);
		}
		
		public static function STATS (growth_val:int, lvl:int):int {
			var grad:Number = (0.75 + 0.075*growth_val);
			var grad2:Number = Math.exp(-0.09*lvl + 5);
			
			var stat:Number = (250/(grad + grad2)) + 10 + (4 - growth_val); 
			
			return (Math.ceil(stat));
		}
		
		public static function allyAtk (att:Object, type:String):int {	
			var atk:Number;
			switch (type) {
				case "Physical":
					atk = ((att.Str * 0.5) + (att.Agi * 0.5))* (0.85 + (att.Dex/600));
					break;
				case "Magic":
					atk = (att.Spr * 1.5) * (0.90 + (att.Dex/600));
					break;
				case "Ranged":
					atk = ((att.Str * 0.3) + (att.Agi * 0.7)) * (0.85 + (att.Dex/500));
					break;
			}
			return Math.round(atk);
		}
		
		public static function allyDef (att:Object, type:String):int {
			att.Def = 10
			var def:Number;
			switch (type) {
				case "Physical":
					def = ((att.Agi * 2) * (0.85 + (att.Dex/1000))) + att.Def;
					break;
				case "Magic":
					def = (att.Spr * 2) + (att.Def / (1 + Math.exp((-0.017 * att.Spr) + 4)));
					break;
				case "Ranged":
					def = ((att.Agi * 2) * (0.85 + (att.Dex/1000))) + att.Def;
					break;
			}
			return Math.round(def);
		}
		
		public static function toHit (att:Object, def:Object):Number {
			def.Lvl = att.Lvl;
			def.Agi = att.Agi;
			
			var _tohit:Number;
			var _agiDiff:Number = 110/(1 + Math.exp((-0.8 * (att.Agi - def.Agi)/att.Agi) -0.367)) - 65; 
			var _lvlDiff:Number = (att.Lvl - def.Lvl) * 0.5;
			
			_tohit = Math.round(100 * (60 + _agiDiff + _lvlDiff))/100;
			
			return (_tohit);
		}
		
		public static function Damage (att:Object, power:int, targ:Object, type:String):int {
			var base_dmg:Number;
			var max:Number;
			var dam:int;
			
			switch (type) {
				case "Physical":
				case "Ranged":
				case "Magic":
					base_dmg = allyAtk(att,type) + ((allyAtk(att,type) + att.Lvl)/32) * ((allyAtk(att,type) * att.Lvl)/32);
					max = (power * (1 - DR(targ, att, type)) * base_dmg)/8;
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
		
		public static function DR(targ:Object, att:Object, type:String):Number {
			var enDef:Number = allyDef(targ,type)/(allyDef(targ,type)  + 400 + (30 * att.Lvl));
			
			return ((100 * enDef)/100);
		}
		
		public static function CritChance (att:Object):Number {
			var _crit:Number = 2 + Math.pow(att.Lvl,0.4);

			switch (att.Type) {
				case "Physical":
					_crit += ((att.Agi/50) * (att.Dex/50));
					break;
				case "Magic":
					_crit += ((att.Spr/25) * (att.Dex/75));
					break;
				case "Ranged":
					_crit += ((att.Agi/25) * (att.Dex/75));
					break;
			}
			return (Math.round(100 * _crit)/100);
		}
		
		public static function Rand_Num (type:String):Number {
			var rand:Number;
			switch (type) {
				case "Damage":
					rand = int(1000 * (3686 + (Math.random() * 410))/4096)/1000;
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