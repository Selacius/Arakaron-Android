package com.arakaron{
	import com.arakaron.GUI.TxtFields;
	import com.arakaron.GUI.WindowBox;
	import com.arakaron.GUI.textButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import com.arakaron.Helpers.Avatar;

	import flash.system.*;
	
	public class Char_select extends Sprite{
		private var main_class:Arakaron;
		
		private var avatar:Array = new Array();
		
		public var StageWidth:int;
		public var StageHeight:int;
		
		public var char:Player;
		
		private var msg_info:TextField;				
		
		private var char_info:TextField;
		private var char_info1:TextField;
		private var char_info2:TextField;
		
		private var char_str:Array;
		
		private var select_btn:textButton;
		
		private var i:int;
		
		public function Char_select(ref_class:Arakaron){
			this.main_class = ref_class;
			
			this.StageHeight = Arakaron.StageHeight;
			this.StageWidth = Arakaron.StageWidth;
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedtoStage);
		}
		
		public function onAddedtoStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedtoStage);
			load_gui();
			
			for (i = 0; i<3; i++) {
				this.avatar[i] = new Avatar(i);
				this.avatar[i].add_face();
				this.addChild(this.avatar[i]);
				this.avatar[i].x = 15;
				this.avatar[i].y = this.char_info.y + 67 + (100*i);
				this.avatar[i].addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		private function onClick (e:Event):void {
			if (!e.target.border) {
				var id:int = this.avatar.indexOf(e.target);
				this.char = dbManager.Allies[id];
				
				e.target.face_border();
				
				for (i = 0; i<3; i++) {
					if (i != id) {
						this.avatar[i].clear_border();
					}
				}
				
				this.char_str = new Array(char.alias
					+'\n<font color="#00CED1">'+char.race+' '+char.caste+'</font>'
					+"\nLorem ipsum dolor sit amet, utinam oporteat moderatius quo ut, eruditi consetetur reformidans et usu, his ex modo facilisis constituam. Vis cu posse cotidieque, qui atqui mazim nobis eu, ne case vituperata cotidieque sit. Et duo sale libris malorum. Ius ad agam laoreet consequuntur. Blandit eleifend et nec, viderer saperet has an. His ei magna volumus. Nec eu euismod dolores epicurei, mea.",
					
					'<font color="#00CED1">Health:</font> '+char.HPMax
					+'\n<font color="#00CED1">Mana:</font> '+char.MPMax
					
					+'\n\n<font color="#00CED1">Strength:</font>  '+char.Str
					+'\n<font color="#00CED1">Agility:</font>  '+char.Agi
					+'\n<font color="#00CED1">Dexterity:</font>  '+char.Dex
					+'\n<font color="#00CED1">Vitality:</font>  '+char.Vit
					+'\n<font color="#00CED1">Wisdom:</font>  '+char.Wisdom
					+'\n<font color="#00CED1">Spirit:</font>  '+char.Spr
					
					+'\n\n<font color="#00CED1">Attack (P/M/R):</font>  '+char.Atk("Physical")+'/'+char.Atk("Magic")+'/'+char.Atk("Ranged")
					+'\n<font color="#00CED1">Attack %:</font>  '+char.AtkP
					+'\n<font color="#00CED1">Defense (P/M):</font>  '+char.Def("Physical")+'/'+char.Def("Magic")
					+'\n<font color="#00CED1">Defense %:</font>  '+char.DefP("Physical")+"/"+char.DefP("Magic"),
					
					'<font color="#00CED1">Main-Hand:</font>  '+char.gear.displayGear("W","MHand","alias")
					+'\n<font color="#00CED1">Off-Hand:</font>  '+char.gear.displayGear("W","OHand","alias")
					+'\n\n<font color="#00CED1">Helmet:</font>  '+char.gear.displayGear("A","Helmet","alias")
					+'\n<font color="#00CED1">Chest:</font>  '+char.gear.displayGear("A","Chest","alias")
					+'\n<font color="#00CED1">Gloves:</font>  '+char.gear.displayGear("A","Gloves","alias")
					+'\n<font color="#00CED1">Legs:</font>  '+char.gear.displayGear("A","Pants","alias")
					+'\n<font color="#00CED1">Boots:</font>  '+char.gear.displayGear("A","Boots","alias")
					+'\n<font color="#00CED1">Accessory 1:</font>  '+char.AtkP
					+'\n<font color="#00CED1">Accessory 2:</font>  '+char.AtkP);
				this.char_info.htmlText = this.char_str[0];
				this.char_info1.htmlText = this.char_str[1];
				this.char_info2.htmlText = this.char_str[2];
			}
		}
		
		public function onBtnClick(e:MouseEvent):void {
			if (char != null) {
				this.select_btn.removeEventListener(MouseEvent.CLICK,onBtnClick);
				
				this.avatar[0].removeEventListener(MouseEvent.CLICK,onClick);
				this.avatar[1].removeEventListener(MouseEvent.CLICK,onClick);
				this.avatar[2].removeEventListener(MouseEvent.CLICK,onClick);
				
				this.avatar = null;
				
				this.removeChildren(0,this.numChildren-1);

				this.msg_info = null;
				this.char_info = null;
				this.char_info1 = null;
				this.char_info2 = null;
				this.select_btn = null;
				
				this.StageHeight = 0;
				this.StageWidth = 0
				
				this.main_class = null;
				this.dispatchEvent(new Event("COMPLETE",true));
			}
		}
		
		private function load_gui():void {
			this.addChild(new WindowBox(0,0,540, 960, 1.0));
			
			this.msg_info = new TxtFields("DisplayName",960,25,false, false)
			this.msg_info.x = 0;
			this.msg_info.y = 15;
			this.addChild(this.msg_info);
			
			this.msg_info.text = "Please select which character you'd like to start with.";
			
			this.char_info = new TxtFields("Menu",240,430,true,true);
			this.char_info.x = 120;
			this.char_info.y = this.msg_info.height + 25;
			this.addChild(this.char_info);
			
			this.char_info1 = new TxtFields("Menu",240,430,true,true);
			this.char_info1.x = this.char_info.x + this.char_info.width;
			this.char_info1.y = this.msg_info.height + 25;
			this.addChild(this.char_info1);
			
			this.char_info2 = new TxtFields("Menu",240,430,true,true);
			this.char_info2.x = this.char_info1.x + this.char_info1.width;
			this.char_info2.y = this.msg_info.height + 25;
			this.addChild(this.char_info2);
		
			this.select_btn = new textButton(this,<text size="medium">Select Character</text>);
			this.select_btn.x = Math.round((this.StageWidth - this.select_btn.width)/2);
			this.select_btn.y = this.char_info.height + 57;
			this.select_btn.addEventListener(MouseEvent.CLICK,onBtnClick,false,0,true);
			this.addChild(this.select_btn);
		}
	}
}