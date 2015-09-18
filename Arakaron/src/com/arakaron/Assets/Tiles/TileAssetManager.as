package com.arakaron.Assets.Tiles{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	import org.osmf.logging.Log;
	
	public class TileAssetManager extends Sprite{
		
		[Embed(source='Images/Chests.png')]
			public static var chests:Class;
		[Embed(source='Images/Crates.png')]
			public static var crates:Class;
		[Embed(source='Images/Doors.png')]
			public static var doors:Class;
		[Embed(source='Images/Ore.png')]
			public static var ores:Class;
		[Embed(source='Images/Signs.png')]
			public static var signs:Class;
			
		[Embed(source='Images/Animations1.png')]
			public static var smallAnimation:Class;
		[Embed(source='Images/Animations2.png')]
			public static var mediumAnimation:Class;
		[Embed(source='Images/Animations3.png')]
			public static var largeAnimation:Class;
			
		public function TileAssetManager(){
			super();
		}
		
		public static function GetImage(name:String):Bitmap {
			return new TileAssetManager[name]() as Bitmap;
		}
		
	}
}