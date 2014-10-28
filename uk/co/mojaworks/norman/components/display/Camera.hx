package uk.co.mojaworks.norman.components.display;

import lime.math.Rectangle;
import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */

enum CameraMode {
	Perspective;
	Orthographic;
}
 
class Camera extends Component
{
	
	public var mode : CameraMode;
	public var near : Float = -100;
	public var far : Float = 100;
	
	// Only used in orthographic mode
	public var rect : Rectangle;
	
	// Only used in perspective mode
	
	

	public function new() 
	{
		super();
	}
	
}