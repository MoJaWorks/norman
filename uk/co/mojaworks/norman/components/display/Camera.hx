package uk.co.mojaworks.norman.components.display ;

import lime.math.Matrix4;
 
enum CameraMode {
	Orthographic;
	Perspective;
}

class Camera
{
	
	public var mode(default, set) : CameraMode;
	public var near(default, set) : Float = -100;
	public var far(default, set) : Float = 100;
	public var matrix(get, null) : Matrix4;	
	
	// Only used in orthographic mode
	private var left(default, set) : Float;
	private var right(default, set) : Float;
	private var top(default, set) : Float;
	private var bottom(default, set) : Float;
	
	// Only used in perspective mode - not implemented yet but may be in future
	//public var fieldOfView : Float;
	
	private var _matrixDirty = true;
	

	public function new() 
	{
		super();
	}
	
	public function set_mode( mode : CameraMode ) : CameraMode {
		this.mode = mode;
		_matrixDirty = true;
		return mode;
	}
	
	public function set_near( near : Float ) : Float {
		this.near = near;
		_matrixDirty = true;
		return near;
	}
	
	public function set_far( far : Float ) : Float {
		this.far = far;
		_matrixDirty = true;
		return far;
	}
	
	public function set_left( left : Float ) : Float {
		this.left = left;
		_matrixDirty = true;
		return left;
	}
	
	public function set_right( right : Float ) : Float {
		this.right = right;
		_matrixDirty = true;
		return right;
	}
	
	public function set_top( top : Float ) : Float {
		this.top = top;
		_matrixDirty = true;
		return far;
	}
	
	public function set_bottom( bottom : Float ) : Float {
		this.bottom = bottom;
		_matrixDirty = true;
		return bottom;
	}
	
	public function get_matrix() : Matrix4 {
		if ( _matrixDirty ) {
			switch( mode ) {
				case CameraMode.Orthographic:
					matrix = Matrix4.createOrtho( left, right, top, bottom, near, far );
					
				case CameraMode.Perspective:
					// Not implemented yet
			}
		}
		
		return matrix;
	}
	
	
	
}