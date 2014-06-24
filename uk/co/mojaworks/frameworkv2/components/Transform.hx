package uk.co.mojaworks.frameworkv2.components ;

import openfl.geom.Matrix;
import uk.co.mojaworks.frameworkv2.core.Component;

/**
 * ...
 * @author Simon
 */
class Transform extends Component
{

	public var x : Float = 0;
	public var y : Float = 0;
	
	public var scaleX : Float = 1;
	public var scaleY : Float = 1;
	
	public var rotation : Float = 0;
	
	//public var globalTransform( get, null ) : Matrix;
	//public var localTransform( get, null ) : Matrix;
	
	var _isLocalDirty : Bool = true;
	var _isGlobalDirty : Bool = true;
	
	public function new() 
	{
		super();
	}
	
}