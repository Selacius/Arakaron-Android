package{
	public class Formulas{
		public static var armorSlots:Object = new Object();
		public static var armorStyle:Object = new Object();
		public static var armorQuality:Object = new Object();
		
		public static var weaponSlots:Object = new Object();
		public static var weaponStyle:Object = new Object();
		
		public static var rareMod:Object = new Object();
		
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
		}
		
		public static function DEF (Item:Object):int {
			var style:Number = armorStyle[Item.Style].int;
			var lvl:Number = armorStyle[Item.Style].mod * Math.pow(Item.Lvl, (1 + (rareMod[Item.Rarity] - 1)/10 + Item.Prefix/50));
			var slot:Number = armorSlots[Item.Slot];
			
			var _def:int = Math.ceil(slot * (lvl + style));
			
			return (_def);
		}
		
		public static function ATK (Item:Object):int {
			var style:Number = 2 * weaponSlots[Item.Slot].speed;
			var mod1:Number = weaponSlots[Item.Slot].mod * Math.pow(Item.Lvl, (2 + (rareMod[Item.Rarity] - 1)/10));
			var mod2:Number = weaponSlots[Item.Slot].mod2 * Math.pow(Item.Lvl, (1 + Item.Prefix/50 + weaponStyle[Item.Style]));
			var yint:Number = weaponSlots[Item.Slot].int;
			
			var _atk:int = Math.ceil(style * (mod1 + mod2 + yint));
			return (_atk);
		}
	}
}