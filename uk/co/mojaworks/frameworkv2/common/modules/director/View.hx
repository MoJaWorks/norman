package uk.co.mojaworks.frameworkv2.common.modules.director ;
import openfl.display.DisplayObject;
import uk.co.mojaworks.frameworkv2.core.CoreObject;
import uk.co.mojaworks.frameworkv2.common.interfaces.IGameObject;

/**
 * ...
 * @author Simon
 */
class View<T:(DisplayObject)> extends CoreObject implements IGameObject
{
	
	public var display( default, null ) : T;
	
	public function new() 
	{
		super();
	}
	
	/* INTERFACE uk.co.mojaworks.frameworkv2.interfaces.IGameObject.IGameObject<T:(DisplayObject)> */
	
	public function init():Void 
	{
		
	}
	
	public function destroy():Void 
	{
		
	}
	
	public function step(seconds:Float) : Void
	{
		
	}

	
}