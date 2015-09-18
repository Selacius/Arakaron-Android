package com.arakaron{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import org.osmf.logging.Log;
	
	public class AssetManager extends Sprite{
		[Embed(source='Assets/Graphics/Logo.png')]
			public static var logo:Class;
		[Embed(source='Assets/Graphics/Menu.png')]
			public static var menu:Class;	
		[Embed(source='Assets/Graphics/Window.png')]
			public static var window:Class;	
		[Embed(source='Assets/Graphics/StatusIcon.png')]
			public static var status:Class;	
			
		[Embed(source='Assets/Graphics/Armors.png')]
			public static var armors:Class;
		
		[Embed(source='Assets/Graphics/characters/Actor1.png')]
			public static var actor1:Class;
		[Embed(source='Assets/Graphics/characters/Actor1 - Faces.png')]
			public static var actor1_face:Class;
			
		[Embed(source='Assets/calibri.ttf', fontName='Calibri', mimeType='application/x-font', embedAsCFF='false')] 
			public var calibri:Class;
		[Embed(source='Assets/calibri - bold.ttf', fontWeight='Bold', fontName='CalibriBold', mimeType='application/x-font', embedAsCFF='false')] 
			public var calibriBold:Class;
			
		[Embed(source='Assets/BLKCHCRY.ttf', fontName='BlackChancery', mimeType='application/x-font', embedAsCFF='false')] 
			public var blackchancery:Class;
		
		public function AssetManager() {
			super ();
		}
			
		public static function GetImage(name:String):Bitmap {
			return new AssetManager[name]() as Bitmap;
		}
	
	}
}