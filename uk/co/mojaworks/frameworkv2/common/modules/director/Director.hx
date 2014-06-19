package uk.co.mojaworks.frameworkv2.common.modules.director ;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import uk.co.mojaworks.frameworkv2.core.CoreObject;
import uk.co.mojaworks.frameworkv2.core.IModule;

/**
 * ...
 * @author Simon
 */
class Director extends CoreObject implements IModule
{
	
	var _stack : Array<View<DisplayObject>>;
	
	public var root(default, null) : Sprite;
	
	public function new() 
	{
		super();
		_stack = [];
		
		root = new Sprite();
	}
	
	public function resize( ) : Void {
		// Send the resize message to the stack
	}
	
}