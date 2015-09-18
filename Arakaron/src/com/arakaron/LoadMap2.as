package com.arakaron{
	import com.arakaron.Assets.Tiles.Animation;
	import com.arakaron.Assets.Tiles.Block;
	import com.arakaron.Assets.Tiles.Chest;
	import com.arakaron.Assets.Tiles.Door;
	import com.arakaron.Assets.Tiles.Exit;
	import com.arakaron.Assets.Tiles.Immove;
	import com.arakaron.Assets.Tiles.Immove2;
	import com.arakaron.Assets.Tiles.Ore;
	import com.arakaron.Assets.Tiles.Sign;
	import com.arakaron.Assets.Tiles.Switch;
	import com.arakaron.Assets.Tiles.Tile;
	import com.arakaron.mapManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osmf.net.StreamingURLResource;
	
	public class LoadMap2 extends Sprite{
		public var alias:String;
		private var map_width:int;
		
		public var map_base:Loader;
		public var map_canopy:Loader;
		
		private var map_XML:XML
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
		
		public function LoadMap2(map:XML){
			super();
		
			this.map_XML = map;
			
			this.alias = this.map_XML.properties.property.(attribute('name') == 'alias').@value;
			this.map_width = this.map_XML.attribute('width');		
			
			this.immovable = this.map_XML.objectgroup.(@name == "Immovable").object;
			var yy:int;
			var xx:int;
			
			for each (var xmldoc:XML in this.immovable){
				this.tiles = new Immove2(xmldoc.@x, xmldoc.@y, xmldoc.@width, xmldoc.@height);
				this.Barrier[this.Barrier.length] = this.tiles;
			}
			
			this.collidable = this.map_XML.objectgroup.(@name == "Collidable").object;
			var type:String;

			for each (var xmldoc:XML in this.collidable){
				type = xmldoc.@name;
				switch (type) {
					case "chest":
						this.tiles = new Chest(this.alias, xmldoc);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "exit":
						this.tiles = new Exit(xmldoc);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "animation":
						this.tiles = new Animation(xmldoc.@x,xmldoc.@y,xmldoc.properties.property[0].@value,xmldoc.@type);
						this.Barrier[this.Barrier.length] = this.tiles;
						this.Animations[this.Animations.length] = this.tiles;
						break;
					case "switch":
						this.tiles = new Switch(this, xmldoc);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "block":
						this.tiles = new Block(this.alias, xmldoc);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "door":
						this.tiles = new Door(this.alias, xmldoc);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
					case "ore":
						this.tiles = new Ore(xmldoc);
						this.Barrier[this.Barrier.length] = this.tiles;
						this.Animations[this.Animations.length] = this.tiles
						break;
					case "sign":
						this.tiles = new Sign(xmldoc);
						this.Barrier[this.Barrier.length] = this.tiles;
						break;
				}
			}
			
			trace (this.alias+" Animations: "+this.Animations.length);
			
			this.tiles = null;
			
			this.map_XML = null;
			this.immovable = null;
			this.collidable = null;		
			
			//this.map_base = mapManager.mapBase[this.alias];
			//this.map_canopy = mapManager.mapCanopy[this.alias];
			
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