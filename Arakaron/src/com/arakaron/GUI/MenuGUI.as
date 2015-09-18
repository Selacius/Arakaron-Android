package com.arakaron.GUI{
	import flash.events.MouseEvent;

	public interface MenuGUI{
		function onAddedToStage():void;
		function onRemovedFromStage():void;
		function drawGUI():void;
		function onExitClick(e:MouseEvent):void;
	}
}