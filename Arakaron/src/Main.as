package{
	import com.arakaron.Arakaron;
	import com.arakaron.GUI.TxtFields;
	import com.arakaron.dbManager;
	import com.arakaron.mapManager2;
	import com.arakaron.sqlManager;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.system.Capabilities;
	import flash.text.TextField;
	
	[SWF(frameRate="48")]
	
	public class Main extends MovieClip {
		public var main_game:Arakaron;
		
		public static var StageHeight:int = 540;
		public static var StageWidth:int = 960;
		
		public static var isAndroid:Boolean = false;
		
		public var loader_box:Sprite;
		public var loader_border:Sprite;
		public var loader_text:TextField;
		public var stat_text:TextField;

		public var loadMax:int;
		private var loadIndex:Number = 0;
		private var loadTick:Number;
		
		public function Main() {
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color = 0x000000;
			stage.stageFocusRect = false;
			
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);

			if (Capabilities.cpuArchitecture == "ARM") {
				isAndroid = true;
			}
			
			var guiSize:Rectangle = new Rectangle(0, 0, StageWidth, StageHeight);
			var deviceSize:Rectangle = new Rectangle(0, 0,
				Math.max(stage.fullScreenWidth, stage.fullScreenHeight),
				Math.min(stage.fullScreenWidth, stage.fullScreenHeight));
			
			var appScale:Number = 1;
			var appSize:Rectangle = guiSize.clone();
			var appLeftOffset:Number = 0;
			
			// if device is wider than GUI's aspect ratio, height determines scale
			if ((deviceSize.width/deviceSize.height) > (guiSize.width/guiSize.height)) {
				appScale = deviceSize.height / guiSize.height;
				appSize.width = deviceSize.width / appScale;
				appLeftOffset = Math.round((appSize.width - guiSize.width) / 2);
			} 
				// if device is taller than GUI's aspect ratio, width determines scale
			else {
				appScale = deviceSize.width / guiSize.width;
				appSize.height = deviceSize.height / appScale;
				appLeftOffset = 0;
			}
			
			this.scaleX = appScale;
			this.scaleY = appScale;
			
			load_gui();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
		}
		
		private function onAddedtoStage(e:Event):void {
			this.stat_text.text = "Loading Maps.";
			
			mapManager2.addEventListener("mapTick", onTick);
			mapManager2.addEventListener("baseTick", onTick);
			mapManager2.addEventListener("canopyTick", onTick);
			mapManager2.addEventListener("mapFinishTick", onTick);
			mapManager2.setLoadMap();
			
			dbManager.addEventListener("fullTick",onTick);
			dbManager.setDBLoad();
			
		//	loadMax = mapManager2.mapLength + dbManager.loadArray.length;
		//	this.loadTick = Math.round(100 * 400/loadMax)/100;

			//mapManager.startLoadMap();
		}
		
		private function onTick (e:Event):void {
			if (e.type == "mapFinishTick") {
				this.stat_text.appendText("\n");
				dbManager.startDBLoad();
			} else {				
				switch (e.type) {
					case "mapTick":
						this.stat_text.appendText(".");
						this.loadIndex += 0.34;
						break;
					case "canopyTick":
						trace ("Canopy Tick");
						this.loadIndex += 0.33;
						break;
					case "baseTick":
						trace ("Base Tick");
						this.loadIndex += 0.33;
						break;
					case "fullTick":
						this.stat_text.appendText("Loading .\n");
						this.loadIndex++;
						break;
				}
				
				loadMax = mapManager2.mapLength + dbManager.loadArray.length;
				this.loadTick = Math.round(100 * 400/loadMax)/100;
				
				this.loader_box.width = this.loadTick * this.loadIndex;
				this.loader_text.text = String(Math.ceil(100 * this.loadIndex/this.loadMax))+"%"; 
				
				if (this.loadIndex == this.loadMax) {
					onPreloadComplete();
				}
			}	
		}
		
		private function onPreloadComplete():void{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedtoStage);

			this.removeChildren(0,this.numChildren-1);
			
			this.loader_border = null;
			this.loader_box = null;
			this.loader_text = null;
			this.stat_text = null;

			gotoAndStop("start");

			this.main_game = new Arakaron(this.stage);
			this.addChild(this.main_game);
			//this.stage.nativeWindow.addEventListener(Event.CLOSE,com.arakaron.sqlManager.onExit);
		}	
		
		//Load_Gui
		public function load_gui():void {
			this.stat_text = new TxtFields("Preloader",400,300,true, true);
			this.stat_text.x = Math.round((StageWidth - this.stat_text.width)/2);
			this.stat_text.y = (137) + 5;
			
			this.loader_box = new Sprite();
			this.loader_box.graphics.beginFill(0x0000FF);
			this.loader_box.graphics.drawRect(0,0,400,36);
			this.loader_box.graphics.endFill();
			this.loader_box.width = 0;
			this.loader_box.x = Math.round((StageWidth - 400)/2);
			this.loader_box.y = (this.stat_text.y + this.stat_text.height) + 5;			
			
			this.loader_border = new Sprite();
			this.loader_border.graphics.lineStyle(2,0xFFFFFF);
			this.loader_border.graphics.drawRect(0,0,402,38);
			this.loader_border.x = Math.round((StageWidth - this.loader_border.width)/2) + 1;
			this.loader_border.y = this.loader_box.y - 1;
			
			this.loader_text = new TxtFields("Preloader",300,30,true,false);
			this.loader_text.x = Math.round((StageWidth - this.loader_text.width)/2); 
			this.loader_text.y = this.loader_box.y + 1;
			this.loader_text.text = "0%";
			
			this.addChild(this.stat_text);
			this.addChild(this.loader_box);
			this.addChild(this.loader_border);
			this.addChild(this.loader_text);	
			
		}
		
	}
	
}