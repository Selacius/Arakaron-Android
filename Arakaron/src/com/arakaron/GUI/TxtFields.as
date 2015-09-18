package com.arakaron.GUI{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	
	public class TxtFields extends TextField{
		
		public function TxtFields(txtfrmt:String, width:int, height:int, multiline:Boolean, border:Boolean){
			super();
			
			this.embedFonts = true;
			this.width = width;
			this.height = height;
			this.multiline = multiline;
			if (this.multiline) {
				this.wordWrap = true;
			}
			this.selectable = false;
			this.border = border;
			this.borderColor = 0xFFFFFF;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.defaultTextFormat = txtformat(txtfrmt);
		}
		
		public function txtformat(format:String):TextFormat {
			var txtfrmt:TextFormat = new TextFormat();
			txtfrmt.font = "blackchancery";
			switch (format) {
				case "Preloader":
					txtfrmt.color = 0xFFFFFF
					txtfrmt.size = 30;
					txtfrmt.align = "center";
					break;
				case "Menu":
					txtfrmt.leftMargin = 2;					
					txtfrmt.leading = 0;
					txtfrmt.color = 0xFFFFFF
					txtfrmt.size = 20;
					txtfrmt.align = "left";
					break;
				case "Menu-right":
					txtfrmt.rightMargin = 5;
					txtfrmt.leading = 0;
					txtfrmt.color = 0xFFFFFF
					txtfrmt.size = 20;
					txtfrmt.align = "right";
					break;
				case "DisplayName":
					txtfrmt.leftMargin = 5;
					txtfrmt.leading = 0;
					txtfrmt.color = 0xFFFFFF
					txtfrmt.size = 22;
					txtfrmt.align = "center";
					break;
				case "Button-small":
					txtfrmt.color = 0xFFFFFF;
					txtfrmt.size = 18;
					txtfrmt.align = "center";
					this.selectable = false;
					this.autoSize = TextFieldAutoSize.LEFT;
					break;
				case "Button-medium":
					txtfrmt.color = 0xFFFFFF;
					txtfrmt.size = 20;
					txtfrmt.align = "center";
					this.selectable = false;
					this.autoSize = TextFieldAutoSize.LEFT;
					break;
				case "Button-large":
					txtfrmt.color = 0xFFFFFF;
					txtfrmt.size = 23;
					txtfrmt.align = "center";
					this.selectable = false;
					this.autoSize = TextFieldAutoSize.LEFT;
					break;
				case "RegText":
					txtfrmt.color = 0xFFFFFF;
					txtfrmt.size = 18;
					txtfrmt.align = "center";
					break;
				case "Message":
					this.autoSize = TextFieldAutoSize.LEFT;
					txtfrmt.color = 0xFFFFFF;
					txtfrmt.size = 21;
					txtfrmt.align = "center";
					break;
				case "ToolTip":
					this.autoSize = TextFieldAutoSize.LEFT;
					txtfrmt.color = 0xFFFFFF;
					txtfrmt.size = 15;
					txtfrmt.rightMargin = 5;
					txtfrmt.align = "left";
					break;
				case "ToolTip2":
					this.autoSize = "none";
					this.wordWrap = true;
					txtfrmt.color = 0xFFFFFF;
					txtfrmt.size = 14;
					txtfrmt.rightMargin = 5;
					txtfrmt.leftMargin = 2;
					txtfrmt.align = "left";
					break;
				case "ToolTip3":
					this.autoSize = TextFieldAutoSize.LEFT;
					this.wordWrap = true;
					txtfrmt.color = 0xFFFFFF;
					txtfrmt.size = 16;
					txtfrmt.rightMargin = 5;
					txtfrmt.leftMargin = 2;
					txtfrmt.align = "center";
					break;
			}
			return (txtfrmt);
		}
	}
}