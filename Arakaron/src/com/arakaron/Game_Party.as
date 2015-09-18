package com.arakaron {
	import flashx.textLayout.conversion.PlainTextExporter;

	public class Game_Party {
		public static var party:Array = new Array();
		private static var _active_party:Array;
		
		public function Game_Party() {
		}
		
		public static function size():int {
			var size:int;
			for (var char in party) {
				if (party[char].active_party) {
					size++;
				}
			}
			return size;
		}
		
		public static function active_party():Array {
			var _active_party:Array = new Array();
			for (var char in party) {
				if (party[char].active_party) {
					_active_party.push (char);
				}
			}
			return _active_party;
		}
		
		public static function avg_lvl(type:String):int {
			var _lvl:int = 0;
			var _i:int;
			for (var char in party) {
				if (party[char].active_party) {
					switch (type) {
						case "party":
							_lvl += party[char].lvl;
							_i++
							break;
						case "single":
							if (party[char].lvl > _lvl) {
								_lvl = party[char].lvl;
								_i = 1;
							}
					}
				}
			}
			return Math.round(_lvl/_i);
		}
		
		public static function members (id:int):Player {
			return party[id];
		}
		
		public function hp():int {
			var _hp:int;
			for (var char in party) {
				if (party[char].active_party) {
					_hp += party[char].hp;
				}
			}
			return _hp;
		}
		
		public function maxhp():int {
			var _hp:int;
			for (var char in party) {
				if (party[char].active_party) {
					_hp += party[char].hpmax;
				}
			}
			return _hp;
		}
		
		public static function add_player (char:Player):void {
			party.push (char);
			party[0].active_party = true;
		}
		
		public static function add_member (id:int, inParty:Boolean):void {
			var ally:Player = dbManager.Allies[id];
			if (size() < 3) {
				ally.active_party = inParty;
			}
			ally.add_avatar();
			party.push (ally);
		}
		
		public static function load_player (data:Object):void {
			party.push(dbManager.Allies[data.id]);
			var row:Player = party[party.length - 1];
			
			row.alias = data.alias;
			row.lvl = data.lvl;	
			row.active_party = data.active_party;
			
			row.a_hp = data.a_hp;
			row.HPMin = data.hp;
			row.a_mp = data.a_mp;
			row.MPMin = data.mp;
			
			row.a_str = data.a_str;
			row.a_spr = data.a_spr;
			row.a_dex = data.a_dex;
			row.a_vit = data.a_vit;
			row.a_wisdom = data.a_wisdom;
			
			row.gear.add_gear("A|"+data.helm);
			row.gear.add_gear("A|"+data.chest);
			row.gear.add_gear("A|"+data.gloves);
			row.gear.add_gear("A|"+data.boots)
			
		}
	}
}
	
