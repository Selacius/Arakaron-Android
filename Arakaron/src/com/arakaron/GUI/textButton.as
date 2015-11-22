package com.arakaron.GUI{
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	public class textButton extends MadSprite implements IComponentUI{
		[Embed(source="../Assets/Graphics/Button-UP.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTNUP:Class;
		
		[Embed(source="../Assets/Graphics/Button-DOWN.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTNDOWN:Class;
		
		[Embed(source="../Assets/Graphics/Exit-DOWN.png")]
			protected static const EXITDOWN:Class;
		[Embed(source="../Assets/Graphics/Exit-UP.png")]
			protected static const EXITUP:Class;
			
		protected var txtLabel:TxtFields;
		protected var _up:UIImage9;
		protected var _down:UIImage9;
		
		public function textButton(screen:Sprite, xml:XML, attributes:Attributes = null){
			super(screen);
			
			if (xml.@type == "Exit") {
				var childAttributes:Attributes = new Attributes(0,0,18,18);
				
				_up = new UIImage9(this,<text>{getQualifiedClassName(EXITUP)}</text>, childAttributes);			
				
				_down = new UIImage9(this,<text>{getQualifiedClassName(EXITDOWN)}</text>,childAttributes);
				_down.visible = false;
			} else {			
				txtLabel = new TxtFields("Button-"+xml.@size,10,10,false,false);
				txtLabel.text = xml.toString();
				this.addChild(txtLabel);
				
				var childAttributes:Attributes = new Attributes(0,0,txtLabel.width+15, txtLabel.height+10);
				
				_up = new UIImage9(this,<text>{getQualifiedClassName(BTNUP)}</text>, childAttributes);			
				
				_down = new UIImage9(this,<text>{getQualifiedClassName(BTNDOWN)}</text>,childAttributes);
				_down.visible = false;
				this.swapChildrenAt(0,2);
				
				txtLabel.y = (_up.height - txtLabel.height)/2;
				txtLabel.x = (_up.width - txtLabel.width)/2;
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);			
		}
		
		public function mouseDown(e:MouseEvent):void {
			_up.visible = false;
			_down.visible = true;
		}
		
		public function mouseUp(e:MouseEvent):void {
			_up.visible = true;
			_down.visible = false;
		}
		
		override public function layout(attributes:Attributes):void{
		}
		
		override public function get attributes():Attributes{
			return null;
		}
		
		override public function destructor():void{
			_up = null
			_down = null;
			txtLabel = null;
			
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);	
		}
	}
}