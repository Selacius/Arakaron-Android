package com.arakaron {
	
	import com.arakaron.Tiles.Tile;
	import com.arakaron.DPad.*;
	import com.arakaron.GUI.Inventory;
	import com.arakaron.GUI.MiniWin;
	import com.arakaron.Helpers.Menus.EquipMenu;
	import com.arakaron.Helpers.Menus.MainMenu;
	import com.arakaron.Helpers.Menus.StatusMenu;
	import com.arakaron.MemoryTracker;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.desktop.NativeApplication;
	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	public class Arakaron extends Sprite{
		public var memorytrack:MemoryTracker = new MemoryTracker();
		
		public var assets:AssetManager;
		
		public var container:Sprite;
		
		public var menuCont:Sprite;
		public static var mainMenu:MainMenu;
		public static var statusMenu:StatusMenu;
		public static var equipMenu:EquipMenu;
		public static var itemMenu:Inventory;
		
		public var CharSelect:Char_select;
		
		public static var StageHeight:int;
		public static var StageWidth:int;
		public var Stage:DisplayObject;
		public static var gameRect:Sprite;
		
		public var D_Pad:DirecPad;
		
		public static var first_run:Boolean;
		
		public static var GameEvents:Array = new Array();
		public static var Gold:int = 150;
		public static var AlertWindow:MiniWin = new MiniWin();
		
		public var main_play:Player;
		public var curr_map:LoadMap3;
		public var map_index:String;
		public var hitTile;
		
		private var rtBrder:int;
		private var dnBrder:int;
		private var cntrX:int;
		private var cntrY:int;
		private var offsetX:int;
		private var offsetY:int;
		
		public var mapID:String;
		public var x_coord:int;
		public var y_coord:int;
		private var _vx:int;
		private var _vy:int;
		private var move:int;
		private var isMove:Boolean;
		
		public var connection:SQLConnection;
		public var load_sql:int = 0;
		public var load_state:SQLStatement;
		
		var frames:int=0;
		var prevTimer:Number=0;
		var curTimer:Number=0;
		
		public function Arakaron(stage2) {
			super();
			// support autoOrients
			
			StageHeight = Main.StageHeight;
			this.cntrY = 16 * (Math.ceil(StageHeight * 0.5 * 0.0625)) - 16;
			StageWidth = Main.StageWidth;
			this.cntrX = 16 * (Math.ceil(StageWidth * 0.5) * 0.0625) - 16;
			this.Stage = stage2;
			
			gameRect = new Sprite();
			gameRect.graphics.beginFill(0,0);
			gameRect.graphics.drawRect(0,0,StageWidth, StageHeight);
			gameRect.graphics.endFill();
			
			Game_Inventory.init();

			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	
		private function onAddedToStage (e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			
			sqlManager.init(this);
		}
		
		public function loadCharSelect():void {
			if (first_run) {
				this.CharSelect = new Char_select(this);
				this.addChild(this.CharSelect);
				this.CharSelect.addEventListener("COMPLETE",onCharSelect);
			} else {
				load_game(null);
			}
		}
		
		private function onCharSelect(e:Event):void {	
			Game_Party.add_player(this.CharSelect.char);

			this.removeChild(this.CharSelect);
			
			this.CharSelect.removeEventListener("COMPLETE",onCharSelect);
			
			sqlManager.insertSQL("characters",this.CharSelect.char);
			this.CharSelect = null;
			
			this.load_game(null);
		}
		
		public function load_game(e:Event):void {				
			this.main_play = Game_Party.members(0);
			this.main_play.add_avatar();
			this.main_play.avatar.add_tile();
			
			Game_Party.add_member(0, true);
			Game_Party.add_member(1, true);
			Game_Party.add_member(0, true);
			
			this.main_play.x = this.cntrX;
			this.main_play.y = this.cntrY;
			this.curr_map = mapManager2.Maps["elf-zone3"];
			
			Game_Inventory.addInvent("A|1",1,false);
			Game_Inventory.addInvent("A|2",1,false);
			Game_Inventory.addInvent("A|8",1,false);
			Game_Inventory.addInvent("A|4",1,false);
			Game_Inventory.addInvent("A|5",1,false);
			Game_Inventory.addInvent("A|6",1,false);
			Game_Inventory.addInvent("A|7",1,false);
			
			this.container = new Sprite();
			this.menuCont = new Sprite();
			
			//this.mapSwitch("elf-zone2",31,50);
			
			this.container.addChildAt(this.curr_map,0);		
			this.container.addChildAt(this.main_play,1);
			this.container.addChildAt(this.curr_map.map_canopy,2);
			this.addChild(this.container);
			
			this.addChild(gameRect);
			
			this.rtBrder = StageWidth - this.curr_map.width + 4;
			this.dnBrder = StageHeight - this.curr_map.height + 4;
			
			mapset (31,50);
			
			this.addChild(AlertWindow);
			
			this.D_Pad = new DirecPad;
			
			this.addChild(this.D_Pad);
			stage.focus = this.D_Pad;
			
			this.addChild(this.menuCont);
			
			mainMenu = new MainMenu();
			this.menuCont.addChild(mainMenu);
			
			statusMenu = new StatusMenu();
			this.menuCont.addChild(statusMenu);
			
			equipMenu = new EquipMenu();
			this.menuCont.addChild(equipMenu);
			
			itemMenu = new Inventory();
			this.menuCont.addChild(itemMenu);
			
			this.D_Pad._dPad.leftPad.addEventListener(DPadEvent.TOUCH_PRESS, touchPressHandler);
			this.D_Pad._dPad.leftPad.addEventListener(DPadEvent.TOUCH_RELEASE, touchReleaseHandler);
			this.D_Pad._dPad.rightPad.addEventListener(DPadEvent.TOUCH_PRESS_A, touchPressAHandler);
			this.D_Pad._dPad.rightPad.addEventListener(DPadEvent.TOUCH_PRESS_B, touchPressBHandler);
			
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		public function onEnterFrame(event:Event):void {	
			this.drawAnimations();
			movescreen(1);
			
			for (this.map_index in this.curr_map.Barrier) {
				this.hitTile = this.curr_map.Barrier[this.map_index];
				if (this.hitTile.Interact) {
					if (this.main_play.hitArea.hitTestObject(this.hitTile.InteractHitArea)) {
						//trace ("Hitting");
						switch (this.hitTile.caste) {
							case "Exit":
								this.mapSwitch(this.hitTile.map_id, this.hitTile.map_x,this.hitTile.map_y);
								break;
							default:
								this.hitTile.onTouch();
								break;
						}
						break;
					}
				}
			}
			for (this.map_index in this.curr_map.Barrier) {
				if (this.main_play.hitArea.hitTestObject(this.curr_map.Barrier[this.map_index].ImmoveHitArea)) {
					trace ("hit");
					movescreen(-1);
					this._vx = 0;
					this._vy = 0;
					break;
				}
			}
			
			//performFPSTest();
		}

		private function performFPSTest():void {
			frames+=1;
			curTimer=getTimer();
			if(curTimer-prevTimer>=1000){
				trace("FPS: "); trace(Math.round(frames*1000/(curTimer-prevTimer)));
				prevTimer=curTimer;
				frames=0;
			}
		}
		
		public function drawAnimations():void {			
			if (AlertWindow.visible) {
				AlertWindow.EnterFrame();
			}
			for (var index in this.curr_map.Animations) {
				if (gameRect.hitTestObject(this.curr_map.Animations[index].ImmoveHitArea)) {
					//this.curr_map.Animations[index].onEnterFrame(null);
				}
			}
		}
		
		private function touchPressHandler(event:DPadEvent):void{
			var axisPad:AxisPad = event.target as AxisPad;
			if (!mainMenu.visible) {
				this.isMove = true;
				switch (axisPad.value) {
					case 2:
						//Left
						this._vx = 2;
						this._vy = 0;
						this.move = 1;
						break;
					case 4:
						//Right
						this._vx = -2;
						this._vy = 0;
						this.move = 2;
						break;
					case 8:
						//Up
						this._vx = 0;
						this._vy = 2;
						this.move = 3;
						break;
					case 16:
						//Down
						this._vx = 0;
						this._vy = -2;
						this.move = 0;
						break;
				}
			}
		}
		
		private function touchReleaseHandler(event:DPadEvent):void{
			this.isMove = false;
			this._vx = 0;
			this._vy = 0;
		}
		
		private function touchPressAHandler(event:DPadEvent):void{
			if (!mainMenu.visible) {
				for (var index in this.curr_map.Barrier) {
					if (this.curr_map.Barrier[index].Interact) {
						if (this.main_play.hitArea.hitTestObject(this.curr_map.Barrier[index].InteractHitArea)){
							this.curr_map.Barrier[index].onInteract();
						}
					}
				}
			}else {
			}
		}
		private function touchPressBHandler(event:DPadEvent):void{
			if (!mainMenu.visible) {
				mainMenu.onAddedToStage();
			} else { 
				deleteDB();
			}
		}		
		
		public function deleteDB():void {
			trace ("Deleting DB");
			sqlManager.onExit(null);
		}
		
		public function mapSwitch(mapID:String, mapX:int, mapY:int):void {
			if (mapManager.Maps[mapID] == undefined) {
				AlertWindow.updateWin("Unfortunately this map is not yet available.", true);
			} else {
				if (this.container.numChildren > 0) {
					this.container.removeChildren(0,this.container.numChildren-1);
				}
				
				//this.curr_map = new LoadMap2(mapManager.Maps[mapID]);
				this.curr_map = mapManager.Maps[mapID];
				
				this.container.addChildAt(this.curr_map,0);		
				this.container.addChildAt(this.main_play,1);
				this.container.addChildAt(this.curr_map.map_canopy,2);
				
				this.rtBrder = StageWidth - this.curr_map.width + 4;
				this.dnBrder = StageHeight - this.curr_map.height - 4;
				
				this.mapset(mapX,mapY);
			}
		}
		
		private function movescreen (direc:int):void {
			this.main_play.avatar.move_tile(move,isMove);
			this._vx *= direc;
			this._vy *= direc;
			if (this._vx < 0) {
				if (this.curr_map.x > this.rtBrder) {
					if (this.main_play.x < this.cntrX) {
						this.main_play.x -= this._vx;
					} else {
						this.curr_map.x += this._vx;
						this.curr_map.map_canopy.x += this._vx;
					}
				} else if (this.curr_map.x <= this.rtBrder) {
					if (this.main_play.x < (StageWidth - 32)) {
						this.main_play.x -= this._vx;
					}
				}
			} else if (this._vx > 0){ 
				if (this.curr_map.x < 0) {
					if (this.main_play.x > this.cntrX) {
						this.main_play.x -= this._vx;
					}else {
						this.curr_map.x += this._vx;
						this.curr_map.map_canopy.x += this._vx;
					}
				}else {
					if (this.main_play.x > 0) {
						this.main_play.x -= this._vx;
					}
				}
			}
			
			if (this._vy < 0) {
				if (this.curr_map.y > this.dnBrder) {
					if (this.main_play.y < this.cntrY) {
						this.main_play.y -= this._vy;
					} else {
						this.curr_map.y += this._vy;
						this.curr_map.map_canopy.y += this._vy;
					}
				} else if (this.curr_map.y <= this.dnBrder) {
					if (this.main_play.y < (StageHeight - 32)) {
						this.main_play.y -= this._vy;
					}
				}
			} else if (this._vy > 0) {
				if (this.curr_map.y < 0) {
					if (this.main_play.y > this.cntrY) {
						this.main_play.y -= this._vy;
					} else {
						this.curr_map.y += this._vy;
						this.curr_map.map_canopy.y += this._vy;
					}
				} else {
					if (this.main_play.y > 0) {
						this.main_play.y -= this._vy;
					}
				}
			}
		}
		
		private function mapset (xx:int, yy:int):void {
			if (this.curr_map.width <= StageWidth) {
				this.offsetX = Math.round((this.curr_map.width - StageWidth)/2);
				this.curr_map.x = -this.offsetX;
				this.curr_map.map_canopy.x = -this.offsetX;
				this.main_play.x = (xx * 16) - this.offsetX;
			} else {
				if (((this.curr_map.width - (xx * 16) - 32)) < (StageWidth * 0.5)) {
					this.offsetX = StageWidth - this.curr_map.width;
					this.curr_map.x = this.offsetX;
					this.curr_map.map_canopy.x = this.offsetX;
					this.main_play.x = Math.ceil((this.offsetX + (xx * 16))/16) * 16 - 2;
				}else if ((xx * 16) < (StageWidth * 0.5)) {
					this.offsetX = 0;
					this.curr_map.x = this.offsetX;
					this.curr_map.map_canopy.x = this.offsetX;
					this.main_play.x = (xx * 16);
				} else {
					this.offsetX = this.cntrX - (xx * 16);
					this.curr_map.x = this.offsetX;
					this.curr_map.map_canopy.x = this.offsetX;
				}
			}
			if (this.curr_map.height <= StageHeight) {
				this.offsetY = Math.round((this.curr_map.height - StageHeight)/2);
				this.curr_map.y = -this.offsetY;
				this.curr_map.map_canopy.y = -this.offsetY;
				this.main_play.y = (yy * 16) - this.offsetY;
			}else {
				if (((this.curr_map.height - (yy * 16) - 32)) < ((StageHeight * 0.5))) {
					this.offsetY = StageHeight - this.curr_map.height + 16;
					this.curr_map.y = this.offsetY;
					this.curr_map.map_canopy.y = this.offsetY;
					this.main_play.y = Math.ceil(((StageHeight * 0.5) + this.curr_map.height - (yy * 16) - 48)/16) * 16 - 2;
				} else if ((((yy * 16) - 32)) < (StageHeight * 0.5)) {
					this.offsetY = 0;
					this.curr_map.y = this.offsetY;
					this.curr_map.map_canopy.y = this.offsetY;
					this.main_play.y = (yy * 16);
				} else {
					this.offsetY = this.cntrY - (yy * 16);
					this.curr_map.y = this.offsetY;
					this.curr_map.map_canopy.y = this.offsetY;
				}
			}
		}
	}
	
}