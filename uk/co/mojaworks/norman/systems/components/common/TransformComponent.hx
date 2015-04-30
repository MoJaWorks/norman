package uk.co.mojaworks.norman.systems.components.common;

import uk.co.mojaworks.norman.systems.components.Component;

/**
 * ...
 * @author Simon
 */
class TransformComponent extends Component
{

	public static inline var ID : String = "Transform";
	
	public var x : Float = 0;
	public var y : Float = 0;
	public var z : Float = 0;
	public var scaleX : Float = 1;
	public var scaleY : Float = 1;
	public var rotation : Float = 0;
	
	public function new() 
	{
		super(ID);
	}
	
	
	
}