package{
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	import flash.system.*;
	
	public class sqlParser extends Sprite{
		[Embed(source="Assets/Button-UP.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
			protected static const BTN_UP:Class;
		[Embed(source="Assets/Button-DOWN.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
			protected static const BTN_DOWN:Class;
		
		[Embed(source="Assets/Window.png",
      			scaleGridTop="16", scaleGridBottom="48",
      			scaleGridLeft="16", scaleGridRight="48")]
			protected static const WNDW:Class;
		
		protected static const ITEM_VIEW:XML = <label>Hi</label>
		
		protected static const Nav:XML = <tabPages alt="true" id="tabs">
			{mapManager.MAP_VIEW}
			{gearManager.GEAR_VIEW}
			{allyManager.ALLY_VIEW}
		</tabPages>;
		
		protected static const popup_layout:XML = <vertical><skin>{getQualifiedClassName(WNDW)}</skin><label id="pop">Hello there</label>
					<label id="pop">Hello there</label></vertical>;
			
		protected var _nav:UITabPages
		
		public static var sqlData:sqlManager;
		
		public function sqlParser(){
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			sqlData = new sqlManager();
			
			UIe.activate(this);
			UI.extend(["textbtn"],[textButton]);
			//UI.create(this, Nav);
			
			trace (System.totalMemory);
			UI.create(this, Nav);
			trace (System.totalMemory);
			_nav = UITabPages(UI.findViewById("tabs"));
			
			_nav.setTab(0,"Map Parser",null);
			_nav.setTab(1,"Gear Parser",null);
			_nav.setTab(2,"Allies Parser",null);
			_nav.button(0).addEventListener(MouseEvent.CLICK,mapManager.onDisplay);
			_nav.button(1).addEventListener(MouseEvent.CLICK,gearManager.onDisplay);
			_nav.button(2).addEventListener(MouseEvent.CLICK,allyManager.onDisplay);
			
			mapManager.onDisplay(null);
		}
		
		public static function redraw():void {
			UI.redraw();
		}
		
	}
}