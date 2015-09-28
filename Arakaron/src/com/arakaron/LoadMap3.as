package com.arakaron{
	import com.arakaron.Tiles.*;
	import com.arakaron.mapManager2;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LoadMap3 extends Sprite{
		public var mapName:String;
		private var mapWidth:int;
		private var mapType:String = "Map";
		public var mapVers:int;
		
		public var map_base:Loader;
		public var map_canopy:Loader;
		
		private var mapObs:Object;
		private var immovable:XMLList;
		private var collidable:XMLList;
		
		private var index:String;
		private var tiles:Tile;
		
		public var NPCs:Array = new Array();
		public var Barrier:Array = new Array();
		public var Interact:Array = new Array();
		public var Animations:Array = new Array();
		public var Regions:Array = new Array();
		public var Event_Lists:Array = new Array();
		
		public function LoadMap3(map:Object, mapData:Object){
			super();
			
			this.mapObs = map;
			
			this.mapName = mapData.mapName;
			this.mapWidth = (mapData.mapWidth * 16);
			this.mapVers = mapData.mapVersion;			
			
			for each (var val:Object in this.mapObs) {
				switch (val.tileAlias) {
					case "Immove":
						this.tiles = new Immove2(val.tileX,val.tileY,val.tileWidth,val.tileHeight);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "Chest":
						this.tiles = new Chest(this.mapName, val);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "Exit":
						this.tiles = new Exit(val);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "Switch":
						this.tiles = new Switch(this, val);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "Ore":
						this.tiles = new Ore(val);
						this.Barrier[this.Barrier.length] = this.tiles;
						this.Animations[this.Animations.length] = this.tiles
						break;
					case "Block":
						this.tiles = new Block(this.mapName, val);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "Sign":
						this.tiles = new Sign(val);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "Animation":
						this.tiles = new Animation(val);
						this.Barrier[this.Barrier.length] = this.tiles;
						this.Animations[this.Animations.length] = this.tiles;
						break;
					case "Door":
						this.tiles = new Door(this.mapName, val);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "Sign":
						this.tiles = new Sign(val);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
				}
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedtoStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedtoStage(e:Event):void {
			this.addChild(this.map_base);
			
			for (index in this.Barrier) {
				this.addChild(this.Barrier[index]);
				this.Barrier[index].onAddedtoStage();
				if (this.Barrier[index].Interact) {
					this.Barrier[index].checkSwitches();
				}
			}
		}
		
		private function onRemovedFromStage(e:Event):void {
			this.removeChild(this.map_base);
			
			for (index in this.Barrier) {
				this.removeChild(this.Barrier[index]);
				this.Barrier[index].onRemovedFromStage();
			}
		}
		
		public function drawAnimations():void {
			for (index in this.Animations) {
				this.Animations[index].onEnterFrame(null);
			}
		}
		
		public function triggerEvents():void {
			trace ("Triggering Events");
			for (index in this.Barrier) {
				if (this.Barrier[index].Interact) {
					this.Barrier[index].checkSwitches();	
				}
			}
		}
	}
}