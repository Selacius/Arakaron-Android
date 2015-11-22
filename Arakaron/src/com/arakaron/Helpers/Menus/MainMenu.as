package com.arakaron.Helpers.Menus{
	import com.arakaron.Arakaron;
	import com.arakaron.AssetManager;
	import com.arakaron.Game_Party;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.*;
	import com.arakaron.GUI.CharDisplay;
	import com.arakaron.GUI.MenuBox;
	import com.arakaron.GUI.MenuGUI;
	import com.arakaron.GUI.textButton;
	
	public class MainMenu extends Sprite implements MenuGUI{
		private var gui:MenuBox;
		
		public var menuOptsText:Array = new Array("Items","Quests","Goals");
		public var menuOpts:Array = new Array();		
		
		public var charOpts:Array = new Array();
		public var charIndex:int;

		public function MainMenu(){
			super();
			this.visible = false;
		}
		
		public function onAddedToStage():void {
			this.visible = true;
			drawGUI();
			this.x = (Arakaron.StageWidth - this.width)/2;
			this.y = (Arakaron.StageHeight - this.height)/2;
		}
		
		public function onRemovedFromStage():void {
			this.visible = false;
			
			this.removeChildren(0,this.numChildren-1);
			for (var i:int = 0; i<this.menuOptsText.length; i++) {
				this.menuOpts[i].destructor();
				this.menuOpts[i] = null;
			}
			for (i = 0; i<Game_Party.active_party().length; i++) {
				this.charOpts[i] = null;
			}
			
			this.gui.exitBtn = null;
			this.gui = null;
		}
		
		public function drawGUI():void {
			this.gui = new MenuBox(0,0,500, 523, 0.5);
			this.addChild(this.gui);			
			this.gui.exitBtn.addEventListener(MouseEvent.CLICK,onExitClick);
			
			for (var i:int = 0; i<this.menuOptsText.length; i++) {
				this.menuOpts[i] = new textButton(this,<text size="medium">{this.menuOptsText[i]}</text>);
				this.menuOpts[i].x = (151 * i) + 71;
				this.menuOpts[i].y = 35;
				this.addChild(this.menuOpts[i]);
				this.menuOpts[i].addEventListener(MouseEvent.CLICK,onMenuClick);
			}
			
			for (i = 0; i<Game_Party.active_party().length; i++) {
				this.charOpts[i] = new CharDisplay(i,true, false);
				this.charOpts[i].onAddedToStage();
				this.charOpts[i].reDrawVals();
				this.charOpts[i].x = (523 - this.charOpts[i].width) * 0.5;
				this.charOpts[i].y = (102 * i) + 75;
				this.addChild(this.charOpts[i]);
				this.charOpts[i].statusIcon.addEventListener(MouseEvent.CLICK,onStatusClick);
				this.charOpts[i].gearIcon.addEventListener(MouseEvent.CLICK,onGearClick);
				this.charOpts[i].skillIcon.addEventListener(MouseEvent.CLICK,onSkillClick);
				this.charOpts[i].talentIcon.addEventListener(MouseEvent.CLICK,onTalentClick);
			}
		}
		
		public function onExitClick(e:MouseEvent):void{
			trace ("Exit Click");
			this.onRemovedFromStage();
		}
		
		public function onMenuClick(e:MouseEvent):void {
			this.onRemovedFromStage();
			
			Arakaron.itemMenu.onAddedToStage();
		}
		
		private function onStatusClick(e:MouseEvent):void {
			this.onRemovedFromStage();
			
			Arakaron.statusMenu.membID = e.target.parent.charID;
			Arakaron.statusMenu.onAddedToStage();
		}
		
		private function onGearClick(e:MouseEvent):void {
			trace ("Gear Icon Click"); 
			this.onRemovedFromStage();
			
			Arakaron.equipMenu.membID = e.target.parent.charID;
			Arakaron.equipMenu.onAddedToStage();
		}
		
		private function onSkillClick(e:MouseEvent):void {
			trace ("Skill Icon Click");
		}
		
		private function onTalentClick(e:MouseEvent):void {
			trace ("Talent Icon Click");
		}
	}
}