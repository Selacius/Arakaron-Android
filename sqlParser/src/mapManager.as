package{
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	public class mapManager extends Sprite{
		[Embed(source="Assets/Button-UP.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTN_UP:Class;
		[Embed(source="Assets/Button-DOWN.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTN_DOWN:Class;
		
		protected static const data:XML = <data/>
			
		public static const MAP_VIEW:XML = <horizontal alignH="left" alignV="top" width="250">
				<list id="maplist" colour="#333366"  gapV="0">{data}<label id="label"><font size="20"/></label></list>		
				<vertical>
					<horizontal><label><b>Map Name:</b></label><label id="name" width="200"></label></horizontal>
					<horizontal>
						<label>SQL Version:</label><label id="sqlversion" width="100"></label>
						<label>TMX Version:</label><label id="tmxversion" width="100"></label>
					</horizontal>			
					<horizontal><label id="tmx" width="200">TMX File Present:</label><label id="sql" width="200">SQL Data Exists:</label></horizontal>
					<horizontal><label id="canopy" width="200">Canopy PNG Present:</label><label id="base" width="200">Base PNG Present:</label></horizontal>
					<horizontal><button id="parse" clickable="true" visible="false" skin={getQualifiedClassName(BTN_UP)}>Parse Map Data</button><button id="reparse" clickable="true" visible="false" skin={getQualifiedClassName(BTN_UP)}>Re-Parse Map Data</button></horizontal>
					<horizontal><label id="complete">Parse Status:</label></horizontal>
					<horizontal><list id="obslist" colour="#333366" gapV="0" width="240">{data}<label id="label2"/></list></horizontal>
				</vertical>
			</horizontal>;
		
		public static var _list:UIList;
		public static var _list2:UIList;
		protected var _blah:UITouch;
		
		private static var _mName:UILabel;
		private static var _tmxFile:UILabel;
		private static var _sqlData:UILabel;
		private static var _canopyPNG:UILabel;
		private static var _basePNG:UILabel;
		private static var _sqlVers:UILabel;
		private static var _tmxVers:UILabel;
		public static var _complete:UILabel;
		private static var _parseBTN:UIButton;
		private static var _reparseBTN:UIButton;
		
		private static var mapArray:Array;
		private static var mapXML:XML;
		private static var loadXML:URLLoader;
		private static var filesRDY:int;
		private static var mapInfo:Object;
		private static var mapObs:Object;
		private static var mapImmove:Object;
		
		public function mapManager(){
			super();
		}
		
		public static function onDisplay(e:Event):void{
			var _file:File = File.documentsDirectory.resolvePath("Arakaron/Arakaron - Android/Arakaron/src/com/arakaron/Assets/maps");
			
			mapArray = _file.getDirectoryListing();
			
			_list = UIList(UI.findViewById("maplist"));
			
			var data:XML = <data />;
			for (var file:String in mapArray) {
				if (mapArray[file].extension == "tmx") {
					var _extless:String = (mapArray[file].name).split(".")[0];
					data.appendChild(<i label={_extless}/>);
				}				
			}
			_list.xmlData = data;
			
			_list.addEventListener(UIList.CLICKED,onMapClick);			
		}
		
		public static function onMapClick (e:Event):void {
			filesRDY = 0;
			var mapName:String = _list.data[_list.index].label;
			
			var _txtFile:File;
			
			loadXML = new URLLoader();
			loadXML.addEventListener(Event.COMPLETE,loadXMLComplete);
			loadXML.load(new URLRequest(File.documentsDirectory.resolvePath("Arakaron/Arakaron - Android/Arakaron/src/com/arakaron/Assets/maps/"+mapName+".tmx").nativePath));
			
			_parseBTN = UIButton(UI.findViewById("parse"));
			_parseBTN.visible = false;
			
			_reparseBTN = UIButton(UI.findViewById("reparse"));
			_reparseBTN.visible = false;
			
			_complete = UILabel(UI.findViewById("complete"));
			
			_mName = UILabel(UI.findViewById("name"));
			_mName.htmlText = mapName;
			
			_tmxFile = UILabel(UI.findViewById("tmx"));
			_tmxFile.text = "TMX File Present: ✔";
			
			_list2 = UIList(UI.findViewById("obslist"));
			
			_sqlData = UILabel(UI.findViewById("sql"));
			if (sqlParser.sqlData.tableExists(mapName)) {
				_sqlData.text = "SQL Data Present: ✔";	
				var data:XML = <data />;
				for (var val in sqlParser.sqlData.getMaps(mapName)) {
					var obj = sqlParser.sqlData.getMaps(mapName)[val];
					data.appendChild(<i label={obj.tileAlias} data={val}/>);
				}
				_list2.xmlData = data;
			} else {
				_sqlData.text = "SQL Data Present: ✘";	
				filesRDY = 1;
			}
			
			var _canopyPNG:UILabel = UILabel(UI.findViewById("canopy"));
			_txtFile = File.documentsDirectory.resolvePath("Arakaron/Arakaron - Android/Arakaron/src/com/arakaron/Assets/maps/"+mapName+" - canopy.png"); 	
			if (_txtFile.exists) {
				_canopyPNG.text = "Canopy PNG Present: ✔";
			} else {
				_canopyPNG.text = "Canopy PNG Present: ✘";
			}
			
			var _basePNG:UILabel = UILabel(UI.findViewById("base"));
			_txtFile = File.documentsDirectory.resolvePath("Arakaron/Arakaron - Android/Arakaron/src/com/arakaron/Assets/maps/"+mapName+".png"); 	
			if (_txtFile.exists) {
				_basePNG.text = "Base PNG Present: ✔";
			} else {
				_basePNG.text = "Base PNG Present: ✘";
			}
			
			_sqlVers = UILabel(UI.findViewById("sqlversion"));
			_sqlVers.text = sqlParser.sqlData.getSQLVersion(mapName);
	
		}
		
		public static function loadXMLComplete(e:Event):void {
			mapXML = new XML(e.target.data);
			
			_tmxVers = UILabel(UI.findViewById("tmxversion"));
			_tmxVers.text = mapXML.properties.property.(attribute('name') == "mapVersion").@value;
			
			if (filesRDY == 1) {				
				_parseBTN.visible = true;
				_parseBTN.addEventListener(MouseEvent.CLICK,onParseClick);
			} else if (_tmxVers.text != _sqlVers.text) {
				_reparseBTN.visible = true;
				_reparseBTN.addEventListener(MouseEvent.CLICK,onParseClick);
			}	
		}
		
		private static function onParseClick(e:MouseEvent):void {
			var xmlProps:XMLList = mapXML.properties.property;
			
			mapInfo = new Object();
			mapInfo.mapName = xmlProps.(attribute('name') == "mapName").@value;
			mapInfo.mapVersion = xmlProps.(attribute('name') == "mapVersion").@value;
			mapInfo.mapType = xmlProps.(attribute('name') == "mapType").@value;
			mapInfo.mapWidth = mapXML.@width;
			mapInfo.mapHeight = mapXML.@height;
			
			if (xmlProps.(attribute('name') == "mapBossID").@value == "") {
				mapInfo.mapBossID = xmlProps.(attribute('name') == "mapBossID").@value;
			} else {
				mapInfo.mapBossID = "";
			}
			if (xmlProps.(attribute('name') == "mapLvlMin").@value == "") {
				mapInfo.mapLvlMin = xmlProps.(attribute('name') == "mapLvlMin").@value;
			} else {
				mapInfo.mapLvlMin = "";
			}
			if (xmlProps.(attribute('name') == "mapLvlMax").@value == "") {
				mapInfo.mapLvlMax = xmlProps.(attribute('name') == "mapLvlMax").@value;
			} else {
				mapInfo.mapLvlMax = "";
			}
			
			mapObs = mapXML.objectgroup.(@name == "Collidable").object;
			mapImmove = mapXML.objectgroup.(@name == "Immovable").object;
			sqlParser.sqlData.insertMapInfo(mapInfo,mapObs, mapImmove);
		}
	}
}