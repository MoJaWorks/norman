package uk.co.mojaworks.frameworkv2.common.modules.director ;

import openfl.display.DisplayObject;
import uk.co.mojaworks.frameworkv2.core.CoreObject;
import uk.co.mojaworks.frameworkv2.core.IModule;

/**
 * ...
 * @author Simon
 */
class Director extends CoreObject implements IModule
{
	
	var _stack : Array<View<DisplayObject>>;
	
	public function new() 
	{
		super();
		_stack = [];
	}
	
}