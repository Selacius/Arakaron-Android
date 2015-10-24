package
{
	import com.danielfreeman.extendedMadness.UIImage9;
	import com.danielfreeman.madcomponents.*;
	import com.danielfreeman.madcomponents.IComponentUI;
	import com.danielfreeman.madcomponents.MadSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	public class textButton extends MadSprite implements IComponentUI{
		[Embed(source="Assets/Button-UP.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTN_DOWN:Class;
		[Embed(source="Assets/Button-DOWN.png",
      			scaleGridTop="12", scaleGridBottom="20",
      			scaleGridLeft="12", scaleGridRight="30")]
		protected static const BTN_UP:Class;
		
		protected var txtLabel:UILabel;
		protected var _up:UIImage9;
		protected var _down:UIImage9;
		
		public function textButton(screen:Sprite, xml:XML, attributes:Attributes = null){
			super(screen);
			
			txtLabel = new UILabel(this,0,0,xml.toString(),new TextFormat("Tahoma", 17, 0xFFFFFF));
			var childAttributes:Attributes = new Attributes(0,0,txtLabel.width+15, txtLabel.height+15);
			
			_up = new UIImage9(this,<text>{getQualifiedClassName(BTN_UP)}</text>, childAttributes);
			
			_down = new UIImage9(this,<text>{getQualifiedClassName(BTN_DOWN)}</text>,childAttributes);
			_down.visible = false;
			
			this.swapChildrenAt(0,2);
			
			txtLabel.y = (_up.height - txtLabel.height)/2 - 2.5;
			txtLabel.x = (_up.width - txtLabel.width)/2 - 2;
				
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		public function onMouseDown(e:MouseEvent):void {
			
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
		}
	}
}