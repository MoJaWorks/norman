package uk.co.mojaworks.frameworkv2.common.view;
import openfl.display.DisplayObject;
import uk.co.mojaworks.frameworkv2.common.interfaces.IGameObject;
import uk.co.mojaworks.frameworkv2.core.CoreObject;

/**
 * @author Simon
 */

class DisplayWrapper<T:(DisplayObject)> extends CoreObject implements IGameObject
{
	var display( default, null ) : T;
	
	public function new() {
		super();
	}
	
	/* INTERFACE uk.co.mojaworks.frameworkv2.common.interfaces.IGameObject */
	
	public function init():Void 
	{
		
	}
	
	public function destroy():Void 
	{
		
	}
	
	public function step(seconds:Float):Void 
	{
		
	}
	
}