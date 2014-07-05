package uk.co.mojaworks.frameworkv2.components ;

import openfl.geom.Matrix;
import uk.co.mojaworks.frameworkv2.core.Component;
import uk.co.mojaworks.frameworkv2.core.GameObject;

/**
 * ...
 * @author Simon
 */
class Transform extends Component
{

	public var x( default, set ) : Float = 0;
	public var y( default, set ) : Float = 0;
	
	public var scaleX( default, set ) : Float = 1;
	public var scaleY( default, set ) : Float = 1;
	
	public var rotation( default, set ) : Float = 0;
	
	public var globalTransform( default, null ) : Matrix;
	public var localTransform( default, null ) : Matrix;
	
	var _isLocalDirty : Bool = true;
	var _isGlobalDirty : Bool = true;
	
	public function new() 
	{
		super();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		gameObject.messenger.attachListener( GameObject.ADDED_AS_CHILD, onAddedToParent );
	}
	
	private function onAddedToParent( object : GameObject, ?param : Dynamic ) : Void {
		trace("Added to parent");
	}
	
}