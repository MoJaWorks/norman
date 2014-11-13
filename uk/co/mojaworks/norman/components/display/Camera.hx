package uk.co.mojaworks.norman.components.display ;

import lime.math.Matrix4;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.view.GameObject;
 
enum CameraMode {
	Orthographic;
	Perspective;
}

class Camera extends Component
{
	
	public var mode(default, set) : CameraMode;
	public var near(default, set) : Float = -100;
	public var far(default, set) : Float = 100;
	public var projectionMatrix(get, null) : Matrix4;	
	
	// Only used in orthographic mode
	private var left(default, set) : Float;
	private var right(default, set) : Float;
	private var top(default, set) : Float;
	private var bottom(default, set) : Float;
	
	// Only used in perspective mode - not implemented yet but may be in future
	//public var fieldOfView : Float;
	
	private var _projectionMatrixDirty = true;
	

	public function new( ) 
	{
		super(  );
	}
	
	public function set_mode( mode : CameraMode ) : CameraMode {
		this.mode = mode;
		_projectionMatrixDirty = true;
		return mode;
	}
	
	public function set_near( near : Float ) : Float {
		this.near = near;
		_projectionMatrixDirty = true;
		return near;
	}
	
	public function set_far( far : Float ) : Float {
		this.far = far;
		_projectionMatrixDirty = true;
		return far;
	}
	
	public function set_left( left : Float ) : Float {
		this.left = left;
		_projectionMatrixDirty = true;
		return left;
	}
	
	public function set_right( right : Float ) : Float {
		this.right = right;
		_projectionMatrixDirty = true;
		return right;
	}
	
	public function set_top( top : Float ) : Float {
		this.top = top;
		_projectionMatrixDirty = true;
		return far;
	}
	
	public function set_bottom( bottom : Float ) : Float {
		this.bottom = bottom;
		_projectionMatrixDirty = true;
		return bottom;
	}
	
	public function get_projectionMatrix() : Matrix4 {
		if ( _projectionMatrixDirty ) {
			switch( mode ) {
				case CameraMode.Orthographic:
					projectionMatrix = Matrix4.createOrtho( left, right, top, bottom, near, far );
					
				case CameraMode.Perspective:
					// Not implemented yet
			}
		}
		
		return projectionMatrix;
	}
	
	
	
}