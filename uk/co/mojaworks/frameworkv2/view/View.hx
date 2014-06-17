package uk.co.mojaworks.frameworkv2.view;
import openfl.display.DisplayObject;
import uk.co.mojaworks.frameworkv2.core.CoreObject;

/**
 * ...
 * @author Simon
 */
class View<T:(DisplayObject)> extends CoreObject
{
	
	public var display : T;
	
	public function new() 
	{
		
	}
	
}