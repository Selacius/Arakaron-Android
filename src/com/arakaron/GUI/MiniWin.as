package com.arakaron.GUI{
	import com.arakaron.Arakaron;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class MiniWin extends Sprite{
		public var displayQueue:Array = new Array();
		
		private var txtFLD:TextField;
		private var background:WindowBox;
		
		public function MiniWin(){
			super();
			this.visible = false;
			this.txtFLD = new TxtFields("Message",50,50,false,false);
		}
		
		public function updateWin(txt:String, runOnce:Boolean):void {
			if (this.visible) {
				if (runOnce == false) {
					this.displayQueue.push(txt);
				}
			} else {
				this.visible = true;
				this.txtFLD.text = txt;
				
				this.alpha = 0.1;
				
				loadGUI();
			}
		}
		
		private function loadGUI():void {
			this.background = new WindowBox(0,0,this.txtFLD.height+16,this.txtFLD.width+29, 1.0);
			this.addChild(this.background)
			
			this.txtFLD.x = 14;
			this.txtFLD.y = 8;
			this.addChild(this.txtFLD);
			
			this.x = com.arakaron.Arakaron.StageWidth/2 - this.width/2;
			this.y = com.arakaron.Arakaron.StageHeight/2 - this.height/2;
		}
		
		public function EnterFrame():void {
			if (this.alpha <= 1.0) {
				this.alpha += 0.1;
			} else if (this.alpha > 1 && this.alpha < 5.0) {
				this.alpha += 0.075;
			} else {
				this.alpha = 0.1;
				this.removeChild(this.background);
				this.removeChild(this.txtFLD);
				this.visible = false;
				if (this.displayQueue.length > 0) {
					this.updateWin(displayQueue[0], false);
					this.displayQueue.splice(0,1);
				}
			}
		}
	}
}