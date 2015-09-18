package com.arakaron  {
	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import com.arakaron.DPad.AxisPad;
	import com.arakaron.DPad.BasePad;
	import com.arakaron.DPad.DPad;
	import com.arakaron.DPad.GroupButton;
	import com.arakaron.DPad.GroupPad;
	
	public class DirecPad extends Sprite{
		[Embed(source="Assets/DPad/axisBase01.png")]
			private var axisBasePNG:Class;
		[Embed(source="Assets/DPad/axisStick01.png")]
			private var axisStickPNG:Class;
		[Embed(source="Assets/DPad/axisStickPress01.png")]
			private var axisSticPresskPNG:Class;
		[Embed(source="Assets/DPad/buttonStick01.png")]
			private var buttonStick01PNG:Class;
		[Embed(source="Assets/DPad/buttonStickPress01.png")]
			private var buttonStickPress01PNG:Class;
		[Embed(source="Assets/DPad/buttonStick02.png")]
			private var buttonStick02PNG:Class;
		[Embed(source="Assets/DPad/buttonStickPress02.png")]
			private var buttonStickPress02PNG:Class;
		
		public var _dPad:DPad;
	
		public function DirecPad(){
			
			// <----- custom graphics
			var bmp01:BitmapData = (new axisBasePNG() as Bitmap).bitmapData;
			var bmp02:BitmapData = (new axisStickPNG() as Bitmap).bitmapData;
			var bmp03:BitmapData = (new axisSticPresskPNG() as Bitmap).bitmapData;
			var bmp04:BitmapData = (new buttonStick01PNG() as Bitmap).bitmapData;
			var bmp05:BitmapData = (new buttonStickPress01PNG() as Bitmap).bitmapData;
			var bmp06:BitmapData = (new buttonStick01PNG() as Bitmap).bitmapData;
			var bmp07:BitmapData = (new buttonStickPress01PNG() as Bitmap).bitmapData;
			var bmp08:BitmapData = (new buttonStick02PNG() as Bitmap).bitmapData;
			var bmp09:BitmapData = (new buttonStickPress02PNG() as Bitmap).bitmapData;
			
			// <----- create AxisPad - X and Y-axes
			var axisPad:AxisPad = new AxisPad(BasePad.VALIGN_BOTTOM, bmp01, bmp02, bmp03);
			
			// <----- create GroupPad - A and B buttons
			var aButton:GroupButton = new GroupButton(GroupPad.A_BUTTON, bmp06, bmp07);
			var bButton:GroupButton = new GroupButton(GroupPad.B_BUTTON, bmp08, bmp09);
			aButton.x = -120;
			aButton.y = 0;
			bButton.x = 0;
			bButton.y = 0;
			var buttons:Vector.<GroupButton> = new Vector.<GroupButton>;
			buttons.push(aButton);
			buttons.push(bButton);
			var defaultPosition:Boolean = false; // <----- use custom position
			var groupPad:GroupPad = new GroupPad(BasePad.VALIGN_BOTTOM, buttons, defaultPosition);
			
			// <----- create DPad
			_dPad = new DPad(axisPad, groupPad,false);
			this.addChild(_dPad);

			// <----- add listener
		//	this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void{
			//trace(_dPad);
		}
	}
}