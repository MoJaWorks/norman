package uk.co.mojaworks.norman.components ;

import lime.math.Matrix3;
import lime.math.Matrix4;
import lime.math.Vector2;
import lime.math.Vector4;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class Transform extends Component
{

	public static inline var CHILD_ADDED : String = "CHILD_ADDED";
	public static inline var CHILD_REMOVED : String = "CHILD_REMOVED";
	static public inline var ADDED_AS_CHILD : String = "ADDED_AS_CHILD";
	static public inline var REMOVED_AS_CHILD : String = "REMOVED_AS_CHILD";
	
	public static inline var MATRIX_DIRTY : String = "MATRIX_DIRTY";
	
	public var parent( default, set ) : Transform;
	public var children( default, null ) : Array<Transform>;
	
	public var x( default, set ) : Float = 0;
	public var y( default, set ) : Float = 0;
	public var z( default, set ) : Float = 0;
	
	public var pivotX( default, set ) : Float = 0;
	public var pivotY( default, set ) : Float = 0;
	public var pivotZ( default, set ) : Float = 0;
	
	public var paddingX( default, set ) : Float = 0;
	public var paddingY( default, set ) : Float = 0;
	
	public var scaleX( default, set ) : Float = 1;
	public var scaleY( default, set ) : Float = 1;
	
	// Set in radians, converted to quarternians for calculations
	public var rotationX( default, set ) : Float = 0;
	public var rotationY( default, set ) : Float = 0;
	public var rotationZ( default, set ) : Float = 0;
	
	// This is just an alias for rotationZ
	public var rotation( get, set ) : Float;
	
	public var worldTransform( get, never ) : Matrix4;
	public var inverseWorldTransform( get, never ) : Matrix4;
	public var localTransform( get, never ) : Matrix4;
	public var renderTransform( get, never ) : Matrix4;

	
	var _worldTransform : Matrix4;
	var _inverseWorldTransform : Matrix4;
	var _localTransform : Matrix4;
	var _renderTransform : Matrix4;
	
	var _isLocalDirty : Bool = true;
	var _isWorldDirty : Bool = true;
	
	
	/**
	 * 
	 */
	
	public function new() 
	{
		super();
		
		_worldTransform = new Matrix4();
		_localTransform = new Matrix4();
		_inverseWorldTransform = new Matrix4();
		_renderTransform = new Matrix4();
		
		children = new Array<Transform>();
		
	}
		
	/**
	 * 
	 * @param	local
	 * @param	world
	 */
	
	public function invalidateMatrices( local : Bool = true, world : Bool = true ) : Void {
		
		var update : Bool = !_isLocalDirty && !_isWorldDirty;
		_isLocalDirty = local;
		_isWorldDirty = world;
		
		if ( update ) {
			for ( child in children ) {
				child.invalidateMatrices( false, true );
			}
		}
		
		gameObject.messenger.sendMessage( MATRIX_DIRTY );
	}	
	
	private function recalculateLocalTransform() : Void {
		_localTransform.identity();
		_localTransform.prependTranslation( paddingX, paddingY, 0 );
		_localTransform.prependTranslation( -pivotX, -pivotY, 0 );
		_localTransform.prependScale( scaleX, scaleY, 1 );
		_localTransform.prependRotation( rotationZ * MathUtils.RAD2DEG, Vector4.Z_AXIS );
		_localTransform.prependRotation( rotationY * MathUtils.RAD2DEG, Vector4.Y_AXIS );
		_localTransform.prependRotation( rotationX * MathUtils.RAD2DEG, Vector4.X_AXIS );
		_localTransform.prependTranslation( x, y, z );
		_isLocalDirty = false;
	}
	
	private function recalculateWorldTransform() : Void {
		
		if ( _isLocalDirty ) recalculateLocalTransform();
		_worldTransform.copyFrom( _localTransform );
		_renderTransform.identity();
		
		// If an object is masked, global transforms will all be in this coordinate
		//var isMasked : Bool = gameObject.sprite != null && gameObject.sprite.clipRect != null;
		
		if ( parent != null ) {
			_worldTransform.prepend( parent.worldTransform );
			//if ( !isMasked ) {
				//_renderTransform.copyFrom( _localTransform );
				//_renderTransform.concat( parent.renderTransform );
			//}else {
				//_renderTransform.translate( -gameObject.sprite.clipRect.x, -gameObject.sprite.clipRect.y );
			//}
		//}else {
			//_renderTransform.copyFrom( _worldTransform );
		}
			
		_inverseWorldTransform.copyFrom(_worldTransform);
		_inverseWorldTransform.invert();
		
		_isWorldDirty = false;
		
	}
	
	/**
	 * Centers the pivot based on the display
	 */
	
	public function centerPivot() : Transform {
		if ( gameObject.has(Sprite) ) {
			setPivot( gameObject.sprite.getNaturalWidth() * 0.5, gameObject.sprite.getNaturalHeight() * 0.5 );
		}else {
			setPivot(0, 0);
		}
		
		return this;
	}
	
	/**
	 * Convenience
	 */
	
	public function setPosition( x : Float, y : Float, z : Float = 0 ) : Transform {
		this.x = x;
		this.y = y;
		this.z = z;
		return this;
	}
	
	public function setScale( scale : Float ) : Transform {
		this.scaleX = this.scaleY = scale;
		return this;
	}
	
	public function setScaleXY( scaleX : Float, scaleY : Float ) : Transform {
		this.scaleX = scaleX;
		this.scaleY = scaleY;
		return this;
	}
	
	public function setPivot( x : Float, y : Float ) : Transform {
		pivotX = x;
		pivotY = y;
		return this;
	}
	
	public function setPadding( x : Float, y : Float ) : Transform {
		paddingX = x;
		paddingY = y;
		return this;
	}
	
	/**
	 * Getters
	 */
	
	private function get_worldTransform( ) : Matrix4 {
		
		if ( _isWorldDirty || _isLocalDirty ) {
			recalculateWorldTransform();
		}
		return _worldTransform;
	}
	
	private function get_localTransform( ) : Matrix4 {
		
		if ( _isLocalDirty ) {
			recalculateLocalTransform();
		}
		return _localTransform;
	}
	
	private function get_inverseWorldTransform( ) : Matrix4 {
		
		if ( _isWorldDirty || _isLocalDirty ) {
			recalculateWorldTransform();
		}
		return _inverseWorldTransform;
	}
	
	private function get_renderTransform() : Matrix4 {
		
		if ( _isWorldDirty || _isLocalDirty ) {
			recalculateWorldTransform();
		}
		return _renderTransform;
	}
	
	public function localToGlobal( point : Vector4 ) : Vector4 {
		return worldTransform.transformVector( point );
	}
	
	public function globalToLocal( point : Vector4 ) : Vector4 {
		return inverseWorldTransform.transformVector( point );
	}
	
	/**
	 * Setters
	 */
		
	private function set_x( _x : Float ) : Float { x = _x; invalidateMatrices(); return x; }
	private function set_y( _y : Float ) : Float { y = _y; invalidateMatrices(); return y; }
	private function set_z( _z : Float ) : Float { z = _z; invalidateMatrices(); return z; }
	private function set_pivotX( _pivotX : Float ) : Float { pivotX = _pivotX; invalidateMatrices(); return pivotX; }
	private function set_pivotY( _pivotY : Float ) : Float { pivotY = _pivotY; invalidateMatrices(); return pivotY; }
	private function set_pivotZ( _pivotZ : Float ) : Float { pivotZ = _pivotZ; invalidateMatrices(); return pivotZ; }
	private function set_paddingX( _paddingX : Float ) : Float { paddingX = _paddingX; invalidateMatrices(); return paddingX; }
	private function set_paddingY( _paddingY : Float ) : Float { paddingY = _paddingY; invalidateMatrices(); return paddingY; }
	private function set_scaleX( _scaleX : Float ) : Float { scaleX = _scaleX; invalidateMatrices(); return scaleX; }
	private function set_scaleY( _scaleY : Float ) : Float { scaleY = _scaleY; invalidateMatrices(); return scaleY; }
	private function set_rotationX( _rotation : Float ) : Float { rotationX = _rotation; invalidateMatrices(); return rotation; }
	private function set_rotationY( _rotation : Float ) : Float { rotationY = _rotation; invalidateMatrices(); return rotation; }
	private function set_rotationZ( _rotation : Float ) : Float { rotationZ = _rotation; invalidateMatrices(); return rotation; }
	private function set_rotation( _rotation : Float ) : Float { rotationZ = _rotation; invalidateMatrices(); return rotation; }
	private function get_rotation( ) : Float { return rotationZ; }
	
	
	/**
	 * CHILDREN
	 */
	
	public function addChild( child : Transform ) : Void {
		
		if ( child.parent != null ) {
			child.parent.removeChild( child );
		}
		child.parent = this;
		children.push( child );
		gameObject.messenger.sendMessage( CHILD_ADDED, child.gameObject );
		child.gameObject.messenger.sendMessage( ADDED_AS_CHILD );
		
	}
	
	public function removeChild( child : Transform ) : Void {
		
		children.remove( child );
		gameObject.messenger.sendMessage(CHILD_REMOVED, child.gameObject);
		child.gameObject.messenger.sendMessage(REMOVED_AS_CHILD);
		child.parent = null;
		
	}
	
	public function set_parent( parent : Transform ) : Transform {
		
		parent.addChild( this );
		return parent;
		
	}
	
	/**
	 * Destroy
	 */
	
	override public function destroy() : Void {
		
		super.destroy();
		
		_worldTransform = null;
		_localTransform = null;
		_renderTransform = null;
		_inverseWorldTransform = null;
		
		for ( child in children ) {
			child.gameObject.destroy();
		}
	}
	
}