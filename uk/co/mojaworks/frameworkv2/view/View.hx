package uk.co.mojaworks.frameworkv2.view;
import openfl.display.DisplayObject;
import uk.co.mojaworks.frameworkv2.core.Core;

/**
 * ...
 * @author Simon
 */
class View<T:(DisplayObject)>
{
	
	public var display : T;
	
	var core( get, never ) : Core;
	function get_core() : Core { return Core.instance };

	public function new<T>() 
	{
		
	}
	
}