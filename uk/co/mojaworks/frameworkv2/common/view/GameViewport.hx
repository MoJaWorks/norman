package uk.co.mojaworks.frameworkv2.common.view ;

import openfl.display.Sprite;
import openfl.display.Stage;
import uk.co.mojaworks.frameworkv2.common.interfaces.IGameObject;
import uk.co.mojaworks.frameworkv2.common.view.DisplayWrapper;
import uk.co.mojaworks.frameworkv2.core.CoreObject;

/**
 * Game Viewport automatically resizes it's contents to fit inside a viewport
 * ...
 * @author Simon
 */
class GameViewport extends DisplayWrapper<Sprite>
{
	var stage : Stage;
	
	public function new( stage : Stage ) 
	{
		super();
		
		this.stage = stage;
		init();
		
		resize();
	}
	
	/* INTERFACE uk.co.mojaworks.frameworkv2.common.interfaces.IGameObject */
	
	override public function init():Void 
	{
		super.init();
		display = new Sprite();
		
	}
	
	public function destroy():Void 
	{
		super.destroy();
	}
	
	public function step(seconds:Float):Void 
	{
		super.step(seconds);
	}
			
}