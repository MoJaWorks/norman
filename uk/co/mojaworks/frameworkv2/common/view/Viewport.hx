package uk.co.mojaworks.frameworkv2.common.view ;

import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.common.interfaces.IGameObject;
import uk.co.mojaworks.frameworkv2.common.view.Mediator;
import uk.co.mojaworks.frameworkv2.core.CoreObject;

/**
 * Game Viewport automatically resizes it's contents to fit inside a viewport
 * ...
 * @author Simon
 */
class Viewport extends Mediator<Sprite>
{
	
	public var rect( defailt, null ) : Rectangle;
	
	
	public function new( ) 
	{
		super();
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
	
	override public function step(seconds:Float):Void 
	{
		super.step(seconds);
	}
	
	override public function resize() : Void {
		
	}
			
}