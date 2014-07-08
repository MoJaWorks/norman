package flash.display;
import openfl.Vector;

#if ( display || flash ) 

import flash.display.DisplayObjectContainer;

/**
 * ...
 * @author Simon
 */
extern class Stage extends DisplayObjectContainer
{
	public var stage3Ds : Vector<Stage3D>;
}

#end