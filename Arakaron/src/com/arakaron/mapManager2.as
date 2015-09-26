package com.arakaron{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.SQLError;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class mapManager2{
		
		[Embed(source='com/arakaron/Assets/maps/Map - Listings.xml', mimeType="application/octet-stream")]
			public static const mapListing:Class;
		
		private static var GameDB:File = File.applicationDirectory.resolvePath("com/arakaron/Assets/Database/GameDB.db");	
		
		public static var Maps:Array = new Array();
		private static var tempMaps:Object = new Object();
		public static var mapLength:int;
		
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
			
		public static var connection:SQLConnection;
		private static var load_sql:int = -1;
		public static var load_state:SQLStatement;
		
		public function mapManager2(){
		}
		
		public static function setLoadMap():void {
			connection = new SQLConnection();
			
			connection.openAsync(GameDB);
			trace ("Loading GameDB Connection");
			connection.addEventListener(SQLEvent.OPEN, onOpen);
			
			load_state = new SQLStatement()
			load_state.sqlConnection = connection;
			load_state.addEventListener(SQLEvent.RESULT,onLoadComplete);
			load_state.addEventListener(SQLErrorEvent.ERROR,onError);
		}
		
		public static function onError(event:SQLErrorEvent):void {
			trace("Error message:", event.error.message); 
			trace("Details:", event.error.details); 
		}
		
		public static function onOpen(event:SQLEvent):void {
			connection.removeEventListener(SQLEvent.OPEN,onOpen);
			if (load_sql == -1) {
				load_state.text = "SELECT * FROM `mapInfo`";
			} else {
				mapInfo = tempMaps[load_sql].mapName;
				load_state.text = "SELECT * FROM `"+mapInfo+"`";
			}
			load_state.execute();	
		}
		
		public static function onLoadComplete(event:SQLEvent):void {
			var result:SQLResult = event.currentTarget.getResult();
			if (load_sql == -1){
				trace ("Loading Default Map Info");
				tempMaps = result.data;
				mapLength = result.data.length;				
				load_sql++;
			}else {
				trace ("Loading Specific Map Info");
				dispatchEvent("mapTick");
				Maps[mapInfo] = new LoadMap3(result.data, tempMaps[load_sql]);
				loadMapBase();
				loadMapCanopy();
				load_sql++;
			}
			if (load_sql >= mapLength) {
				dispatchEvent("mapFinishTick");
			}else {
				onOpen(null);
			}
		}
		
		private static function loadMapBase():void {	
			mapBaseLoader = new Loader();
			mapBaseLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadMapBaseComplete);
			
			mapBaseLoader.load(new URLRequest("com/arakaron/Assets/maps/"+mapInfo+".png"));
		}
		
		private static function loadMapCanopy():void {			
			mapCanopyLoader = new Loader();
			mapCanopyLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadMapCanopyComplete);
			
			mapCanopyLoader.load(new URLRequest("com/arakaron/Assets/maps/"+mapInfo+" - canopy.png"));
		}
		
		private static function loadMapBaseComplete(e:Event):void {
			trace ("Base Loaded");
			dispatchEvent("baseTick");
			
			baseIndex++;
			mapLoadIndex++;
			
			mapBase[mapInfo] = LoaderInfo(e.target).loader;
			Maps[mapInfo].map_base = LoaderInfo(e.target).loader;
		}
		
		private static function loadMapCanopyComplete(e:Event):void {
			trace ("Canopy Loaded");
			dispatchEvent("canopyTick");
			
			canopyIndex++;
			mapLoadIndex++;
			
			mapCanopy[canopyInfo] = LoaderInfo(e.target).loader;
			Maps[mapInfo].map_canopy = LoaderInfo(e.target).loader;
		}
		
		public static function addEventListener(type:String, listener:Function):void {
			dispatcher.addEventListener(type, listener);
		}
		
		public static function dispatchEvent (type:String):Boolean {
			return dispatcher.dispatchEvent(new Event(type,true));
		}
	}
}