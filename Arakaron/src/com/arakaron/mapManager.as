package com.arakaron{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class mapManager{
		
		[Embed(source='com/arakaron/Assets/maps/Map - Listings.xml', mimeType="application/octet-stream")]
			public static const mapListing:Class;
		
		public static var Maps:Array = new Array();
		
		public static var mapArray:Array = new Array();
		private static var mapDataLoader:URLLoader;
		private static var mapInfo:String;
		private static var mapIndex:int;
		
		public static var mapBase:Array = new Array();
		private static var mapBaseLoader:Loader;
		private static var baseInfo:String;
		private static var baseIndex:int;
		
		public static var mapCanopy:Array = new Array();
		private static var mapCanopyLoader:Loader;
		private static var canopyInfo:String;
		private static var canopyIndex:int;
		
		private static var mapLoadIndex:int;
		private static var dispatcher:EventDispatcher = new EventDispatcher();
			
		public function mapManager(){
		}
		
		public static function setLoadMap():void {
			var maps:XML = new XML (new mapListing());
			
			for (var map:String in maps.maps.map) {
				mapArray.push(maps.maps.map[map]);
			}
		}
		
		public static function startLoadMap():void {
			loadMapData();
			loadMapBase();
			loadMapCanopy();
		}
		
		private static function loadMapData():void {
			mapDataLoader = new URLLoader();
			mapDataLoader.addEventListener(Event.COMPLETE,loadMapDataComplete);
			
			mapInfo = mapArray[mapIndex];
			mapDataLoader.load(new URLRequest("com/arakaron/Assets/maps/"+mapInfo+".tmx"));
		}
		
		private static function loadMapBase():void {	
			mapBaseLoader = new Loader();
			mapBaseLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadMapBaseComplete);
			
			baseInfo = mapArray[baseIndex];
			mapBaseLoader.load(new URLRequest("com/arakaron/Assets/maps/"+baseInfo+".png"));
		}
		
		private static function loadMapCanopy():void {			
			mapCanopyLoader = new Loader();
			mapCanopyLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadMapCanopyComplete);
			
			canopyInfo = mapArray[canopyIndex];
			mapCanopyLoader.load(new URLRequest("com/arakaron/Assets/maps/"+canopyInfo+" - canopy.png"));
		}
		
		private static function loadMapDataComplete (e:Event):void {
			dispatchEvent("mapTick");
			
			mapIndex++;
			
			mapLoadIndex++;
			
			var xmlDoc:XML = new XML(e.target.data);
			var mapAlias:String = xmlDoc.properties.property.(attribute('name') == 'alias').@value;
			
			//Maps[mapAlias] = xmlDoc;
			Maps[mapAlias] = new LoadMap2(xmlDoc);
			
			if (mapIndex < mapArray.length) {
				loadMapData();
			} else {
				dispatchEvent("mapFinishTick");
			}
		}
		
		private static function loadMapBaseComplete(e:Event):void {
			dispatchEvent("baseTick");
			
			baseIndex++;
			mapLoadIndex++;
			
			mapBase[baseInfo] = LoaderInfo(e.target).loader;
			Maps[baseInfo].map_base = LoaderInfo(e.target).loader;
			if (baseIndex < mapArray.length) {
				loadMapBase();
			}
		}
		
		private static function loadMapCanopyComplete(e:Event):void {
			dispatchEvent("canopyTick");
			
			canopyIndex++;
			mapLoadIndex++;
			
			mapCanopy[canopyInfo] = LoaderInfo(e.target).loader;
			Maps[canopyInfo].map_canopy = LoaderInfo(e.target).loader;
			if (canopyIndex < mapArray.length) {
				loadMapCanopy();
			} 			
		}
		
		public static function addEventListener(type:String, listener:Function):void {
			dispatcher.addEventListener(type, listener);
		}
		
		public static function dispatchEvent (type:String):Boolean {
			return dispatcher.dispatchEvent(new Event(type,true));
		}
	}
}