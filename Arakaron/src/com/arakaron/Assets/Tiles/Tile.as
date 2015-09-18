package com.arakaron.Assets.Tiles{
	public interface Tile{
		function onAddedtoStage():void;
		function onRemovedFromStage():void;
		function onInteract():void;
		function onTouch():void;
	}
}