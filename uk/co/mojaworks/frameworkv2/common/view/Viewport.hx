package uk.co.mojaworks.frameworkv2.common.view ;

import openfl.display.Sprite;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.components.Display;
import uk.co.mojaworks.frameworkv2.core.Component;

/**
 * Game Viewport automatically resizes it's contents to fit inside a viewport
 * ...
 * @author Simon
 */
class Viewport extends Display
{
	
	public var stageRect( default, null ) : Rectangle;
	public var displayRect( default, null ) : Rectangle;
	public var display : Sprite;
	
	public function new( ) 
	{
		super();
		
		stageRect = new Rectangle();
		displayRect = new Rectangle();
		
		init();
		resize();
	}
	
	override public function init():Void 
	{
		super.init();
		display = new Sprite();		
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
	override public function onUpdate(seconds:Float):Void 
	{
		super.onUpdate(seconds);
	}
	
	public function resize() : Void {
		
	}
			
}